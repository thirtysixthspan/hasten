module Hasten

  class Dump

    attr_accessor :command

    def initialize(io_in, io_out)
      @io_in = io_in
      @io_out = io_out
    end

    def execute
      while self.command = parse_command
        dump_command
      end
      dump_indexes
    end

    private

      attr_reader :io_in, :io_out

      def tables
        @tables ||= []
      end

      def views
        @views ||= []
      end

      def parse_command
        return unless line = io_in.gets

        self.command = Command.new
        self.command << line
        return command if command.complete?

        while line = io_in.gets
          self.command << line
          break if command.complete?
        end

        command
      end

      def dump_command
        send("dump_#{command.type.to_s.downcase}")
      end

      def dump_table
        tables << table = Table.new
        table << command
        io_out.puts table.without_indexes
      end

      def dump_view
        views << view = View.new
        view << command
        io_out.puts view
      end

      def dump_insert
        io_out.puts command
      end

      def dump_other
        io_out.puts command
      end

      def dump_indexes
        tables_not_overwritten_by_views.each do |table|
          io_out.puts table.index_statements
        end
      end

      def tables_not_overwritten_by_views
        tables.reject { |table| views.map(&:name).include?(table.name) }
      end

  end

end