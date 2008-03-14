External.exe
============

External.exe is a program which allows an external text editor to
be run from any application using a single keystroke.

web: http://bur.st/~benc/?p=external

Installation and Configuration
==============================

After downloading and unzipping external.zip put external.exe and
external.ini in a directory together.

Open external.ini in a text editor and set the options "Editor"
and "EditorBinding" as explained in the comments in the file.

The program can be started by manually running the external.exe
command. But once you get a configuration you like you may want to
place a shortcut in your Start/Programs/Startup folder so it will
be automatically executed.

Tip: When configuring external.exe it can be useful to use the
Restart (Shift-Ctrl-Alt-R) and Exit (Shift-Ctrl-Alt-X) bindings to
reconfigure your program.


Usage
=====

To use the program, once it is configured and running, move the
cursor to the text area of an application and type your EditorBinding
keystroke (Windows-V, for example)


Filetypes in Vim
================

Also provided with the program is a vim script "external.vim". This
file can be installed by putting it in your vim plugin folder. With
an appropriately configured Editor option in external.ini vim will
be able to recognise the filetype of the text you are editing by
using the application window title as a clue.

external.vim has only been tested on a small number of applications
and filetypes, but it should be relatively easy to add new filetypes
by modifying the External() function in the script.

==
Author: Ben Collerson <benc at bur dot st>
Last Modified: 22 Jan 2005
Version: 0.1
Licence: This program is free software; you can redistribute it and/or
         modify it under the terms of the GNU General Public License.
         See http://www.gnu.org/copyleft/gpl.txt
Copyleft 2005 Ben Collerson <benc at bur dot st>
