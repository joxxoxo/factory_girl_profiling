require "factory_girl_profiling/version"

module FactoryGirlProfiling
  class Profiler
    include Singleton
    class << self
      delegate :add, :reset, :print_results, to: :instance
    end

    def initialize
      reset
    end

    def reset
      @factory_girl_results = {}
      @factory_girl_timing_results = {}
    end

    def add(name, start, finish, id, payload)
      add_counting(payload[:name], payload[:strategy])
      add_timing(payload[:name], payload[:strategy], finish - start)
    end

    def add_timing(name, strategy, timing)
      @factory_girl_timing_results[name] ||= {}
      @factory_girl_timing_results[name][strategy] ||= []
      @factory_girl_timing_results[name][strategy] << timing


      #if timing >= 0.5
      #puts "Slow factory: #{name} using strategy #{strategy}"
      #end
    end

    def add_counting(name, strategy)
      @factory_girl_results[name] ||= {}
      @factory_girl_results[name][strategy] ||= 0
      @factory_girl_results[name][strategy] += 1
    end

    def print_results
      print_counting_results
      print_timing_results
    end

    def print_counting_results
      puts 'FactoryGirl counting:'
      sort_data_hash(@factory_girl_results).each do |factory, values|
        counts_for_strategies = values.inject([]){|s, (strategy, count)| s << "#{strategy} = #{count}"}
        puts "#{"#{factory}:".ljust(30)} #{"%15s \t" * counts_for_strategies.size}" % counts_for_strategies
      end
      puts "\n"
    end

    def print_timing_results
      puts 'FactoryGirl timing:'
      sort_value_proc = ->(val) { val.values.map(&:sum).sum / val.values.map(&:size).sum }
      sort_data_hash(@factory_girl_timing_results, sort_value_proc).each do |factory, data|
        puts factory
        data.each do |strategy, times|
          puts "#{"#{strategy}:".ljust(10)} avg=#{(times.sum / times.size).round(2)} \t(min=#{times.min.round(2)},\tmax=#{times.max.round(2)})"
        end
        puts ""
      end
      puts "\n"
    end

    def sort_data_hash(hash, sort_value_proc = nil)
      sort_value_proc ||= Proc.new {|val| val.values.sum }
      hash.to_a.sort {|(_, v1), (_, v2)| sort_value_proc.call(v2) <=> sort_value_proc.call(v1)}
    end
  end
end

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
