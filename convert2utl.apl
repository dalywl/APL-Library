#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ convert2utl.apl gnu-apl script to convert from util workspace to utl.
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
)copy 1 prompt

fns_table←lex∆init
fns_table←fns_table lex∆assign'util∆breakon'		'removed'
fns_table←fns_table lex∆assign'util∆clean'		'utl∆clean'
fns_table←fns_table lex∆assign'util∆concatColumns'	'removed'
fns_table←fns_table lex∆assign'util∆crWithLineNo'	'utl∆crWithLineNo'
fns_table←fns_table lex∆assign'util∆es'			'utl∆es'
fns_table←fns_table lex∆assign'util∆execTime'		'utl∆execTime'
fns_table←fns_table lex∆assign'util∆helpFns'		'utl∆helpFns'
fns_table←fns_table lex∆assign'util∆import∆numbers'	'removed'
fns_table←fns_table lex∆assign'util∆join'		'utl∆join'
fns_table←fns_table lex∆assign'util∆lower'		'utl∆lower'
fns_table←fns_table lex∆assign'util∆member'		'utl∆member'
fns_table←fns_table lex∆assign'util∆numberFromString'	'utl∆convertStringToNumber'
fns_table←fns_table lex∆assign'util∆numberis'		'utl∆numberis'
fns_table←fns_table lex∆assign'util∆numberp'		'utl∆numberp'
fns_table←fns_table lex∆assign'util∆over'		'removed'
fns_table←fns_table lex∆assign'util∆replace'		'utl∆replace'
fns_table←fns_table lex∆assign'util∆round'		'utl∆round'
fns_table←fns_table lex∆assign'util∆search'		'utl∆search'
fns_table←fns_table lex∆assign'util∆split'		'utl∆split'
fns_table←fns_table lex∆assign'util∆split_with_quotes'	'utl∆split_with_quotes'
fns_table←fns_table lex∆assign'util∆stringEquals'	'utl∆stringEquals'
fns_table←fns_table lex∆assign'util∆stringSearch'	'utl∆listSearch'
fns_table←fns_table lex∆assign'util∆stringp'		'utl∆stringp'
fns_table←fns_table lex∆assign'util∆strip'		'utl∆stripArraySpaces'
fns_table←fns_table lex∆assign'util∆strip_quotes'	'utl∆strip_quotes'
fns_table←fns_table lex∆assign'util∆sub'		'util∆sub'
fns_table←fns_table lex∆assign'util∆swq_helper'		'util∆swq_helper'
fns_table←fns_table lex∆assign'util∆today'		'utl∆today'
fns_table←fns_table lex∆assign'util∆trim'		'utl∆stripExtraSpaces'
fns_table←fns_table lex∆assign'util∆upper'		'utl∆upper'



∇new←fns_hash cvt_replace target;l;prefix;keys;pos;fns
  ⍝ Function to replace all the functions defined as keys in fns_hash
  ⍝ with the cooresponding values.
  l←∊⌈/⍴¨keys←lex∆keys fns_hash
  l←∧\(pref←l↑1⊃keys)=l↑2⊃keys
  pref←l/pref
  search←pref,'\w*'
  new←''
st:
  →(0=⍴pos←search ⎕re['↓'] target)/ed
  fns←fns_hash lex∆lookup pos[2]↑pos[1]↓target
  new←new,(pos[1]↑target),fns
  →(0≠⍴target←(+/pos)↓target)/st
  →0
ed:
  new←new,target
  →0
∇



∇fns_hash cvt_file_update fname;src;err;path;rootname;suffix;backup
  ⍝ Function to replace all occurances of the keys of fns_hash with
  ⍝ the related values in the target file.
  backup←utl∆fileName∆backupname utl∆fileName∆parse fname
  '⍞←''Error reading '',fname◊→0' ⎕ea 'src←utf8∆read fname'
  utl∆es (0≠src utf8∆write backup)/'ERROR BACKING UP ',fname
  src←fns_hash cvt_replace src
  utl∆es (0≠src utf8∆write fname)/'ERROR SAVING ',fname
∇

∇Z←cvt⍙metadata                                 
Z←0 2⍴⍬                                                
Z←Z⍪'Author'          ''                               
Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'                         
Z←Z⍪'Documentation'   ''                               
Z←Z⍪'Download'        'sourceforge.net/projects/apl-library/'   
Z←Z⍪'License'         ''                               
Z←Z⍪'Portability'     ''                               
Z←Z⍪'Provides'        'convert a workspace from util to utl'
Z←Z⍪'Requires'        'lex utl utf8 prompt'                             
Z←Z⍪'Version'         '0 1 0'                               
∇
