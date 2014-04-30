class Pry
  class Command::WatchExpression
    class Expression
      attr_reader :target, :source, :value, :previous_value, :_pry_

      def initialize(_pry_, target, source)
        @_pry_ = _pry_
        @target = target
        @source = Code.new(source).strip
      end

      def eval!
        @previous_value = @value
        @value = Pry::ColorPrinter.pp(_pry_, target_eval(target, source), "")
      end

      def to_s
        "#{Code.new(source).highlighted(_pry_.config.color).strip} => #{value}"
      end

      # Has the value of the expression changed?
      #
      # We use the pretty-printed string represenation to detect differences
      # as this avoids problems with dup (causes too many differences) and == (causes too few)
      def changed?
        (value != previous_value)
      end

      private

      def target_eval(target, source)
        target.eval(source)
      rescue => e
        e
      end
    end
  end
end
