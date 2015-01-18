#!/usr/bin/env ruby

require 'mysql2'
require 'faker'
require 'benchmark'

def client
  @client ||= Mysql2::Client.new(
    :host => "localhost",
    :username => "root",
    :socket => "/var/lib/mysql/mysql.sock"
  )
end

def setup_database_and_table
  client.query("DROP DATABASE IF EXISTS `hasten`")
  client.query("CREATE DATABASE `hasten`")
  client.query("USE `hasten`;")
  client.query("DROP TABLE IF EXISTS `hasten`;")

  client.query(<<-EOC)
    CREATE TABLE `hasten` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `name` VARCHAR(255) DEFAULT NULL,
      `address_detail_id` int(11) NOT NULL,
      `billing_detail_id` int(11) NOT NULL,
      PRIMARY KEY (`id`),
      KEY `name` (`id`, `name`),
      KEY `address` (`address_detail_id`),
      KEY `billing` (`billing_detail_id`),
      KEY `foreign` (`id`, `address_detail_id`, `billing_detail_id`),
      KEY `covering` (`id`, `name`, `address_detail_id`, `billing_detail_id`)
    ) ENGINE = InnoDB;
  EOC
end

def insert_random_data(rows)
  batch_size = 50000
  batches = rows / batch_size
  batches.times.each do
    data = batch_size.times
      .map { "(\"#{Faker::Name.name}\", #{rand(10000)}, #{rand(10000)})" }
    client.query <<-EOC
      INSERT INTO `hasten`
        (`name`, `address_detail_id`, `billing_detail_id`)
      VALUES
        #{data.join(',')}
    EOC
  end
end

def mysql_dump
  `mysqldump -uroot hasten > hasten_test_db.sql`
end

def create_import_database
  client.query("CREATE DATABASE `hasten_test`")
end

def drop_import_database
  client.query("DROP DATABASE IF EXISTS `hasten_test`")
end

def load_test_db
  `cat hasten_test_db.sql | mysql -uroot hasten_test`
end

def hasten_test_db
  `cat hasten_test_db.sql | hasten | mysql -uroot hasten_test`
end

def execute(total_rows, new_rows)
  insert_random_data(new_rows)
  mysql_dump
  drop_import_database
  create_import_database
  direct = Benchmark.realtime { load_test_db }
  drop_import_database
  create_import_database
  hasten = Benchmark.realtime { hasten_test_db }
  [
    total_rows,
    direct.to_f,
    hasten.to_f,
    (( direct.to_f / hasten.to_f ) - 1.0) * 100.0
  ]
end

def benchmark_run(max=5000000, steps=100000)
  setup_database_and_table
  steps.step(max, steps).map { |rows|
    result = execute(rows, steps)
    puts "%d\t%.2f\t%.2f\t%.0f" % result
    result
  }
end

puts "rows\tdirect\thasten\tspeedup %"
performance = benchmark_run


