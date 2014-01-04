module FactoryGirlProfiling
  class Profiler
    private :initialize
    def self.instance
      @instance ||= new
    end

    class << self
      [:add, :reset, :print_results].each do |method|
        define_method method do |*args|
          instance.send(method, *args)
        end
      end
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
      #output_string "Slow factory: #{name} using strategy #{strategy}"
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
      output_string 'FactoryGirl counting:'
      sort_data_hash(@factory_girl_results).each do |factory, values|
        counts_for_strategies = values.inject([]){|s, (strategy, count)| s << "#{strategy} = #{count}"}
        output_string "#{"#{factory}:".ljust(30)} #{"%15s \t" * counts_for_strategies.size}" % counts_for_strategies
      end
      output_string "\n"
    end

    def print_timing_results
      output_string 'FactoryGirl timing:'
      sort_value_proc = ->(val) { val.values.map{|e| e.reduce(0, &:+)}.reduce(0, &:+) / val.values.map(&:size).reduce(0, &:+) }
      sort_data_hash(@factory_girl_timing_results, sort_value_proc).each do |factory, data|
        output_string factory
        data.each do |strategy, times|
          output_string "#{"#{strategy}:".ljust(10)} avg=#{(times.reduce(0, &:+) / times.size).round(2)} \t(min=#{times.min.round(2)},\tmax=#{times.max.round(2)})"
        end
        output_string ""
      end
      output_string "\n"
    end

    def sort_data_hash(hash, sort_value_proc = nil)
      sort_value_proc ||= Proc.new {|val| val.values.reduce(0, &:+) }
      hash.to_a.sort {|(_, v1), (_, v2)| sort_value_proc.call(v2) <=> sort_value_proc.call(v1)}
    end

    def output_string(str)
      output_buffer.puts str
    end

    attr_writer :output_buffer
    def output_buffer
      @output_buffer ||= $stdout
    end
  end
end
