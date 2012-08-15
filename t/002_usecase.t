use Test::More tests => 4;

use strict;
use warnings;

use Dancer::Session::ElasticSearch;
use Dancer qw(:syntax :tests);

set 'session_options' => {
    signing => {
        secret => "lkjadslaj!ljasxmHasjaojsxm!!'",
        length => 12
    }
};

# create a session
my $session = Dancer::Session::ElasticSearch->create;

isa_ok $session, 'Dancer::Session::ElasticSearch';

my $id = $session->id;

$session->flush;

is $session->id, $id, "Session ID remains the same after flushing";

$session->retrieve($id);

is $session->id, $id, "Session ID remains the same after retrieval";

eval { $session->retrieve("NOTASESSIONID") };

like $@, "/Session ID not verified/",
    "Retrieving with an invalid session ID errors";

$session->destroy;
