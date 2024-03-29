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


my $tag_obj = $datadog->build('Tag');
ok(
	defined( $tag_obj ),
	'Create a new WebService::DataDog::Tag object.',
);
my $response;


throws_ok(
	sub
	{
		$response = $tag_obj->retrieve();
	},
	qr/Argument.*required/,
	'Dies on missing required argument.',
);

dies_ok(
	sub
	{
		$response = $tag_obj->retrieve( host => "abc123" );
	},
	'Dies on invalid host.',
);

ok(
	open( FILE, 'webservice-datadog-tag-host.tmp'),
	'Open temp file containing a hostname.'
);

my $host_id;
ok(
	$host_id = do { local $/; <FILE> },
	'Read in host id.'
);

ok(
	close FILE,
	'Close temp file.'
);

lives_ok(
	sub
	{
		$response = $tag_obj->retrieve( host => $host_id );
	},
	'Request list of tags for a specific host.',
);

ok(
	defined( $response ),
	'Response was received.'
);

ok(
	Data::Validate::Type::is_arrayref( $response ),
	'Response is an arrayref.',
) || diag explain $response;

