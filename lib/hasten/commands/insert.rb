module Hasten

  class Insert < Command

    def self.match?(sql)
      sql.match(/^INSERT/)
    end

  end

end