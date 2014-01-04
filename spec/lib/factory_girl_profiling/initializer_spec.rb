require "spec_helper"

describe FactoryGirlProfiling::Initializer do
  context '.initialize_rspec' do
    it "calls RSpec.configure" do
      FactoryGirlProfiling::Initializer::RSpec = rspec_double = double('rspec')
      rspec_double.should_receive(:configure)
      FactoryGirlProfiling::Initializer.initialize_rspec
    end
  end
end
