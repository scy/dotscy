syntax clear

syntax case match

" Line with timestamps.
syntax match StampedLine "\v^[0-9]{4}(-[0-9]{2}){2} [0-9]{2}(:[0-9]{2}){2},[0-9]{3}.+"he=s+24

" Error messages.
syntax match Error "\[WARN\].\+" containedin=StampedLine
syntax match Error "^[^ ]\+Exception: .\+"
syntax match Error "^   [^ ].\+"hs=s+3

" Status changes.
syntax match Special "\[DEBUG\] >\{9\} .\+" containedin=StampedLine

" URLs.
syntax match Underlined "^\tURL:.\+"hs=s+5
syntax match Underlined "ImprintFinder: Fetching .\+ (try [0-9])\.\.\.$"hs=s+24,he=e-11 containedin=StampedLine
syntax match Underlined " unter der Webadresse [^ ]\+"hs=s+22 containedin=StampedLine

" Company names.
syntax region CompanyName oneline matchgroup=Transparent start="Die Website der Firma " end=" konnte nicht gefunden werden." containedin=StampedLine
syntax match CompanyName "Aus dem Impressum der Firma '.\+'"hs=s+28 containedin=StampedLine

" Timestamps are comments.
highlight link StampedLine Comment

" Company names are strings.
highlight link CompanyName String
