#!/usr/bin/perl

use strict;
use warnings;
use DBI;

my $conn= DBI->connect("dbi:mysql:mydb;mysql_socket=/usr/mysql/5.7.6/data/mysql.sock",
                       "root", "");

$conn->do("CREATE TABLE IF NOT EXISTS 3NF_thread_metadata LIKE 2NF_thread_metadata");
$conn->do("INSERT INTO 3NF_thread_metadata SELECT * FROM 2NF_thread_metadata");
$conn->do("CREATE TABLE IF NOT EXISTS 3NF_bbs_main (" .
            "thread_title VARCHAR(255) NOT NULL, " .
            "thread_owner VARCHAR(255) NOT NULL, " .
            "comment_number INT UNSIGNED NOT NULL, " .
            "comment_owner VARCHAR(255) NOT NULL, " .
            "comment_created DATETIME NOT NULL, " .
            "comment_body LONGTEXT NOT NULL, " .
            "PRIMARY KEY (thread_title, thread_owner, comment_number))");
$conn->do("INSERT INTO 3NF_bbs_main (" .
            "thread_title, thread_owner, comment_number, " .
            "comment_owner, comment_created, comment_body) " .
          "SELECT thread_title, thread_owner, comment_number, " .
            "comment_owner, comment_created, comment_body " .
          "FROM 2NF_bbs_main");
$conn->do("CREATE TABLE IF NOT EXISTS 3NF_user_email LIKE 2NF_user_email");
$conn->do("INSERT INTO 3NF_user_email SELECT * FROM 2NF_user_email");
$conn->do("INSERT IGNORE INTO 3NF_user_email SELECT DISTINCT comment_owner, comment_owner_email FROM 2NF_bbs_main");


exit 0;

