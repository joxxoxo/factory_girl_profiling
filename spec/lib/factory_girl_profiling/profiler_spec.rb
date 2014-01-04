require "spec_helper"

describe FactoryGirlProfiling::Profiler do
  subject { FactoryGirlProfiling::Profiler.instance }
  let(:output) { StringIO.new }
  before do
    subject.reset
    subject.output_buffer = output
  end
  context 'timing' do
    it "saves and prints given data" do
      subject.add_timing('some name', 'some strategy', 42)
      subject.print_timing_results
      expect(output.string).to include('some name')
      expect(output.string).to include('some strategy')
      expect(output.string).to include('42')
    end
  end

  context 'counting' do
    it "saves and prints given data" do
      subject.add_counting('some name', 'some strategy')
      subject.add_counting('some name', 'some strategy')
      subject.print_counting_results
      expect(output.string).to include('some name')
      expect(output.string).to include('some strategy')
      expect(output.string).to include('2')
    end
  end

  context '#reset' do
    it "resets saved data" do
      subject.print_results
      blank_result = output.string
      output.reopen
      subject.add_counting('some name', 'some strategy')
      subject.add_timing('some name', 'some strategy', 42)
      subject.reset
      subject.print_results
      expect(output.string).to eq(blank_result)
    end
  end

end
