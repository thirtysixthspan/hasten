require './spec/spec_helper'

describe Hasten::Table do

  it "identifies delimited table names" do
    subject << <<-EOC
      CREATE TABLE `test` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `q1` int(11) DEFAULT NULL,
        `q2` int(11) DEFAULT NULL,
        PRIMARY KEY (`id`),
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
    EOC
    expect(subject.name).to eq('test')
  end

  it "identifies indexes" do
    subject << [
      "CREATE TABLE `test` (",
      "  `id` int(11) NOT NULL AUTO_INCREMENT,",
      "  `q1` int(11) DEFAULT NULL,",
      "  `q2` int(11) DEFAULT NULL,",
      "  PRIMARY KEY (`id`),",
      "  KEY `q1_idx` (`q1`),",
      "  KEY `q1_q2_idx` (`q1`,`q2`)",
      ") ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"
    ]
    expect(subject.indexes.first).to eq "KEY `q1_idx` (`q1`)"
    expect(subject.indexes.last).to eq "KEY `q1_q2_idx` (`q1`,`q2`)"
  end

end