require "spec_helper"

describe "Mongoid::Autoinc::Incrementor" do

  let(:incrementor) { Mongoid::Autoinc::Incrementor.new('User', :number) }

  describe "model name" do

    subject { incrementor.model_name }

    it { should == 'User' }

  end

  describe "field name" do

    subject { incrementor.field_name }

    it { should == 'number' }

  end

  describe "#key" do

    subject { incrementor.key }

    it { should == 'user_number' }

  end

  describe "#ensuring_document" do

    context "new document" do
      before { incrementor.collection.stub!(:find_one).and_return(false) }

      it "should call insert method" do
        incrementor.collection.should_receive(:insert).with(
          '_id' => 'user_number', 'c' => 0
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
