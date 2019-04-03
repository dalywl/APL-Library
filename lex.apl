#!/usr/local/bin/apl --script

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝
⍝ lex 2016-08-29 15:55:56 (GMT-5)
⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Copyright (C) 2016  Bill Daly

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

∇nx←lx lex∆assign item;ix;keys;keyShape
  ⍝ Function to assign a value to a key where larg is the lexicon and
  ⍝ rarg is a key value pair. Pair will be added if the key is not in
  ⍝ the lexicon.
  nx←lx
  →(' '≠1↑0⍴⊃item[1])/err
  ⍝ Test for empty lexicon
  →(0=1↑⍴nx)/add			
  keyShape←⍴keys←⊃nx[;1]
  ix←(keys∧.=keyShape[2]↑⊃item[1])/⍳keyShape[1]
  →(0=⍴ix)/add
replace:
  nx[ix;2]←item[2]
  →0
add:
  nx←nx,[1]item
  →0
err:
  ⍞←'Lexicon entries must use a character string as a key'
  →0
∇

∇new←lex lex∆drop key;rlex;tbl
  ⍝ Function to drop a key value pair
  ⍎(0=1↑⍴lex)/'new←lex◊→0'
  rlex←(⍴tbl←⊃lex[;1])⌈0,⍴key←,key
  new←(~(rlex↑tbl)∧.=rlex[2]↑key)⌿lex
∇

∇bool←lex lex∆haskey key;rkey;keys
  ⍝ Function searches for key in lexicon lex and returns true if found.
  ⍎(0=1↑rkey←⍴keys←⊃lex[;1])/'bool←0◊→0'
  rkey[2]←rkey[2]⌈⍴key←,key
  bool←∨/(rkey↑keys)∧.=rkey[2]↑,key
∇

∇lex←lex∆init
  ⍝ Function to initiate a lexicon
  lex←0 2⍴''
∇

∇b←lex∆is lex
  ⍝ Predicate returns true if argument is in fact a lexicon
  ⍎(2≠⍴⍴lex)/'b←0◊→0'
  ⍎(∧/0 2=⍴lex)/'b←1◊→0'
  ⍎(2>≡lex)/'b←0◊→0'
  b←∧/' '=1↑0⍴⊃lex[;1]
∇

∇b←lex∆isempty lex
  ⍝ Predicate returns true is the lexicon has no entries
  b←∧/0 2=⍴lex
∇

∇keys←lex∆keys lx
  ⍝ Function returns a list of keys in a lexicon
  keys←lx[;1]
∇

∇value←lex lex∆lookup key;keyShape;keys;ix
  ⍝ Function returns the value of key in a lexicon
  keyShape←¯2↑0 0,⍴keys←⊃lex[;1]
  ⍎(0=ix←''⍴(keys∧.=keyShape[2]↑key)/⍳keyShape[1])/'value←''''◊→0'
  value←⊃lex[ix;2]
∇

∇vals←lex∆values lx
  ⍝ returns the valus in a lexicon
  vals←lx[;2]
∇

∇new←lex lex∆from_alist list
  ⍝ Function to generate a lexicon from a list
  ⎕es (0≠2|⍴list←,list)/'List must consist of name-value pairs.'
  →(2=⎕nc 'lex')/recursion
  lex←lex∆init
recursion:
  new←lex
  →(0=⍴list←,list)/0
  new← (new lex∆assign 2↑list←,list) lex∆from_alist 2↓list
∇

∇Z←lex⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'lex.txt'
  Z←Z⍪'Download'        'https://sourceforge.net/p/apl-library/code/ci/master/tree/lex.apl'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L1'
  Z←Z⍪'Provides'        ''
  Z←Z⍪'Requires'        ''
  Z←Z⍪'Version'                  '0 1 1'
  Z←Z⍪'Last update'         '2018-11-23'
∇
