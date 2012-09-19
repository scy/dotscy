#!/usr/bin/env python

from biplist import *
import datetime, json, os, re

plists = {
	"com.googlecode.iterm2": {
		"exclude": (
			(re.compile(r"^NSWindow Frame (?:.*)$"),),
		),
	}
}

def isincluded(path, settings):
	if not 'exclude' in settings:
		return True
	tupletype = type(tuple())
	for exclude in settings['exclude']:
		if type(exclude) == tupletype:
			for idx in range(0, min(len(exclude), len(path))):
				if type(exclude[idx]) == re._pattern_type:
					if exclude[idx].match(path[idx]):
						return False
	return True

def totypeddict(plist, path=None, settings=None):
	dicttype = type(dict())
	listtype = type(list())
	datetype = datetime.datetime
	if (path == None):
		path = ()
	if (settings == None):
		settings = {}
	if type(plist) == dicttype:
		result = dict()
		for key, value in plist.iteritems():
			subpath = path + (key,)
			if isincluded(subpath, settings):
				result[key] = totypeddict(value, subpath, settings)
		return ('dict', result)
	if type(plist) == listtype:
		result = list()
		for idx, value in enumerate(plist):
			subpath = path + (idx,)
			if isincluded(subpath, settings):
				result.append(totypeddict(value, subpath, settings))
		return ('arr', result)
	if type(plist) == datetype:
		return ('date', plist.isoformat())
	return (type(plist).__name__, plist)

for domain, settings in plists.iteritems():
	plist = readPlist(os.path.expanduser(
		'~/Library/Preferences/%s.plist' % domain
	))
	outfile = open(os.path.expanduser(
		'~/.plists/%s.json' % domain
	), 'w')
	jsonstr = json.dumps(totypeddict(plist, settings=settings), indent=2)
	outfile.write(jsonstr)
	outfile.close()
