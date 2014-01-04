require "factory_girl_profiling/version"
require 'factory_girl_profiling/profiler'
require 'factory_girl_profiling/initializer'

module FactoryGirlProfiling
end

FactoryGirlProfiling::Initializer.initialize_rspec
