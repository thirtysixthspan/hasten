require './spec/spec_helper'

describe Hasten::Command do

  it "strips whitespace from sql" do
    subject << "  SET TIME_ZONE='+00:00';  "
    expect(subject.sql).to eq "SET TIME_ZONE='+00:00'"
  end

  it "extracts conditional sql" do
    subject << "/*!40103 SET TIME_ZONE='+00:00' */;"
    expect(subject.sql).to eq "SET TIME_ZONE='+00:00'"
  end

  it "considers comments complete" do
    subject << "-- Server version 5.6.22"
    expect(subject.complete?).to be_true
  end

  it "considers semicolon terminated lines complete" do
    subject << "DROP TABLE IF EXISTS `test`;"
    expect(subject.complete?).to be_true
  end

  it "considers lines without semicolons incomplete" do
    subject << "DROP TABLE IF EXISTS `test`"
    expect(subject.complete?).to be_false
  end

  it "parses multiline sql" do
    subject << <<-EOC
      SELECT *
      FROM `test`
      WHERE c1 = 'name';
    EOC
    expect(subject.complete?).to be_true
  end

  it "identifies Table definitions" do
    subject << <<-EOC
      CREATE TABLE `test` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `q1` int(11) DEFAULT NULL,
        `q2` int(11) DEFAULT NULL,
        PRIMARY KEY (`id`),
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
    EOC
    expect(subject.type).to eq('Table')
  end

  it "identifies View definitions" do
    subject << <<-EOC
      CREATE VIEW `test` AS
        SELECT * FROM `section1`
        UNION
        SELECT * FROM `section2`;
    EOC
    expect(subject.type).to eq('View')
  end

  it "identifies Insert statements" do
    subject << <<-EOC
      INSERT INTO `contact_fields` VALUES
        (1,'Name',0),
        (2,'Address',0),
        (3,'Phone',0);
    EOC
    expect(subject.type).to eq('Insert')
  end

  it "accepts other commands" do
    command1 = Hasten::Command.new
    command1 << "line 1"
    command1 << "line 2"
    command2 = Hasten::Command.new
    command2 << command1
    expect(command2.sql).to eq command1.sql
  end

end