#! /usr/local/bin/apl --script
 ⍝ ********************************************************************
 ⍝   $Id: $
 ⍝ $desc: Routines to maintain a collection of sequences $
⍝ ********************************************************************
⍝ Copyright (C) 2017 2018 Bill Daly

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
)copy 1 lex

∇item←seq∆next key
  ⍝ Function returns the next integer in a sequence
  ⍎(2≠⎕nc'seq∆items')/'seq∆items←lex∆init'
  →(seq∆items lex∆haskey key)/existing
  seq∆items←seq∆items lex∆assign (⊂key),⊂ item←1
  →0
  existing:
  item←1 + seq∆items lex∆lookup key
  seq∆items←seq∆items lex∆assign key item
  →0
∇

∇key seq∆set value
  ⍝ Funct to set the vale of a sequence
  ⎕es (~utl∆numberp value←''⍴value)/'VALUE NOT A NUMBER'
  ⍎(2≠⎕nc'seq∆items')/'seq∆items←lex∆init'
  seq∆items←seq∆items lex∆assign key value
∇

∇ref←mask seq∆posting∆ref item
  ⍝ Function returns a string of the sequence key and the next
  ⍝ number. Right argument, mask is the right argument for ⍕
  ⍎(2≠⎕nc 'mask')/'mask←''0000'''
  ref←item,mask ⍕ seq∆next item
∇

∇Z←seq⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'comments in file'
  Z←Z⍪'Download'        'https://sourceforge.net/projects/apl-library'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L1'
  Z←Z⍪'Provides'        'Management of sequences'
  Z←Z⍪'Requires'        'utl lex'
  Z←Z⍪'Version'                  '0 1 2'
  Z←Z⍪'Last update'         '2019-02-11'
∇

