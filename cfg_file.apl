#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ config Routines to parse a configuration file
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

⍝ ********************************************************************

)copy 1 lex
)copy 1 utl
)copy 1 utf8

∇ secs←old_key cfg∆section∆find txt;pos;new_key;value
  ⍝ Function returns a nested array of configuration file sections
  →(0=⍴pos←'\[[^\]]*' ⎕re['↓'] txt)/none
  value←2↓pos[1]↑txt
  pos←1 ¯1 + pos
  new_key←pos[2]↑pos[1]↓txt
  →(pass1,pass2)[1+2=⎕nc 'old_key']
pass1:
  secs←new_key cfg∆section∆find (+/pos)↓txt
  →0
pass2:
  value←cfg∆section∆parse value
  secs←(new_key cfg∆section∆find (+/pos)↓txt)lex∆assign old_key value
  →0
none:
  value←cfg∆section∆parse 2↓txt
  secs←(lex∆init)lex∆assign old_key value
  →0
∇

∇sec←cfg∆section∆parse txt;t1;alist;bv;b2
  ⍝ Funtion to parse a section of a config file.
  bv←txt=⎕tc[3]
  txt←(b2←~⌽∧\⌽bv)/txt
  bv←b2/bv
  txt[bv/⍳⍴txt]←'='
  t1←'=' utl∆split txt
  alist←cfg∆clean ¨ t1
  sec←lex∆from_alist alist
∇

∇dt←cmt cfg∆rm∆comments txt;pos
  ⍝ Function to remove comments from the text of a file
  ⍎(3≠⎕nc 'cmt')/'cmt←'';'''
  dt←''
st:
   →(0=⍴txt)/ed
  →(0=⍴pos←(cmt,'.*',⎕tc[3]) ⎕re['↓'] txt)/ed
  dt←(pos[1]↑txt),dt
  txt←(+/pos)↓txt
  →st
ed:
  dt←dt,txt
  →0
∇

∇t1←cfg∆rm∆cr txt
  ⍝ Function to remove carriage returns from DOS text.
t1←(∼(⎕tc[2]=txt)∧1⌽⎕tc[3]=txt)/txt
∇

∇t1←cfg∆clean txt
  ⍝ Admended utl∆clean which also removes surrounding quotes.
  txt[(txt∊⎕tc,⎕av[10])/⍳⍴txt←,txt]←' '
   txt←(~(1⌽b)∧b←txt=' ')/txt
   t1←(txt[1]=' ')↓(-txt[⍴txt]=' ')↓txt
  →(~(t1[1]=t1[⍴t1])∧t1[1]∊'"''')/0
  t1←1↓¯1↓t1
∇

∇lx←cfg∆parse_file name;t1
  ⍝ Function to parse a configuration file. Function returns a lexicon
  ⍝ of lexicons.
  t1←utf8∆read name
  t1←cfg∆rm∆comments cfg∆rm∆cr t1
  lx←cfg∆section∆find t1
∇

∇Z←cfg⍙metadata
Z←0 2⍴⍬
Z←Z⍪'Author'          'Bill Daly'
Z←Z⍪'BugEmail'        'bugs@dalywebandedit'
Z←Z⍪'Documentation'   'apl-library.info'
Z←Z⍪'Download'        'https://sourceforge.net/projects/apl-library'
Z←Z⍪'License'         'GPL v3'
Z←Z⍪'Portability'     'L3'
Z←Z⍪'Provides'        ''
Z←Z⍪'Requires'        'utl lex utf8'
Z←Z⍪'Version'         '0 0 1'
∇
