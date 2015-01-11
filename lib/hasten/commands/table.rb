module Hasten

  class Table < Command

    def self.match?(sql)
      sql.match(/^CREATE\s+(TEMPORARY\s+)*TABLE/i)
    end

    def name
      sql[/(?<=`).*?(?=`)/]
    end

    def without_indexes
      revised = reject &index_line
      revised[-2].gsub!(/,$/,'')
      revised
    end

    def indexes
      self
        .select(&index_line)
        .map{ |line| line.gsub(/^\s+/,'') }
        .map{ |line| line.gsub(/,\s*$/,'') }
        .map{ |line| line.chomp }
    end

    def index_statements
      indexes
        .map { |definition| "ALTER TABLE `#{name}` ADD #{definition};" }
    end

    private

      def index_line
        ->(line){
          line.match(/^\s*(KEY|INDEX)/i) ||
          line.match(/^\s*(FULLTEXT|SPATIAL)\s+(KEY|INDEX)/i) ||
          line.match(/^\s*(UNIQUE|FOREIGN)\s+(KEY|INDEX)/i) ||
          line.match(/^\s*CONSTRAINT.*?(UNIQUE|FOREIGN)\s+(KEY|INDEX)/i)
        }
      end

  end

end
