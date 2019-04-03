#! /usr/local/bin/apl --script
⍝ export, functions to export data.
⍝ Copyright (C) 2018 Bill Daly

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


)copy 5 FILE_IO

∇nested export∆nested fname
  ⍝ Function to export a nested array of two levels to a tab delimited
  ⍝ text file.
  (⎕av[10] utl∆join ¨ {⍕¨⍵}¨ nested) FIO∆write_lines fname
∇

∇array export∆array fname
  ⍝ Function to export an arry of rank two to a tab delimited file.
  (⊂[2]array) export∆nested fname
∇

∇Z←export⍙metadata
  Z←0 2⍴⍬                                             
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'                      
  Z←Z⍪'Documentation'   'Comments in file.'                            
  Z←Z⍪'Download'        'https://sourceforge.net/projects/apl-library/'
  Z←Z⍪'License'         'GPL verion 3'                            
  Z←Z⍪'Portability'     'L2'
  Z←Z⍪'Provides'        'Function to write an rank 2 array to disk.'
  Z←Z⍪'Requires'        'FILE_IO'
  Z←Z⍪'Version'                  '0 1 1'
  Z←Z⍪'Last update'         '2018-11-23'
∇
