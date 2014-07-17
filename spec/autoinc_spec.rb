require 'spec_helper'

describe 'Mongoid::Autoinc' do
  after { User.delete_all }

  context 'class methods' do
    subject { User }

    it { should respond_to(:increments) }
    it { should respond_to(:incrementing_fields) }

    describe '.incrementing_fields' do
      context 'for User' do
        subject { User.incrementing_fields }
        it { should match_array(number: {auto: true}) }
      end

      context 'for SpecialUser' do
        subject { SpecialUser.incrementing_fields }
        it { should match_array(number: {auto: true}) }
      end

      context 'for PatientFile' do
        subject { PatientFile.incrementing_fields }
        it { should match_array(file_number: {scope: :name, auto: true}) }
      end

      context 'for Operation' do
        let(:scope) { subject[:op_number][:scope] }
        subject { Operation.incrementing_fields }
        it { should match_array(op_number: {scope: scope, auto: true}) }
        it { expect(scope).to be_a Proc }
      end

      context 'for Vehicle' do
        subject { Vehicle.incrementing_fields }
        it { should match_array(vin: {seed: 1000, auto: true}) }
      end

      context 'for Ticket' do
        subject { Ticket.incrementing_fields }
        it { should match_array(number: {step: 2, auto: true}) }
      end

      context 'for LotteryTicket' do
        let(:step) { subject[:number][:step] }
        subject { LotteryTicket.incrementing_fields }
        it { should match_array(number: {step: step, auto: true}) }
        it { expect(step).to be_a Proc }
      end
    end

    describe '.increments' do
      before { allow(SpecialUser).to receive(:attr_protected) }
      specify { expect(SpecialUser).to receive(:attr_protected).with(:foo) }
      after { SpecialUser.increments(:foo) }
    end
  end

  context 'instance methods' do
    let(:incrementor) { Object.new }
    before { allow(incrementor).to receive(:inc).and_return(1) }

    context 'without scope' do
      let(:user) { User.new(name: 'Dr. Cox') }
      subject { User.new }

      it { should respond_to(:update_auto_increments) }

      it 'calls the autoincrementor' do
        expect(Mongoid::Autoinc::Incrementor).to receive(:new)
          .with('User', :number, auto: true)
          .and_return(incrementor)
        user.save!
      end

      describe 'writing the attribute' do
        before do
          allow(Mongoid::Autoinc::Incrementor).to receive(:new)
            .and_return(incrementor)
        end

        it 'writes the returned incrementor attribute' do
          expect { user.save! }.to change(user, :number).from(nil).to(1)
        end
      end

      describe '#assign!' do
        it 'raises AutoIncrementsError' do
          expect { subject.assign!(:number) }
            .to raise_error(Mongoid::Autoinc::AutoIncrementsError)
        end
      end
    end

    context 'with scope as symbol' do
      let(:patient_file) { PatientFile.new(name: 'Dr. Cox') }

      it 'should call the autoincrementor' do
        expect(Mongoid::Autoinc::Incrementor).to receive(:new)
          .with('PatientFile', :file_number, scope: 'Dr. Cox', auto: true)
          .and_return(incrementor)
        patient_file.save!
      end
    end

    context 'with scope as proc' do
      let(:user) { User.new(name: 'Dr. Cox') }
      let(:operation) { Operation.new(name: 'Heart Transplant', user: user) }

      it 'calls the autoincrementor' do
        expect(Mongoid::Autoinc::Incrementor).to receive(:new)
          .with('Operation', :op_number, scope: 'Dr. Cox', auto: true)
          .and_return(incrementor)
        operation.save!
      end
    end

    context 'without auto' do
      subject { Intern.new }

      it 'should not call the autoincrementor' do
        expect(Mongoid::Autoinc::Incrementor).to_not receive(:new)
        subject.save!
      end

      describe '#assign!' do
        it 'calls the autoincrementor' do
          expect(Mongoid::Autoinc::Incrementor).to receive(:new)
            .with('Intern', :number, auto: false)
            .and_return(incrementor)
          subject.assign!(:number)
        end

        it 'raises when called more than once per document' do
          subject.assign!(:number)
          expect { subject.assign!(:number) }
            .to raise_error(Mongoid::Autoinc::AlreadyAssignedError)
        end
      end

      context 'class with overwritten model name' do
        subject { Intern.new }
        before do
          allow(Intern).to receive(:model_name)
            .and_return('PairOfScrubs')
        end

        it 'calls the autoincrementor' do
          expect(Mongoid::Autoinc::Incrementor).to receive(:new)
            .with('PairOfScrubs', :number, auto: false)
            .and_return(incrementor)
          subject.assign!(:number)
        end
      end
    end

    context 'with seed' do
      let(:vehicle) { Vehicle.new(model: 'Coupe') }
      it 'calls the autoincrementor with the seed value' do
        expect(Mongoid::Autoinc::Incrementor).to receive(:new)
          .with('Vehicle', :vin, seed: 1000, auto: true)
          .and_return(incrementor)
        vehicle.save!
      end
    end

    context 'with Integer step' do
      let(:ticket) { Ticket.new }
      it 'calls the autoincrementor with the options hash' do
        expect(Mongoid::Autoinc::Incrementor).to receive(:new)
          .with('Ticket', :number, step: 2, auto: true)
          .and_return(incrementor)
        ticket.save!
      end
    end

    context 'with Proc step' do
      let(:lottery_ticket) { LotteryTicket.new(start: 10) }
      it 'calls the autoincrementor with the options hash' do
        expect(Mongoid::Autoinc::Incrementor).to receive(:new)
          .with('LotteryTicket', :number, step: 11, auto: true)
          .and_return(incrementor)
        lottery_ticket.save!
      end
    end

    context 'with model_name' do
      let(:stethoscope) { Stethoscope.new }
      it 'calls the autoincrementor with the options hash' do
        expect(Mongoid::Autoinc::Incrementor).to receive(:new)
          .with('stetho', :number, auto: true)
          .and_return(incrementor)
        stethoscope.save!
      end
    end
  end
end
