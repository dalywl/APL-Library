#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ ex-im-test.apl Workspace to test export.apl and import.apl
⍝ Copyright (C) 2019 Bill Daly

⍝ This program is free software: you can redistribute it and/or modify
⍝ it under the terms of the GNU General Public License as published by
⍝ the Free Software Foundation, either version 3 of the License, or
⍝ (at your option) any later version.

⍝ This program is distributed in the hope that it will be useful,
⍝ but WITHOUT ANY WARRANTY; without even the implied warranty of
⍝ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
⍝ GNU General Public License for more details.

⍝ You should have received a copy of the GNU General Public License
⍝ along with this program.  If not, see <http://www.gnu.org/licenses/>.

⍝ ********************************************************************

)copy 1 import
)copy 1 export
)copy 1 prompt
)copy 1 assert

∇ dir←exim∆getDir
  ⍝ Function to ask the testor for the location of the test-data
  dir←prompt 'Enter location of the test data: '
  ⍎(utl∆numberp dir)/'dir←''No location supplied'''
  ⍎('/'≠¯1↑dir)/'dir←dir,''/'''
∇

∇b←exim∆fileExists fname;list;parsed
  ⍝ Function  to prove a file has been created.
  parsed←utl∆fileName∆parse fname
  list←FIO∆read_directory 1⊃parsed
  b←(1↑⍴list)≥list[;5] utl∆listSearch '.' utl∆join 1↓parsed
∇

∇rs←exim∆fileRm fname;ph
  ⍝ Function to remove files
  ph←'r' FIO∆popen 'rm ',fname
  rs←FIO∆fread ph
  rs←FIO∆pclose ph
∇



assert∆setup 'exim∆prefix←exim∆getDir'

251 3 assert∆toScreen '⍴test01← import∆table import∆file exim∆prefix,''examplle_tb.txt'''

⍞←test01
⍞←⎕tc[3]

'exim∆fileExists ''/tmp/eximtest01.txt''' assert∆nil∆toScreen '(⊂[2]test01) export∆nested ''/tmp/eximtest01.txt'''


569 18 assert∆toScreen '⍴test02← import∆table import∆file exim∆prefix,''2019_DOE_mpg.csv'''

⍞←test02[⍳10;]
⍞←⎕tc[3]

'exim∆fileExists ''/tmp/eximtest02.txt''' assert∆nil∆toScreen '(⊂[2]test02) export∆nested ''/tmp/eximtest02.txt'''

⎕dl 5

assert∆cleanUp 'exim∆fileRm ''/tmp/eximtest01.txt''' 'exim∆fileRm ''/tmp/eximtest02.txt'''


⍝)off
