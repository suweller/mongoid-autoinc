require "spec_helper"


describe "Mongoid::Autoinc" do

  after do
    User.delete_all
  end

  context "class methods" do

    subject { User }

    it { should respond_to(:auto_increment) }

    it { should respond_to :autoincrementing_fields }

    describe "autoincrementing_fields" do

      subject { User.autoincrementing_fields }

      it { should == {:number => {}} }

      context "for PatientFile" do

        subject { PatientFile.autoincrementing_fields }

        it { should == {:file_number => {:scope => :name}} }

      end

    end

  end

  context "instance methods" do

    let(:incrementor) { Object.new }

    before { incrementor.stub!(:inc).and_return(1) }

    context "without scope" do

      subject { User.new }

      it { should respond_to(:update_auto_increments) }

      describe "before create" do

        let(:user) { User.new(:name => 'Dr. Cox') }

        it "should call the autoincrementor" do
          Mongoid::Autoinc::Incrementor.should_receive(:new).
            with('User', :number, nil).
            and_return(incrementor)

          user.save!
        end

        describe "writing the attribute" do

          before { Mongoid::Autoinc::Incrementor.stub!(:new).and_return(incrementor) }

          it "should write the returned incrementor attribute" do
            expect{
              user.save!
            }.to change(user, :number).from(nil).to(1)
          end

        end

      end

    end

    context "with scope" do

      subject { PatientFile.new }

      describe "before create" do

        let(:patient_file) { PatientFile.new(:name => 'Dr. Cox') }

        it "should call the autoincrementor" do
          Mongoid::Autoinc::Incrementor.should_receive(:new).
            with('PatientFile', :file_number, 'Dr. Cox').
            and_return(incrementor)

          patient_file.save!
        end

      end

    end

  end

end
