module Antidote
  class TypeError < StandardError
    def initialize(types)
      @actual_type, @expected_type, @variable_name, @method_name = types
    end

    def message
      "Variable `#{@variable_name}` in method `#{@method_name}` expected a " \
      "#{@expected_type}, but received a #{@actual_type}"
    end
  end

  module ClassMethods
    @@type_constraints = Hash.new { |h, k| h[k] = [] }

    def annotate(method_name, type_constraints)
      type_constraints.each do |variable, type|
        add_type_constraint_for(method_name, {variable => type})
      end
      define_type_constrained_method(method_name) {}
      # type_check(method_name)
    end

    def add_type_constraint_for(method, type_contract)
      @@type_constraints[method] << type_contract
    end

    def type_check(method_name)
      trace_point = TracePoint.new(:return) do |t|
        # event type specification is optional
        puts "returning #{t.return_value} from #{t.defined_class}.#{t.method_id}"
      end
      # set_trace_func proc { |event, file, line, id, binding, classname|
      #   binding.eval("local_variables").each do |var|
      #     puts var
      #   end

      #   puts "ID: #{id}\tClassname: #{classname} called" if event == 'call' &&
      #     classname != Antidote::ClassMethods
      # }
    end

    def define_type_constrained_method(method_name, *args)
      if method_name.start_with?("self")
        # http://apidock.com/ruby/UnboundMethod
        # http://ruby-doc.org/core-2.1.4/UnboundMethod.html
        # http://ruby-doc.org/core-2.1.4/Method.html
        # http://apidock.com/ruby/Module/instance_method
        m = self.method(method_name.split(".").last)
        define_singleton_method(method_name.split(".").last) do |*args|
          args.each_with_index do |argument_value, index|
            actual_type   = argument_value.class
            expected_type = @@type_constraints[method_name][index].values.first
            variable_name = @@type_constraints[method_name][index].keys.first

            unless actual_type == expected_type
              raise Antidote::TypeError,
                [actual_type, expected_type, variable_name, method_name]
            end
          end
          m.bind(self).(*args, &block)
        end
      else
        m = instance_method(method_name)
        define_method(method_name) do |*args, &block|
          args.each_with_index do |argument_value, index|
            yield
            actual_type   = argument_value.class
            expected_type = @@type_constraints[method_name][index].values.first
            variable_name = @@type_constraints[method_name][index].keys.first

            unless actual_type == expected_type
              raise Antidote::TypeError,
                [actual_type, expected_type, variable_name, method_name]
            end
          end
          m.bind(self).(*args, &block)
        end
      end
    end
  end

  class << self
    def included(klass)
      klass.extend(ClassMethods)
    end
  end
end
