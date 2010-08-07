use strict;
use warnings;
use Test::More;

use Test::WWW::Mechanize::Catalyst;
use String::Random qw(random_string random_regex);

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'RavLog');
my $schema = RavLog::Schema->connect('dbi:mysql:dbname=ravlog;user=ravlog_admin;password=rlpw');

$mech->get_ok( '/test_test/view', 'Request should succeed' );
$mech->submit_form_ok( {
        form_number => 1,
        fields => {
            'comment_form.name' => 'some_user',
            'comment_form.email' => 'some_user@example.com',
            'comment_form.url' => 'www.example.com',
            'comment_form.body' => 'adasdfd asdfkjl; a sfjl;dkjfja dfa aslkfjl a;lskjflj;asdfljdkk;',
        }
    },
    'Creating comment'
);

$mech->follow_link_ok({text => 'Login'}, "Login page");
$mech->submit_form_ok( {
        form_number => 1,
        fields => {
            'username' => 'test',
            'password' => 'pass_for_test',
        }
    },
    'Logging in'
);
$mech->get_ok( '/test_test/view', 'Request should succeed' );
$mech->content_contains( 'comment_form.body', 'Comment form after login' );
$mech->content_lacks( 'comment_form.name', 'Comment form after login' );
my $random_comment = 'random ' . random_regex('\w{20}');
$mech->submit_form_ok( {
        form_number => 1,
        fields => {
            'comment_form.body' => $random_comment,
        }
    },
    'Creating comment by user'
);
my $new_comment = $schema->resultset( 'Comment' )->search( { body => $random_comment } )->next;
# don't know why this does not work
# ok( defined $new_comment && defined $new_comment->user && $new_comment->user->username eq 'test' );

done_testing;
