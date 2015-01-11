module Hasten

  # By default, MySQL runs with autocommit mode enabled. This means that
  # as soon as you execute a statement that updates (modifies) a table,
  # MySQL stores the update on disk to make it permanent.
  #
  # To disable autocommit mode explicitly, use the following statement:
  #   SET autocommit=0;
  # After disabling autocommit mode by setting the autocommit variable
  # to zero, changes to transaction-safe tables (such as those for
  # InnoDB, BDB, or NDBCLUSTER) are not made permanent immediately.
  # You must use COMMIT to store your changes to disk or ROLLBACK to
  # ignore the changes.
  #
  # From http://dev.mysql.com/doc/refman/5.0/en/commit.html
  #
  DISABLE_AUTOCOMMIT = "SET SESSION autocommit=0;"
  COMMIT = "COMMIT;"

  # If you have UNIQUE constraints on secondary keys, you can speed
  # up a table import by turning off the uniqueness checks temporarily
  # during the import operation:
  #   SET unique_checks=0;
  #   ... import operation ...
  #   SET unique_checks=1;
  # For big tables, this saves a lot of disk I/O because InnoDB can then
  # use its insert buffer to write secondary index records as a batch.
  # Be certain that the data contains no duplicate keys.
  #
  # From http://dev.mysql.com/doc/refman/5.0/en/converting-tables-to-innodb.html
  #
  DISABLE_UNIQUENESS_CHECKS = "SET SESSION unique_checks=0;"

  # To make it easier to reload dump files for tables that have foreign
  # key relationships, mysqldump automatically includes a statement in
  # the dump output to set foreign_key_checks to 0. This avoids problems
  # with tables having to be reloaded in a particular order when the dump
  # is reloaded. It is also possible to set this variable manually:
  # mysql> SET foreign_key_checks = 0;
  # mysql> SOURCE dump_file_name;
  # mysql> SET foreign_key_checks = 1;
  # This enables you to import the tables in any order if the dump file
  # contains tables that are not correctly ordered for foreign keys. It
  # also speeds up the import operation.
  #
  # From http://dev.mysql.com/doc/refman/5.1/en/create-table-foreign-keys.html
  #
  DISABLE_FOREIGN_KEY_CHECKS = "SET SESSION foreign_key_checks=0;"

  # The sql_log_bin variable controls whether logging to the binary log
  # is done. The default value is 1 (do logging). To change logging for
  # the current session, change the session value of this variable. The
  # session user must have the SUPER privilege to set this variable. Set
  # this variable to 0 for a session to temporarily disable binary
  # logging while making changes to the master which you do not want to
  # replicate to the slave.
  #   SET sql_log_bin = {0|1}
  #
  # From http://dev.mysql.com/doc/refman/5.7/en/set-sql-log-bin.html
  #
  DISABLE_BINARY_LOGS = "SET SESSION sql_log_bin=0;"

  DEFAULT_MODES = [
    DISABLE_AUTOCOMMIT,
    DISABLE_UNIQUENESS_CHECKS,
    DISABLE_FOREIGN_KEY_CHECKS,
    DISABLE_BINARY_LOGS
  ]

end