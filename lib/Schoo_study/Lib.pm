package Schoo_study::Lib;

use Exporter qw/import/;
our @EXPORT= qw/make_array/;

use strict;
use warnings;
use DBI;

sub conn
{
  my $dsn= "dbi:mysql:mydb;host=192.168.198.214;port=64057";
  my $opt= {RaiseError => 1, mysql_enable_utf8 => 1};

  return DBI->connect($dsn, "root", "", $opt);
}


sub make_array
{
  my ($sql, @args)= @_;
  my $ret= conn->selectall_arrayref($sql, {Slice => {}}, @args);;

  return $ret;
}


return 1;
