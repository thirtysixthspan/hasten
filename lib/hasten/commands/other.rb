module Hasten

  class Other < Command

    def self.match?(sql)
      sql.match(/.*/i)
    end

  end

end