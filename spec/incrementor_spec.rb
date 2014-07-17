require 'spec_helper'

describe 'Mongoid::Autoinc::Incrementor' do
  let(:klass) { Mongoid::Autoinc::Incrementor }
  let(:options) { {scope: '123', seed: 100, step: 2} }
  let(:incrementor) { klass.new('User', :number, options) }

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
      subject { klass.new('User', :number).key }
      it { should eq('user_number')}
    end

    context 'for a subclass' do
      let(:incrementor) { klass.new('SpecialUser', :number, options) }
      it { should eq('special_user_number_123') }
    end
  end

  describe '#inc' do
    subject { incrementor.inc }

    describe 'generating incrementing numbers' do
      before { User.delete_all }
      it 'increments the number for each document' do
        (1..10).each do |i|
          expect(User.create!(name: 'Bob Kelso').number).to eq(i)
        end
      end
    end

    context 'with a seed value' do
      before { Vehicle.delete_all }
      it 'starts the incrementor at the seed value' do
        (1..10).each do |i|
          expect(Vehicle.create(model: 'Coupe').vin).to eq(1000 + i)
        end
      end
    end

    context 'with a step Integer value' do
      before { Ticket.delete_all }
      it 'increments according to the step value' do
        (1..10).each do |i|
          expect(Ticket.create.number).to eq(2 * i)
        end
      end
    end

    context 'with a step Proc value' do
      before { LotteryTicket.delete_all }
      it 'increments according to the step value' do
        expect(LotteryTicket.create(start: 10).number).to eq(11)
        expect(LotteryTicket.create(start: 30).number).to eq(42)
        expect(LotteryTicket.create.number).to eq(43)
      end
    end
  end
end
