require 'spec_helper'

describe 'Mongoid::Autoinc::Incrementor' do
  let(:options) { {scope: '123', seed: 100, step: 2} }
  let(:incrementor) { Mongoid::Autoinc::Incrementor.new('User', :number, options) }

  describe 'model name' do
    subject { incrementor.model_name }
    it { should eq('User') }
  end

  describe 'field name' do
    subject { incrementor.field_name }
    it { should eq('number') }
  end

  describe 'scope key' do
    subject { incrementor.scope_key }
    it { should eq('123') }
  end

  describe 'seed' do
    subject { incrementor.seed }
    it { should eq(100) }
  end

  describe 'step' do
    subject { incrementor.step }
    it { should eq(2) }
  end

  describe '#key' do
    subject { incrementor.key }

    it { should eq('user_number_123') }

    context 'without scope' do
      subject { Mongoid::Autoinc::Incrementor.new('User', :number).key }
      it { should eq('user_number')}
    end

    context 'for a subclass' do
      let(:incrementor) do
        Mongoid::Autoinc::Incrementor.new('SpecialUser', :number, options)
      end

      it { should eq('special_user_number_123') }
    end
  end

  describe '#inc' do
    subject { incrementor.inc }

    describe 'generating incrementing numbers' do
      before { User.delete_all }

      it 'increments the number for each document' do
        (1..10).each do |incrementing_number|
          User.create!(name: 'Bob Kelso').number.should eq(incrementing_number)
        end
      end
    end

    context 'with a seed value' do
      before { Vehicle.delete_all }

      it 'starts the incrementor at the seed value' do
        (1..10).each do |i|
          Vehicle.create(model: 'Coupe').vin.should eq(1000 + i)
        end
      end
    end

    context 'with a step Integer value' do
      before { Ticket.delete_all }

      it 'increments according to the step value' do
        (1..10).each do |i|
          Ticket.create.number.should eq(2 * i)
        end
      end
    end

    context 'with a step Proc value' do
      before { LotteryTicket.delete_all }

      it 'increments according to the step value' do
        LotteryTicket.create(start: 10).number.should eq(11)
        LotteryTicket.create(start: 30).number.should eq(42)
        LotteryTicket.create.number.should eq(43)
      end
    end
  end
end
