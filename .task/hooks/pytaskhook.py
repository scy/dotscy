#!/usr/bin/env python

"""Some utility functions for Taskwarrior hooks.

This module intentionally uses only stdlib and tries to stay compatible to Python 2.5.
The reason behind this is that my dotfiles run on several machines with different
Python versions installed, and I don't want to (and sometimes even can't) install
third-party libraries."""

import calendar, json, sys
from datetime import datetime, tzinfo, timedelta
from time import mktime, time, timezone

# All the Taskwarrior fields that should be parsed as datetime objects.
DATEFIELDS = [ 'entry', 'start', 'end', 'due', 'until', 'wait', 'modified', 'scheduled' ]

class UTC(tzinfo):
    """A simple implementation of the UTC timezone.

    I've borrowed this from the Python documentation.

    This module can handle two different types of datetime objects: Naive ones (i.e.
    without any tzinfo), which will be treated as being in the machine's local timezone,
    and timezone-aware ones, but bad things will happen if you use any other timezone
    than UTC. I'm sorry, but this is as far as I can go without reimplementing pytz."""
    def utcoffset(self, dt):
        return timedelta(0)
    def tzname(self, dt):
        return 'UTC'
    def dst(self, dt):
        return timedelta(0)

def parse_add():
    """Read a single JSON task from stdin and return it as a Python hash."""
    return to_py(sys.stdin.readline())

def parse_mod():
    """Read two JSON tasks from stdin (old and new) and return them as a tuple of Python hashes."""
    return (
        to_py(sys.stdin.readline()),
        to_py(sys.stdin.readline())
    )

def parse_add_or_mod():
    """Read either one or two JSON tasks from stdin and return them as a tuple.

    The first item in the tuple is either the string 'add' or the string 'mod',
    depending on whether one or two lines could be read from stdin.

    The second item is the old version of the task if this is a mod operation, or None
    if it's an add. The third item is of course the new version (if it's a mod) or the
    task to be created (if it's an add).

    This function makes it easy to write hooks that work for both add and mod operations."""
    first  = to_py(sys.stdin.readline())
    second = sys.stdin.readline()
    if second == '':
        # There was only one line, i.e. this is an add operation.
        return ('add', None, first)
    # There were two lines, this is a mod operation.
    return ('mod', first, to_py(second))

def to_py(data):
    """Convert a JSON task to a Python hash, turning timestamps to datetime objects."""
    # If the data is a string, parse it as JSON.
    data = json.loads(data) if isinstance(data, basestring) else data
    # Convert the dates, setting their timezone to UTC.
    utc = UTC()
    for field in DATEFIELDS:
        if field in data:
            data[field] = datetime.strptime(data[field], '%Y%m%dT%H%M%SZ').replace(tzinfo=utc)
    return data

def to_json(data):
    """Convert a Python hash to a JSON task, turning datetime objects into timestamps."""
    # Convert the dates back, make sure they're in UTC.
    for field in DATEFIELDS:
        if field in data:
            data[field] = to_utc(data[field]).strftime('%Y%m%dT%H%M%SZ')
    return json.dumps(data)

def to_local(dt):
    """Convert a UTC datetime to a naive one that uses the machine's timezone."""
    # Don't modify it if it's already naive.
    if dt.tzinfo is None:
        return dt
    epoch = calendar.timegm(dt.timetuple())
    local = datetime.fromtimestamp(epoch)
    return local

def to_utc(dt):
    """Convert a naive datetime that uses the machine's timezone to a UTC one."""
    # Don't modify it if it already has a timezone -- even if it's not UTC!
    # Yes, this is kinda limited, but should be enough for working with Taskwarrior.
    if dt.tzinfo is not None:
        return dt
    epoch = mktime(dt.timetuple())
    utc = datetime.utcfromtimestamp(epoch).replace(tzinfo=UTC())
    return utc

def utc_offset():
    """Return the local machine's current offset to UTC as a timedelta."""
    ts = time()
    return datetime.fromtimestamp(ts) - datetime.utcfromtimestamp(ts)

def utc_offset_str():
    """Return the local machine's current offset to UTC as a string like '+02:00'."""
    secs = utc_offset().seconds
    hours, remainder = divmod(abs(secs), 3600)
    minutes, seconds = divmod(remainder, 60)
    return '%s%02u:%02u' % ('-' if secs < 0 else '+', hours, minutes)
