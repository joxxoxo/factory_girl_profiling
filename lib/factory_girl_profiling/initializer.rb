module FactoryGirlProfiling
  class Initializer
    def self.initialize_rspec
      RSpec.configure do |config|
        if ENV['PROFILE_FACTORY_GIRL']
          config.before(:suite) do
            ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
              FactoryGirlProfiling::Profiler.add(name, start, finish, id, payload)
            end
          end

          config.after(:suite) do
            FactoryGirlProfiling::Profiler.print_results
            FactoryGirlProfiling::Profiler.reset
          end
        end
      end
    end
  end
end
