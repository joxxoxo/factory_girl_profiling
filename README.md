# FactoryGirlProfiling

Prints number of times when factory was build or create and time (avg, min, max) that it took after test suite

## Installation

Add this line to your application's Gemfile:

    gem 'factory_girl_profiling'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install factory_girl_profiling

## Usage

Add env var when running test to collect and
print statistic after test suite

    PROFILE_FACTORY_GIRL=1 


What's happennig is:
  
  
    RSpec.configure do |config|
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

For more info about FactoryGirl read 
[FactoryGirl Wiki](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
