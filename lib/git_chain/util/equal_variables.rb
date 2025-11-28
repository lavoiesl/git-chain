# frozen_string_literal: true

module GitChain
  module Util
    module EqualVariables
      alias eql? ==

      def ==(other)
        other.class == self.class && other.state == state
      end

      def hash
        state.hash
      end

      protected

      def state
        instance_variables.to_h { |v| [v, instance_variable_get(v)] }
      end
    end
  end
end
