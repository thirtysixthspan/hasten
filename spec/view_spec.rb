require './spec/spec_helper'

describe Hasten::View do

  it "identifies delimited view names" do
    subject << <<-EOC
      CREATE VIEW `test` AS
        SELECT * FROM `section1`
        UNION
        SELECT * FROM `section2`;
    EOC
    expect(subject.name).to eq('test')
  end

  it "identifies delimited view names for alternative syntax" do
    subject << <<-EOC
      VIEW `test` AS
        SELECT `section1`.`q1`,`section2`.`q2`
        FROM `test`
        JOIN `section1s` ON `test`.`section1_id` = `section1s`.`id`
        JOIN `section2s` ON `test`.`section2_id` = `section2s`.`id`
    EOC
    expect(subject.name).to eq('test')
  end

end