require "thor/rails/version"

# thor extension to load rails environment before running tasks
# Thor commands must include the module which will start the rails
# environment for *all* defined commands
class Thor
  module Rails
    def self.included(base)
      base.singleton_class.send(:alias_method, :start_original, :start)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def start(*args)
        define_environment(args)
        load_environment
        start_original(*args)
      end

      private

      def load_environment
        require File.expand_path('config/environment.rb')
      end

      def define_environment(args)
        index = args.first.index { |option| option == '-e' }
        ENV['RAILS_ENV'] ||= index ? args.first[index+1] : 'development'
      end
    end
  end
end
