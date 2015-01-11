require './spec/spec_helper'

describe Hasten::Dump do

  context "with indexed tables" do

    let(:in_io) {
      StringIO.new(<<-EOS)
        CREATE TABLE `test` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `q1` int(11) DEFAULT NULL,
          `q2` int(11) DEFAULT NULL,
          PRIMARY KEY (`id`),
          KEY `q1_idx` (`q1`),
          KEY `q1_q2_idx` (`q1`,`q2`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
      EOS
    }

    let(:out_io) { StringIO.new }

    before do
      described_class.new(in_io,out_io).execute
    end

    it "shifts indexes to the end of the dump" do
      expect(out_io.string).to include "ALTER TABLE `test` ADD KEY `q1_idx` (`q1`);"
    end

    it "removes indexes from the table definition" do
      expect(squish out_io.string).to include (squish <<-EOS)
        CREATE TABLE `test` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `q1` int(11) DEFAULT NULL,
          `q2` int(11) DEFAULT NULL,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
      EOS
    end

  end

  context "with insert statements" do

    let(:in_io) {
      StringIO.new(<<-EOS)
        CREATE TABLE `test` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `q1` int(11) DEFAULT NULL,
          `q2` int(11) DEFAULT NULL,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
        INSERT INTO `test` VALUES
          (1,1,2),
          (2,3,4),
          (3,5,6);
      EOS
    }

    let(:out_io) { StringIO.new }

    before do
      described_class.new(in_io,out_io).execute
    end

    it "passes insert statement unmodified" do
      expect(squish out_io.string).to include (squish <<-EOS)
        INSERT INTO `test` VALUES
          (1,1,2),
          (2,3,4),
          (3,5,6);
      EOS
    end

  end

  context "with views" do

    let(:in_io) {
      StringIO.new(<<-EOS)
      VIEW `test` AS
        SELECT `section1`.`q1`,`section2`.`q2`
        FROM `test`
        JOIN `section1s` ON `test`.`section1_id` = `section1s`.`id`
        JOIN `section2s` ON `test`.`section2_id` = `section2s`.`id`
      EOS
    }

    let(:out_io) { StringIO.new }

    before do
      described_class.new(in_io,out_io).execute
    end

    it "passes insert statement unmodified" do
      expect(squish out_io.string).to include (squish in_io.string)
    end

  end

end