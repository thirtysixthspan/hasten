module Hasten

  class View < Command

    def self.match?(sql)
      sql.match(/^(CREATE|REPLACE).*?VIEW\s+(.*?)\s+AS/i) ||
      sql.match(/^VIEW\s+(.*?)\s+AS/i)
    end

    def name
      sql.match(/VIEW\s+`*(.*?)`.*?AS/i)[1]
    end

  end

end