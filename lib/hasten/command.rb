module Hasten

  class Command < Array

    def complete?
      last.match(/;$/) ||
      last.match(/^--/) ||
      last.match(/^\s*$/)
    end

    def <<(items)
      if items.respond_to? :each
        items.each { |item| self.push item }
      else
        self.push items
      end
    end

    def type
      COMMAND_CLASSES
        .detect { |klass| klass.match?(sql) }
        .to_s
        .gsub(/^.*::/,'')
    end

    def sql
      conditional ? extract : strip
    end

    private

      def squish
        self.map(&:chomp).join(' ')
      end

      def strip
        squish.gsub(/^\s+/,'').gsub(/;\s+$/,'')
      end

      def conditional
        squish.match(/^\s*\/\*\![0-9]{5}\s+(.*?)\s*\*\//)
      end

      def extract
        conditional[1]
      end

  end

end