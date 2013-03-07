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
    ActiveRecord::Base.connection.increment_open_transactions
    ActiveRecord::Base.connection.begin_db_transaction
    @model = MyModel.new
  end

  after(:each) do
    ActiveRecord::Base.connection.rollback_db_transaction
    ActiveRecord::Base.connection.decrement_open_transactions
  end

  it "inspecting class returns expected attribute names" do
    MyModel.inspect.should match 'class: string'
  end

  it "inspecting instance returns expected attribute names" do
    @model.inspect.should match 'class: nil'
  end

  it "does not redefine class()" do
    @model.class.name.should == 'MyModel'
  end

  it "defines class=()" do
    @model.respond_to?(:class=) # to force method generation
    (@model.methods.include?('class=') || @model.methods.include?(:class=)).should be_true
  end

  it "does not define bad_attribute()" do
    @model.respond_to?(:bad_attribute) # to force method generation
    (@model.methods.include?('bad_attribute') || @model.methods.include?(:bad_attribute)).should be_false
  end

  it "does not define bad_attribute=()" do
    @model.respond_to?(:bad_attribute=) # to force method generation
    (@model.methods.include?('bad_attribute=') || @model.methods.include?(:bad_attribute=)).should be_false
  end

  it "does define good_attribute()" do
    @model.respond_to?(:good_attribute) # to force method generation
    (@model.methods.include?('good_attribute') || @model.methods.include?(:good_attribute)).should be_true
  end

  it "does define good_attribute=()" do
    @model.respond_to?(:good_attribute=) # to force method generation
    (@model.methods.include?('good_attribute=') || @model.methods.include?(:good_attribute=)).should be_true
  end

  it "does define id()" do
    @model.respond_to?(:id) # to force method generation
    (@model.methods.include?('id') || @model.methods.include?(:id)).should be_true
  end

  it "can create instance in database with special attribute name" do
    m = MyModel.create!(:class => 'Foo')
    m = MyModel.find(m.id)
    m[:class].should == 'Foo'
  end

  it "can create instance in database with attribute 'changed'" do
    m = MyModel.create!(:class => 'Foo', :changed => 'true change')
    m = MyModel.find(m.id)
    m[:changed].should == 'true change'
  end

  it "can create instance in database with attribute 'errors'" do
    m = MyModel.create!(:class => 'Foo', :errors => 'my errors')
    m = MyModel.find(m.id)
    m[:errors].should == 'my errors'
  end

  it "can create instance in database with attribute 'comment-frequency'" do
    m = MyModel.create!(:class => 'Foo', :"comment-frequency" => 'often')
    m = MyModel.find(m.id)
    m[:"comment-frequency"].should == 'often'
  end

  it "can create instance in database with attribute 'association'" do
    m = MyModel.new(:class => 'Foo')
    m[:association] = 'worker'
    m.save!
    m = MyModel.find(m.id)
    m[:association].should == 'worker'
  end

  it "has class attribute" do
    MyModel.new().has_attribute?('class').should be_true
  end

  it "can call class= without error" do
    m = MyModel.new()
    m.class = 'Foo'
    m[:class].should == 'Foo'
  end

  it "can use finders with attribute" do
    m = MyModel.find_all_by_class('Foo')
    m.size.should == 0
  end

  it "validates presence of bad attribute name" do
    @model.valid?.should be_false
    Array(@model.errors[:class]).include?("can't be blank").should be_true

    m = MyModel.new(:class => 'Foo')
    m.valid?.should be_true
  end

  it "changed lists attributes with unsaved changes" do
    m = MyModel.new(:class => 'Foo')
    m.changed.size == 1
  end

  it "changed? returns true if any attribute has unsaved changes" do
    m = MyModel.new(:class => 'Foo')
    m.changed?.should be_true
  end

  it "validates presence of non-attribute" do
    m = MyUser.new()
    m.valid?.should be_false
    m = MyUser.new({:password => 'foobar'})
    m.valid?.should be_true
  end

  describe "dirty" do
    it "new record - no changes" do
      @model.class_changed?.should be_false
      @model.class_change.should be_nil
    end

    it "changed record - has changes" do
      @model[:class] = 'arrr'
      @model.class_changed?.should be_true
      @model.class_was.should be_nil
      @model.class_change.should == [nil, 'arrr']
    end

    it "saved record - no changes" do
      @model[:class] = 'arrr'
      @model.save!
      @model.class_changed?.should be_false
      @model.class_change.should be_nil
    end
  end

end

