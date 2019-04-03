#! /usr/local/bin/apl --script
 ⍝ ********************************************************************
 ⍝   $Id: $
 ⍝ $desc: $ Work space to implement a lexicon using a simple modulus
 ⍝ prime number hashing algorithm.
 ⍝ ********************************************************************
⍝ Copyright (C) 2016 Bill Daly

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


)copy 1 utl

∇h←p lex1∆hashPrime key
 ⍝ Hasing function using modulus of a prime
 h←''⍴⎕io+p|+/⎕ucs key
∇

∇h1←hash lex1∆assign item;ix;bucket
 ⍝ Function to add or replace a name--value pair in a hash based on primes.
 k←(1↑⍴hash) lex1∆hashPrime ⊃item[1]
 h1←hash
 →(0=≡hash[k;1])/new
 →(0≠⍴ix←(⊃h1[k;1]) utl∆stringSearch ⊃item[1])/replace
 append:				⍝ A collision
 h1[k;1]←⊂(⊃h1[k;1]),item[1]
 h1[k;2]←⊂(⊃h1[k;2]),item[2]
 →0
 replace:			⍝ Replace an existing value
 (⊃h1[k;2])[''⍴ix]←item[2]
 →0
 new:				⍝ an empty bucket
 h1[k;1]←⊂,item[1]
 h1[k;2]←⊂,item[2]
 →0
∇

 ∇dist← lex1∆distribution hash
  ⍝ Function returns the distribution of keys accross a lex1 hash table.
  dist←∊ lex1∆itemCount¨hash[;1]
∇

∇count←lex1∆itemCount bucket
   ⍝ Functions returns distribution of keys in a hash bucket. 
   count←¯1↑0,⍴bucket
∇

∇bv←hash lex1∆hasKey key;keys;rl;rk
 ⍝ Function returns true if hash has this key.
 rl←⍴keys←lex1∆keys hash
 rl[2]←rk←rl[2]⌈⍴key
 bv←∨/(rl↑keys)∧.=rk↑key
∇

∇h←lex1∆init p
 ⍝ Function to initialize a prime based hash array
 h←(p,2)⍴⊃,''
∇

∇b←lex1∆is hash;k
  ⍝ Predicate for a prime based hash table
  →(~b←''⍴∧/(2=⍴⍴hash),(2=¯1↑⍴hash))/0
  →(b←''⍴0=1↑⍴k←lex1∆keys hash)/0
  b←''⍴0≠⍴⍴hash lex1∆lookup utl∆trim k[?1↑⍴k;]
∇

∇keys←lex1∆keys hash
 ⍝ Function returns a list of the keys in hash
 keys←⊃,⊃,hash[;1]
 keys←(~∧/keys=' ')⌿keys
∇

∇value←hash lex1∆lookup key;k
 ⍝ Function to return a key's value from a prime based hash
 k←(1↑⍴hash) lex1∆hashPrime key
 →(0=≡hash[k;1])/none
 value←⊃(⊃hash[k;2])[''⍴(⊃hash[k;1]) utl∆stringSearch key]
 →0
 none:
 value←''
 →0
∇

∇values←lex1∆values hash
   ⍝ Function returns a list of values from hash
   values←(⊂hash) lex1∆lookup ¨utl∆trim ¨ ⊂[2]lex1∆keys hash
∇

∇Z←lex1⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'lex1.txt'
  Z←Z⍪'Download'        'https://sourceforge.net/p/apl-library/code/ci/master/tree/lex1.apl'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L1'
  Z←Z⍪'Provides'        ''
  Z←Z⍪'Requires'        'utl'
  Z←Z⍪'Version'                  '0 1 2'
  Z←Z⍪'Last update'         '2019-02-11'
∇
