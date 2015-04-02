package Schoo_study::Lib;

use Exporter qw/import/;
our @EXPORT= qw/thread_list/;

use strict;
use warnings;
use DBI;

sub conn
{
  my $dsn= "dbi:mysql:mydb;host=192.168.198.214;port=64057";
  my $opt= {RaiseError => 1, mysql_enable_utf8 => 1};

  return DBI->connect($dsn, "root", "", $opt);
}


sub thread_list
{
  my ($sql)= @_;
  my $ret= conn->selectall_arrayref($sql, {Slice => {}});;

  return $ret;
}


return 1;
