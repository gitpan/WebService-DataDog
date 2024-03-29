#!perl -T

use strict;
use warnings;

use Data::Dumper;
use Data::Validate::Type;
use Test::Exception;
use Test::More;
use WebService::DataDog;


eval 'use DataDogConfig';
$@
	? plan( skip_all => 'Local connection information for DataDog required to run tests.' )
	: plan( tests => 10 );

my $config = DataDogConfig->new();

# Create an object to communicate with DataDog
my $datadog = WebService::DataDog->new( %$config );
ok(
	defined( $datadog ),
	'Create a new WebService::DataDog object.',
);


my $comment_obj = $datadog->build('Comment');
ok(
	defined( $comment_obj ),
	'Create a new WebService::DataDog::Comment object.',
);

my $response;

throws_ok(
	sub
	{
		$response = $comment_obj->create();
	},
	qr/Argument.*required/,
	'Dies without required arguments',
);


throws_ok(
	sub
	{
		$response = $comment_obj->create(
			message          => "testing comment 1 2 3",
			related_event_id => "abcd",
		);
	},
	qr/'related_event_id' must be an integer/,
	'Dies on invalid related event id',
);



lives_ok(
	sub
	{
		$response = $comment_obj->create(
			message          => "Message goes here",
		);
	},
	'Create new comment - no related event.',
)|| diag explain $response;

ok(
	Data::Validate::Type::is_hashref( $response ),
	'Response is a hashref.',
);


my $event_id = $response->{'id'};

# Add a comment to thread of message we just created
lives_ok(
	sub
	{
		$response = $comment_obj->create(
			message          => "Message2 goes here",
			related_event_id => $event_id,
		);
	},
	'Create new comment - specifying related event.',
)|| diag explain $response;

my $new_comment_id = $response->{'id'};

is(
	$response->{'related_event_id'},
	$event_id,
	'Comment added to existing thread.'
);


# Store id for use in upcoming tests

ok(
	open( FILE, '>', 'webservice-datadog-comment-commentid.tmp'),
	'Open temp file to store new comment id'
);

print FILE $new_comment_id;

ok(
	close FILE,
	'Close temp file'
);
