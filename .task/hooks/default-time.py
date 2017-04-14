#!/usr/bin/env python

"""If the task is due at midnight, instead set its due time in the evening.

When you specify a due date like 'tomorrow' without specifying a time, Taskwarrior will
set the task to be due at 00:00 tomorrow. This is usually not what I want. "Due tomorrow"
means that I can finish the task during the day. It should be done when the day ends, not
when it starts.

A workaround would be to set the task to be due 'tomorrow + 1 day', but this is
cumbersome and counter-intuitive. Therefore, this hook will change the due time to a
configurable time (for example, 22:00) if it's due exactly at midnight.

Since Taskwarrior uses the local machine's notion of "midnight" when no time is specified,
we have some fancy timezone conversion going on to recognize when midnight is.

Should you need to set a task to be due exactly at midnight, you can force this hook to
not change the time by setting a tag of 'allow_midnight'."""

from datetime import time
from pytaskhook import parse_add_or_mod, to_json, to_local, to_utc
import json

DEFAULT_TIME = time(22, 0, 0)

msg = None

(op, old, new) = parse_add_or_mod()
if 'due' in new:
    localdue = to_local(new['due'])
    if localdue.time() == time(0, 0, 0):
        if 'tags' in new and 'allow_midnight' in new['tags']:
            msg = 'allow_midnight tag is present, not modifying midnight due time.'
        else:
            localdue = localdue.replace(hour=DEFAULT_TIME.hour, minute=DEFAULT_TIME.minute, second=DEFAULT_TIME.second)
            new['due'] = to_utc(localdue)
            msg = 'Changed due time from midnight to default of ' + DEFAULT_TIME.strftime('%H:%M') + '.'

print to_json(new)
if msg:
    print msg
