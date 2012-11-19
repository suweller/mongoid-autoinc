require "spec_helper"

describe "Mongoid::Autoinc::Incrementor" do

  let(:incrementor) { Mongoid::Autoinc::Incrementor.new('User', :number, '123') }

  describe "model name" do

    subject { incrementor.model_name }

    it { should == 'User' }

  end

  describe "field name" do

    subject { incrementor.field_name }

    it { should == 'number' }

  end

  describe "scope key" do

    subject { incrementor.scope_key }

    it { should == '123' }

  end

  describe "#key" do

    subject { incrementor.key }

    it { should == 'user_number_123' }

    context "without scope" do

      subject { Mongoid::Autoinc::Incrementor.new('User', :number).key }

      it { should == 'user_number'}

    end

    context "for a subclass" do

      let(:incrementor) do

        Mongoid::Autoinc::Incrementor.new('SpecialUser', :number, '123')

      end

      it { should == 'special_user_number_123' }

    end

  end

  describe "#ensuring_document" do

    context "new document" do

      let(:collection) { stub }

      before do
        collection.stub!(:find_one).and_return(false)
        incrementor.stub(:collection => collection)
      end

      it "should call insert method" do
        collection.should_receive(:insert).with(
          '_id' => 'user_number_123', 'c' => 0
        )
        incrementor.ensuring_document { }
      end

    end

    context "existing document" do

      before { incrementor.collection.stub!(:find_one).and_return(true) }

      it "should call insert method" do
        incrementor.collection.should_not_receive(:insert)
        incrementor.ensuring_document { }
      end

    end

  end

  describe "#inc" do

    subject { incrementor.inc }

    it "should call ensure_document" do
      incrementor.should_receive(:ensuring_document)
      subject
    end

    describe "generating incrementing numbers" do

      before { User.delete_all }

      it "should increment the number for each document" do
        (1..10).each do |incrementing_number|
          User.create!(:name => 'Bob Kelso').number.should == incrementing_number
        end
      end

    end

  end

end
