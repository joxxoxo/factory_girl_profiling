require "spec_helper"

describe 'Integration: Profiler' do
  it "works" do
    profiler = FactoryGirlProfiling::Profiler.instance
    profiler.add_timing('some factory', 'some strategy', 123)
    profiler.add_counting('some factory', 'some strategy')
    profiler.print_results
  end
end
