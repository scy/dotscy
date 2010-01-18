#!/bin/sh

# This script generates a search.sqlite out of my own search plugins (and only
# those), in the right order, and disable factory defaults I don't want. Aliases
# are generated as well.

# QUERY will contain the queries that are used to manipulate the database.
# First, start with a clean table.
QUERY='DROP TABLE IF EXISTS engine_data;'
QUERY="${QUERY}CREATE TABLE engine_data (id INTEGER PRIMARY KEY, engineid STRING, name STRING, value STRING);"

# These are the items which are installed by default and to be removed.
REMOVE='amazondotcom-de eBay-de google wikipedia-de yahoo-de'

# For each of those, add and hide them.
I=1
for R in $REMOVE; do
	QUERY="${QUERY}INSERT INTO engine_data (engineid, name, value) VALUES('[app]/$R.xml', 'order', $I);INSERT INTO engine_data (engineid, name, value) VALUES('[app]/$R.xml', 'hidden', 1);"
	I="$(expr "$I" + 1)"
done

# Go through the plugins I really want to have.
cd searchplugins/opensearch

for F in *.xml; do
	# Retrieve the position from the XML file.
	ORDER="$(sed -nr -e 's#<scy:Position>([0-9]+)</scy:Position>#\1#p' "$F" | tr -cd 0-9)"
	# Add the "I" value to prevent having duplicate "order" values.
	ORDER="$(expr "$ORDER" + "$I")"
	# Get the alias.
	ALIAS="$(sed -nr -e 's#<scy:Alias>([a-zA-Z0-9]+)</scy:Alias>#\1#p' "$F" | tr -d '\n\t ')"
	# Create queries.
	QUERY="${QUERY}INSERT INTO engine_data (engineid, name, value) VALUES('[profile]/$F', 'order', $ORDER);"
	QUERY="${QUERY}INSERT INTO engine_data (engineid, name, value) VALUES('[profile]/$F', 'alias', '$ALIAS');"
	# Copy the plugin to Firefox' directory if it's not already there.
	# Firefox reads the plugins and writes them in its own funny format, so we need copies.
	cp -u "$F" ..
done

# Go back.
cd - >/dev/null

# Make the query more beautiful and send it to SQLite.
QUERY="$(echo "$QUERY" | tr ';' '\n' | sed -nr -e 's/.+$/\0;/p')"

echo "$QUERY" | sqlite3 search.sqlite
