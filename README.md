WebService-DataDog
====================

This module allows you to interact with DataDog (http://http://www.datadoghq.com/),
a service that will "Capture metrics and events, then graph, filter, and search
to see what's happening and how systems interact. Datadog is a service for IT,
Operations and Development teams who write and run applications at scale, and
want to turn the massive amounts of data produced by their apps, tools and
services into actionable insight."

This module encapsulates all the communications with the REST API provided by
DataDog to offer a Perl interface to metrics, dashboards, events, alerts, host
tags, etc.

You can find your API key, and generate application keys at
https://app.datadoghq.com/account/settings

For help with graph definitions (when creating/updating dashboards), please visit
http://docs.datadoghq.com/graphing/  and
http://help.datadoghq.com/kb/graphs-dashboards/graph-primer

Build status: [![Build Status](https://travis-ci.org/jpinkham/webservice-datadog.png)](https://travis-ci.org/jpinkham/webservice-datadog)

Test coverage: [![Coverage Status](https://coveralls.io/repos/jpinkham/webservice-datadog/badge.png?branch=master)](https://coveralls.io/r/jpinkham/webservice-datadog?branch=master)



INSTALLATION
-------------

To install this module, run the following commands:

	perl Build.PL
	./Build
	./Build test
	./Build install


NOTES
------

 * WebService::DataDog::Alert, in retrieve() and update():
A 404 response typically indicates an incorrect alert id was specified

 * WebService::DataDog::Comment, in create() and update():
The 'handle' parameter must specify a username on the "team" (https://app.datadoghq.com/account/team)
associated with your account, otherwise your update will fail with a 400 or 404
error.
	
 * WebService::DataDog::Dashboard, in delete():
You cannot remove system-generated or integration dashboards.

 * WebService::DataDog::Event, in retrieve():
Receiving a 404 response likely means the requested event id does not exist

 * WebService::DataDog::Metric, in emit():
Only metrics of type 'gauge' and type 'counter' are supported. You must use a
dogstatsd client such as Net::Dogstatsd to post metrics of other types
(ex: 'timer', 'histogram', 'sets' or use  increment() or decrement() on a counter).
The primary advantage of the API vs dogstatsd for posting metrics: API supports
specifying a timestamp, thereby allowing posting metrics from the past.

 * WebService::DataDog::Tag, in add(), retrieve(), update():
A 404 response typically indicates you specified an incorrect/unknown host name/id.
Also, all methods, except retrieve_all(), operate on a per-host basis rather than
on a per-tag basis. You cannot rename a tag or delete a tag from all hosts,
through the DataDog API. *Tags containing two colons will not be allowed because
it causes confusion in the graphing interface, which "drills down" based on
key:value pairs (using a single colon).


SUPPORT AND DOCUMENTATION
-------------------------

After installing, you can find documentation for this module with the
perldoc command.

    perldoc WebService::DataDog

You can also look for information at:

    RT, CPAN's request tracker (report bugs here)
        http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-DataDog

    AnnoCPAN, Annotated CPAN documentation
        http://annocpan.org/dist/WebService-DataDog

    CPAN Ratings
        http://cpanratings.perl.org/d/WebService-DataDog

    Search CPAN
        http://search.cpan.org/dist/WebService-DataDog/


LICENSE AND COPYRIGHT
---------------------
Copyright (C) 2013 Jennifer Pinkham

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License.

See http://dev.perl.org/licenses/ for more information.

