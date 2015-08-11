require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# create the table for the test in the database
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'my_models'")
ActiveRecord::Base.connection.create_table(:my_models) do |t|
  t.string :class
  t.string :bad_attribute
  t.string :good_attribute
  # bad because of changed and changed? in ActiveModel
  t.string :changed
  # bad because normally it generates DangerousAttributeError
  t.string :errors
  # support hyphenated column names
  t.string :"comment-frequency"
  # Issue #8
  t.string :association
end

class MyModel < ActiveRecord::Base
  include SafeAttributes
  bad_attribute_names :bad_attribute, :bad_attribute=
  validates_presence_of :class
end

ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'my_users'")
ActiveRecord::Base.connection.create_table(:my_users) do |t|
  t.string :encrypted_password
end

class MyUser < ActiveRecord::Base
  include SafeAttributes::Base
  attr_reader :password
  def password=(p)
    @password = p
    self.encrypted_password = p
  end

  validates_presence_of :password
end

describe "models" do

  before(:each) do
    @model = MyModel.new
  end

  after(:each) do
    MyModel.delete_all
  end

  it "inspecting class returns expected attribute names" do
    expect(MyModel.inspect).to match 'class: string'
  end

  it "inspecting instance returns expected attribute names" do
    expect(@model.inspect).to match 'class: nil'
  end

  it "does not redefine class()" do
    expect(@model.class.name).to eq('MyModel')
  end

  it "defines class=()" do
    @model.respond_to?(:class=) # to force method generation
    expect(@model.methods.include?('class=') || @model.methods.include?(:class=)).to be true
  end

  it "does not define bad_attribute()" do
    @model.respond_to?(:bad_attribute) # to force method generation
    expect(@model.methods.include?('bad_attribute') || @model.methods.include?(:bad_attribute)).to be false
  end

  it "does not define bad_attribute=()" do
    @model.respond_to?(:bad_attribute=) # to force method generation
    expect(@model.methods.include?('bad_attribute=') || @model.methods.include?(:bad_attribute=)).to be false
  end

  it "does define good_attribute()" do
    @model.respond_to?(:good_attribute) # to force method generation
    expect(@model.methods.include?('good_attribute') || @model.methods.include?(:good_attribute)).to be true
  end

  it "does define good_attribute=()" do
    @model.respond_to?(:good_attribute=) # to force method generation
    expect(@model.methods.include?('good_attribute=') || @model.methods.include?(:good_attribute=)).to be true
  end

  it "does define id()" do
    @model.respond_to?(:id) # to force method generation
    expect(@model.methods.include?('id') || @model.methods.include?(:id)).to be true
  end

  it "can create instance in database with special attribute name" do
    m = MyModel.create!(:class => 'Foo')
    m = MyModel.find(m.id)
    expect(m[:class]).to eq('Foo')
  end

  it "can create instance in database with attribute 'changed'" do
    m = MyModel.create!(:class => 'Foo', :changed => 'true change')
    m = MyModel.find(m.id)
    expect(m[:changed]).to eq('true change')
  end

  it "can create instance in database with attribute 'errors'" do
    m = MyModel.create!(:class => 'Foo', :errors => 'my errors')
    m = MyModel.find(m.id)
    expect(m[:errors]).to eq('my errors')
  end

  it "can create instance in database with attribute 'comment-frequency'" do
    m = MyModel.create!(:class => 'Foo', :"comment-frequency" => 'often')
    m = MyModel.find(m.id)
    expect(m[:"comment-frequency"]).to eq('often')
  end

  it "can create instance in database with attribute 'association'" do
    m = MyModel.new(:class => 'Foo')
    m[:association] = 'worker'
    m.save!
    m = MyModel.find(m.id)
    expect(m[:association]).to eq('worker')
  end

  it "has class attribute" do
    expect(MyModel.new().has_attribute?('class')).to be true
  end

  it "can call class= without error" do
    m = MyModel.new()
    m.class = 'Foo'
    expect(m[:class]).to eq('Foo')
  end

  it "can use finders with attribute" do
    m = MyModel.where(:class => 'Foo').to_a
    expect(m).to be_empty
  end

  it "validates presence of bad attribute name" do
    expect(@model).to_not be_valid
    expect(Array(@model.errors[:class]).include?("can't be blank")).to be true

    m = MyModel.new(:class => 'Foo')
    expect(m).to be_valid
  end

  it "changed lists attributes with unsaved changes" do
    m = MyModel.new(:class => 'Foo')
    expect(m.changed.size).to eq(1)
  end

  it "changed? returns true if any attribute has unsaved changes" do
    m = MyModel.new(:class => 'Foo')
    expect(m).to be_changed
  end

  it "validates presence of non-attribute" do
    m = MyUser.new()
    expect(m).to_not be_valid
    m = MyUser.new({:password => 'foobar'})
    expect(m).to be_valid
  end

  describe "dirty" do
    it "new record - no changes" do
      # NOTE: in 4.1 this returns false. In 4.2, nil.
      expect(@model.class_changed?).to be_falsey
      expect(@model.class_change).to be_nil
    end

    it "changed record - has changes" do
      @model[:class] = 'arrr'
      expect(@model.class_changed?).to be true
      expect(@model.class_was).to be_nil
      expect(@model.class_change).to eq([nil, 'arrr'])
    end

    it "saved record - no changes" do
      @model[:class] = 'arrr'
      @model.save!
      expect(@model.class_changed?).to be false
      expect(@model.class_change).to be_nil
    end
  end

end

