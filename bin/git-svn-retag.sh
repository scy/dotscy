#!/bin/bash

# Will convert branches created by git-svn to "real" annotated Git tags.

# Based upon http://frank.thomas-alfeld.de/wp/2008/08/30/converting-git-svn-tag-branches-to-real-tags/
# Modified on 2008-11-01 by Tim Weber <https://scytale.name/>

# You can supply a tag prefix via the PREFIX variable like so:
# PREFIX=upstream- gitretag.sh

for branch in $(git branch -r | grep tags/); do
	version="$(basename "$branch")"
	subj="$(git log -1 --pretty=format:%s "$branch")"
	export GIT_COMMITTER_DATE="$(git log -1 --pretty=format:%ci "$branch")"
	git tag -a -f -m "$subj" "${PREFIX}${version}" "$branch"
	git branch -d -r "$branch"
done
