" external.vim: A vim script assisting with filetype recognition when using
"               the external.exe program.
"
" Author: Ben Collerson (benc at bur dot st)
" Last Change: 26 Jan 2005
" Created: 19 Jan 2005
" Requires: Vim-6, exed (external program)
" Version: 0.1
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt 
" Download From:
"          http://bur.st/~benc/?p=external
" Usage:
"     This should normally be used only in the context of having external 
"     start a vim session. 
"     
"     The function External() can be modified to allow matching of other 
"     window titles and filetypes as required.
"
" Installation:
"     Drop this file in your plugin directory.

function s:External(title)
  let windowTitle = a:title

  if windowTitle =~? 'mail\|new memo\|compose\|nachricht (nur-text)'
    setfiletype mail
  elseif windowTitle =~? 'sql\|microsoft access'
    setfiletype sql
  elseif windowTitle =~? 'sigma'
    setfiletype rw
  elseif windowTitle =~? 'edit page'
    setfiletype html
  else
    setfiletype text
  endif

  " reset EnhancedCommentify.vim
  if exists("b:ECdidBufferInit")
    unlet b:ECdidBufferInit
    call EnhancedCommentifyInitBuffer()
  endif

endf

command! -nargs=1 External :call <SID>External(<args>)

