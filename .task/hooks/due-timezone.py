#!/usr/bin/env python

"""Store the due date's timezone in a UDA.

Taskwarrior internally stores all times as UTC. While this is better than storing them
as local times in the timezone of whatever machine you were using at that moment, it
also means that you lose the information about what time of day the timestamp was
actually referring to.

For example, I always set my tasks that don't have a specific due _time_ to be due at
22:00 of whatever day they're due on. If I now move to another timezone, I most likely
want these tasks to be due at 22:00 in that new timezone, instead of whatever 22:00 in
the old zone might be where I am now.

With this additional field I can reconstruct the real time of day I intended when
setting the due date and semi-automatically shift task due times around.

When you first set a 'due' value or modify an existing one, the machine's current UTC
offset will be recorded in 'due_tz'."""

from pytaskhook import parse_add_or_mod, to_json, utc_offset_str

(op, old, new) = parse_add_or_mod()
if 'due' in new:
    olddue = None if old is None or 'due' not in old else old['due']
    # If there is no due_tz value in the task already, always set one.
    # Also set it if this is a modification and the due time changed.
    if 'due_tz' not in new or (op == 'mod' and olddue != new['due']):
        new['due_tz'] = utc_offset_str()

print to_json(new)
