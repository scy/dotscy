syntax clear

syntax case match

" Line with timestamps.
syntax match StampedLine "\v^[0-9]{4}(-[0-9]{2}){2} [0-9]{2}(:[0-9]{2}){2},[0-9]{3}.+"he=s+24

" Error messages.
syntax match Special "\[WARN\].\+" containedin=StampedLine
syntax match Special "^[^ ]\+Exception: .\+"
syntax match Special "^ \+.\+"

" Status changes.
syntax match Special "\[DEBUG\] >\{9\} .\+"hs=s+8 containedin=StampedLine
syntax match Special "Anzahl momentan verf.\{1,2\}gbarer Suchmaschinen: .\+" containedin=StampedLine

" URLs.
syntax match Underlined "^\tURL:.\+"hs=s+5
syntax match Underlined "ImprintFinder: Fetching .\+ (try [0-9])\.\.\.$"hs=s+24,he=e-11 containedin=StampedLine
syntax match Underlined " unter der Webadresse [^ ]\+"hs=s+22 containedin=StampedLine
syntax match Underlined "ImprintFinder: Failed to get .\+ (message:"hs=s+29,he=e-10 containedin=StampedLine
syntax match Underlined "auf der Website .\+ ist fehlgeschlagen.$"hs=s+16,he=e-20 containedin=StampedLine
syntax match Underlined "konnte nicht von der Adresse .\+ heruntergeladen werden.$"hs=s+29,he=e-24 containedin=StampedLine
syntax match Underlined "wurde von der Adresse .\+ heruntergeladen"hs=s+22,he=e-16 containedin=StampedLine
syntax match Underlined "https\?://[^ ]\+" containedin=StampedLine
syntax match Underlined ";https\?://[^;]\+"hs=s+1 containedin=Result

" Company names.
syntax match CompanyName "Die Website der Firma '.\+' konnte nicht gefunden werden.$"hs=s+22,he=e-30 containedin=StampedLine
syntax match CompanyName "Aus dem Impressum der Firma '.\+'"hs=s+28 containedin=StampedLine
syntax match CompanyName "Die Suche nach dem Impressum der Firma '.\+'"hs=s+39 containedin=StampedLine
syntax match CompanyName "Das Impressum der Firma '.\+'"hs=s+24 containedin=StampedLine
syntax match CompanyName "Das Ergebnis f.\{1,2\}r die Firma '.\+' wurde"hs=s+28,he=e-6 containedin=StampedLine

" Results.
syntax match Result "\[DEBUG\] \(.*;\)\{5,\}.*"hs=s+8 containedin=StampedLine

" Timestamps are comments.
highlight link StampedLine Comment

" Company names are strings.
highlight link CompanyName String

" Results are identifiers.
highlight link Result Identifier
