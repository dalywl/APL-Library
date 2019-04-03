#! /usr/local/bin/apl --script --noColor
 ⍝ ********************************************************************
 ⍝   $Id: $
 ⍝ $desc: Script to test the date workspace $
 ⍝ ********************************************************************

⍝ date_test - Routines to test the date workspaces

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

)copy 1 date
)copy 1 assert
)copy 1 lex

⎕ts[⍳3] assert∆toScreen 'date∆unlillian date∆lillian ⎕ts'

1 assert∆toScreen 'date∆lillian 1582 10 15'

1582 10 15 assert∆toScreen 'date∆unlillian 1'

1 36526 73050 109574 146098 182623 assert∆toScreen 'date∆lillian ¨⊂[2](1482+100×⍳6), 6 2⍴10 15'

36525 36524 36524 36524 36525 assert∆toScreen '(date∆lillian ¨1↓tst)-date∆lillian ¨¯1↓tst←⊂[2](1482+100×⍳6), 6 2⍴10 15'
(⊂[2](1482+100×⍳6),6 2⍴10 15) assert∆toScreen 'date∆unlillian ¨+\1 36525 36524 36524 36524 36525'

1 1 1 1 assert∆toScreen '(date∆lillian¨1↓tst)-date∆lillian¨¯1↓tst←⊂[2]5 3 ⍴ 1999 12 29 1999 12 30 1999 12 31 2000 1 1 2000 1 2'

tst assert∆toScreen 'date∆unlillian¨date∆lillian¨tst'

1 1 1 1 assert∆toScreen '(date∆lillian¨1↓tst)-date∆lillian¨¯1↓tst←⊂[2]5 3 ⍴ 1982 10 12 1982 10 13 1982 10 14 1982 10 15 1982 10 16'

tst assert∆toScreen 'date∆unlillian¨date∆lillian¨tst'

(+\114, 25⍴ +/366,3⍴365) assert∆toScreen 'date∆lillian ¨⊂[2](1583+4×¯1+⍳26),26 2⍴2 5'

(⊂[2](1583+4×¯1+⍳26),26 2⍴2 5) assert∆toScreen 'date∆unlillian ¨ +\114, 25⍴ +/366,3⍴365'

2012 1 15 assert∆toScreen 'date∆US date∆parse ''January 15, 2012'''

2012 1 15 assert∆toScreen 'date∆US date∆parse ''15 JAN 2012'''

2012 1 15 assert∆toScreen 'date∆US date∆parse ''JAN 15 2012'''

2012 1 15 assert∆toScreen 'date∆US date∆parse ''01/15/2012'''

⍝ Just to show off
36557 73081 109605 146129 182654 assert∆toScreen 'date∆lillian ¨ (⊂date∆US) date∆parse ¨ ⊂[2]''06/06/0000''⍕ (5 2 ⍴ 11 15),1582+100×⍳5'

⍝)off
