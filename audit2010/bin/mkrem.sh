#!/bin/sh

cd "$HOME/pim/cal"

# Make birthdays.
(
echo 'FSET since(x) ord(year(trigdate())-x)'
sed -r -e 's#^([0-9]{4}) ([A-Za-z]{3}) ([0-9]{2}) +([0-9]{1,2}) (.+)$#REM \2 \3 +\4 MSG %"* \5 (\1, [since(\1)])%" %b#' src/bday
) > bday.rem

# Track found source files.
srcthere='bday.rem'

# Make other reminders.
for sf in src/*.rem; do
	f="$(basename "$sf")"
	srcthere="$(echo "$srcthere $f" | tr ' ' '\n')"
	if [ "$sf" -nt "$f" -o "$1" = '-f' ]; then
		sed -r \
			-e 's/^(REM .+ \+[0-9]+(| +.*) MS[GF] +)(.*)$/\1%b: %"\3%"/' \
			-e 's/^(REM .+ +AT +[0-9:.]+(| .*) +DURATION +([0-9]+)[:.]([0-9]+)(| .*) MS[GF] +)(%b: )?(%")?(.*)(%")?$/\1\6[trigtime()]-[trigtime()+(60*\3)+\4]: %"\8%"/' \
			-e 's/(%")+$/%"/' \
			"$sf" > "$f"
	fi
done

# Update reminders list.
(
cat <<EOF
BANNER %w, %d. %m %y%o%_Daylight: [sunrise()]-[sunset()] (tomorrow: [sunrise(today()+1)]-[sunset(today()+1)])
EOF
echo "$srcthere" | sed -e "s#.*#INCLUDE $HOME/pim/cal/\0#"
) > "$HOME/.reminders"

# Remove .rem files which have no source file.
for f in *.rem; do
	[ -z "$(echo "$srcthere" | grep "^$f\$")" ] && rm "$f"
done

cd - >/dev/null
