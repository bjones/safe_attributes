require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# create the table for the test in the database
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'my_models'")
ActiveRecord::Base.connection.create_table(:my_models) do |t|
    t.string :class
    t.string :bad_attribute
    t.string :good_attribute
end

class MyModel < ActiveRecord::Base
    include SafeAttributes
    bad_attribute_names :bad_attribute, :bad_attribute=
end

describe MyModel do

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
        @model.respond_to?('class=') # to force method generation
        @model.methods.include?('class=').should be_true
    end

    it "does not define bad_attribute()" do
        @model.respond_to?('bad_attribute') # to force method generation
        @model.methods.include?('bad_attribute').should be_false
    end

    it "does not define bad_attribute=()" do
        @model.respond_to?('bad_attribute=') # to force method generation
        @model.methods.include?('bad_attribute=').should be_false
    end

    it "does define good_attribute()" do
        @model.respond_to?('good_attribute') # to force method generation
        @model.methods.include?('good_attribute').should be_true
    end

    it "does define good_attribute=()" do
        @model.respond_to?('good_attribute=') # to force method generation
        @model.methods.include?('good_attribute=').should be_true
    end

    it "does define id()" do
        @model.respond_to?('id') # to force method generation
        @model.methods.include?('id').should be_true
    end
    
    it "can create instance in database with special attribute name" do
        m = MyModel.create(:class => 'Foo')
        m = MyModel.find(m.id)
        m[:class].should == 'Foo'
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
end

