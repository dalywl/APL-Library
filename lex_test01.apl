#! /usr/local/bin/apl --script
 ⍝ ********************************************************************
 ⍝   $Id: $
 ⍝ $desc: Script to test lex $
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

)copy 1 lex
)copy 1 assert

⍞←'Assembling a test lexicon',⎕av[11]

(1 2⍴'one' 1) assert∆toScreen  'tst←(lex∆init) lex∆assign ''one'' 1'

(2 2⍴'one' 1 'two' 5332.10) assert∆toScreen 'tst←tst lex∆assign ''two'' 5332.10'

(3 2⍴ 'one' 1 'two' 5332.1 'three' 3) assert∆toScreen 'tst←tst lex∆assign ''three'' 3',⎕av[11] 

⍝'tst←tst lex∆assign 4 ''four''',⎕av[11]


True assert∆toScreen 'lex∆is tst'

False assert∆toScreen 'lex∆is 4 2⍴⍳2×4'

(0⍴0) assert∆toScreen 'lex∆keys lex∆init'

'one' 'two' 'three' assert∆toScreen 'lex∆keys tst'

1 5332.1 3 assert∆toScreen 'lex∆values tst'

1 assert∆toScreen 'tst lex∆lookup ''one'''

5332.1 assert∆toScreen 'tst lex∆lookup ''two'''

3 assert∆toScreen 'tst lex∆lookup ''three'''

(0⍴0) assert∆toScreen '(lex∆init) lex∆lookup ''test'''

True assert∆toScreen 'lex∆isempty lex∆init'

False assert∆toScreen 'lex∆isempty tst'

⍞←'More lex∆is testing',⎕av[11]
False assert∆toScreen 'lex∆is 2 14⍴ ⍳ 28'

True assert∆toScreen 'lex∆is 2 2 ⍴ ''one'' 1 ''two'' 2'

True assert∆toScreen 'lex∆is (lex∆init) lex∆assign ''one'' 1'

True assert∆toScreen 'lex∆is ((lex∆init) lex∆assign ''one'' 1) lex∆assign ''two'' lex∆init'

False assert∆toScreen 'lex∆is '''''


(2 2⍴'two' 5332.1 'three' 3)assert∆toScreen 'tst lex∆drop ''one'''

(2 2⍴ 'one' 1 'three' 3) assert∆toScreen 'tst lex∆drop ''two'''


(2 2⍴'one' 1 'two' 5332.1) assert∆toScreen 'tst lex∆drop ''three'''

(3 2⍴ 'one' 1 'two' 5332.1 'three' 3) assert∆toScreen 'tst lex∆drop ''four'''

(0 2⍴'') assert∆toScreen '(lex∆init) lex∆drop ''four'''

(3 2⍴ 'three' 3 'two' 2 'one' 1) assert∆toScreen 'lex∆from_alist ''one'' 1 ''two'' 2 ''three'' 3'


)off
