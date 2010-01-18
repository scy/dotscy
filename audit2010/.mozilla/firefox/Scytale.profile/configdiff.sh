#!/bin/sh

# Shows the difference between the manual config in user.js and the 
# automatically generated config in prefs.js.

# Settings we don't care about, one per line.
# These are actually regexes, so dots should be escaped.
DONTCARE="
|app\.update\.lastUpdateTime\..+
|extensions\.vimperator\.quickmarks
|extensions\.vimperator\.commandline_(search|cmd)_history
|urlclassifier\.tableversion\..+
"

# You should not need to modify anything below here.
####################################################

# Normalize $DONTCARE
DONTCARE="$(tr -d '\n' <<< "$DONTCARE")"

# Ignore comments, whitespace and all that stuff.
grep '^user_pref("' user.js |

# Sort alphabetically (good thing that Firefox does it in prefs.js too).
sort |

# Show differences without context.
diff -U 0 - prefs.js |

# Cut off the "generated file!!1!1" header comment.
tail -n +15 |

# Filter out $DONTCARE values and position information.
grep -vE "^(@@ |[+-]user_pref\(\"($(tr -d '\n' <<< "$DONTCARE"))\")"

echo '[-] is in user config, [+] in generated prefs'
