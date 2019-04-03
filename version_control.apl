#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ version_control Workspace to manage (ie increment) workspace versions.
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

ver∆DESCRIBE←⎕inp 'eod'
version_control is a workspace to update the ⍙meta function to show
the correct version and its date.

Usage:
      )load version_control
      (level ver∆new '/path/to/workspace') utf8∆write '/path/to/workspace'

level is 1 2 or 3:
  - 1: Major version
  - 2: Minor version
  - 3: Patch version
eod

)copy 1 utl
)copy 1 utf8
)copy 1 lex

∇loc←ver∆location src;loc2;v
⍝ Function returns the number of characters to take, drop for the
⍝ version string.
  loc←'''Version'' *''\d* \d* \d*''' ⎕re['↓'] src
  v← loc[2]↑loc[1]↓src
  loc2←'''Version'' *' ⎕re['↓'] v
  loc←loc + loc2[2],-loc2[2]
∇

∇rev←loc ver∆versionNo src;vstring
  ⍝ Function returns the version number, a vector of major, minor, and
  ⍝ pathc levels.
  ⍎(2≠⎕nc'loc')/'loc←ver∆location src'
  vstring←loc[2]↑loc[1]↓src
  loc←1 ¯2+'''\d* \d* \d*''' ⎕re['↓'] vstring
  rev←⍎loc[2]↑loc[1]↓vstring
∇

∇rev← ver∆inc∆minor org
  ⍝ Function returns the version number at a new minor level
  utl∆es (~utl∆numberp org)/'VERSIONS ARE THREE NUMBERS: MAJOR, MINOR, PATCH'
  utl∆es (3≠⍴org←,org)/'SUPPLY THE MAJOR, MINOR AND PATCH NUMBERS.'
  rev←( 0 1 + 2↑org),0
∇

∇rev← ver∆inc∆major org
  ⍝ Function returns the version number for a new major level
  utl∆es (~utl∆numberp org)/'VERSIONS ARE THREE NUMBERS: MAJOR, MINOR, PATCH'
  utl∆es (3≠⍴org←,org)/'SUPPLY THE MAJOR, MINOR AND PATCH NUMBERS.'
  rev←(1 + 1↑org),0 0
∇

∇rev← ver∆inc∆patch org
  ⍝ Function returns the version number for a new patch level
  utl∆es (~utl∆numberp org)/'VERSIONS ARE THREE NUMBERS: MAJOR, MINOR, PATCH'
  utl∆es (3≠⍴org←,org)/'SUPPLY THE MAJOR, MINOR AND PATCH NUMBERS.'
  rev←0 0 1 + org
∇

∇loc←ver∆dateLocation src;loc2
  ⍝ Function returns the number of characters to take and drop for the
  ⍝ date string in ⍙metadata
  loc←'''Last update'' *''\d{4}-\d{2}-\d{2}''' ⎕re['↓'] src
  loc2←'''Last update'' *' ⎕re['↓'] loc[1]↓src
  loc←loc + loc2[2],-loc2[2]
∇
  

∇ws_txt←level ver∆new fname;src;loc;vno;parsed;dateLoc;date
  ⍝ Function returns a modified source of a workspace with a new patch
  ⍝ level: 1 - Major, 2 - Minor, 3 - Patch.
  src←utf8∆read fname
  loc←ver∆location src
  vno←loc ver∆versionNo src
  dateLoc←ver∆dateLocation src
  date←'0006-06-06'⍕⎕ts[⍳3]
  →(mjr,mnr,ptc)[1⌈3⌊level]
mjr: vno←ver∆inc∆major vno
  →end
mnr: vno←ver∆inc∆minor vno
  →end
ptc:vno←ver∆inc∆patch vno
  →end
end:
  parsed←utl∆fileName∆parse fname
  ⍝ver∆files←ver∆files lex∆assign (⊂'.' utl∆join parsed[2 3]),⊂vno←⍕vno
  ⍝ The last update is the last line of ⍙metadata
  ws_txt←(dateLoc[1]↑src),(5⍴' '),'''',date,'''',(+/dateLoc)↓src
  ws_txt←(loc[1]↑ws_txt),(9⍴' '),'''',(⍕vno),'''',(+/loc)↓ws_txt
∇

∇ws_txt←ver∆pointPointRev src;point;d1;d2
  ⍝ Function increments the point rev of a workspace, returning the
  ⍝ revised source code from the given source code.
  d1←'''Version'' *''\d* \d* \d*''' ⎕re['↓'] src
  v←d1[2]↑d1[1]↓src
  d2←'''\d* \d* \d*''' ⎕re['↓'] v
  point←⍕0 0 1 + ⍎ (d2[2]-2)↑(d2[1]+1)↓v
  v←(d2[1]↑v),point,''''
  ws_txt←(d1[1]↑src),v,(+/d1)↓src
∇

∇ws_txt←ver∆pointRev src;point;d1;d2p;v
  ⍝ Function increments the point -- point rev of a workspace
  ⍝ returning athe revised source code, given the source code.
  d1←'''Version'' *''\d* \d* \d*''' ⎕re['↓'] src
  v←d1[2]↑d1[1]↓src
  d2←'''\d* \d* \d*''' ⎕re['↓'] v
  point←⍕0 1 0 + ⍎ (d2[2]-2)↑(d2[1]+1)↓v
  v←(d2[1]↑v),point,''''
  ws_txt←(d1[1]↑src),v,(+/d1)↓src
∇


∇Z←ver⍙metadata                                   
  Z←0 2⍴⍬                                             
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'                      
  Z←Z⍪'Documentation'   ''                            
  Z←Z⍪'Download'        'https://sourceforgge.net/projects/apl-library/'
  Z←Z⍪'License'         'GPL version 3'
  Z←Z⍪'Portability'     'L3'
  Z←Z⍪'Provides'        'Tracks and updates workspace versions'             
  Z←Z⍪'Requires'        'utl utf8'
  Z←Z⍪'Version'         '0 1 0'
  Z←Z⍪'Last update'     '2018-10-24'
∇
