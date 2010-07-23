use strict;
use warnings;
use Test::More;
use Config::Any::Perl;

use lib 't/lib';

use_ok( 'RavLog::Schema');
use_ok( 'RavLog::Schema::Result::User');

my $config = Config::Any::Perl->load( 'ravlog_local.pl' );
my $schema = RavLog::Schema->connect( @{ $config->{'Model::DB'}{connect_info} } );

ok($schema, 'get db schema');

my $user = $schema->resultset('User')->find(1);
unless( $user )
{
   $user = $schema->resultset('User')->create({ username => 'test', password => 'testpw'} );
}
ok( $user,  'get user' );

my @articles = $schema->resultset('Article')->get_latest_articles;

foreach my $article (@articles)
{
   print $article->subject, "\n";
   print $article->user->username, "\n" if $article->user;
   print $article->formatted_body, "\n";
}

my $article = $schema->resultset('Article')->new_result({});
ok( $article, 'new result for Article worked' );

done_testing;
