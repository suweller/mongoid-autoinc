require "spec_helper"

describe "Mongoid::Autoinc::Incrementor" do

  let(:incrementor) { Mongoid::Autoinc::Incrementor.new('User', :number, '123', 100) }

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

  describe "seed" do

    subject { incrementor.seed }

    it { should == 100 }

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

  describe "#inc" do

    subject { incrementor.inc }

    describe "generating incrementing numbers" do

      before { User.delete_all }

      it "should increment the number for each document" do
        (1..10).each do |incrementing_number|
          User.create!(:name => 'Bob Kelso').number.should == incrementing_number
        end
      end

    end

    context "with a seed value" do

      before { Vehicle.delete_all }

      it "should start the incrementor at the seed value" do
        (1..10).each do |i|
          Vehicle.create(model: "Coupe").vin.should == 1000 + i
        end
      end

    end

  end

end
