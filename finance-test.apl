#! /usr/local/bin/apl --script
⍝ Script to run test on the finance workspace
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



)load 1 finance
)copy 1 util
)copy 1 assert

13700 assert∆toScreen '1 util∆round fin∆compoundValue 10000 .065 5'

10000 assert∆toScreen '1 util∆round fin∆presentValue 13701 .065 5'

10000 assert∆toScreen '1 util∆round .065 fin∆netPresentValue (4⍴0),13701'

3590 assert∆toScreen '1 util∆round fin∆compoundAnnuity 250 .065 10'

1800 assert∆toScreen '1 util∆round fin∆presentValueAnnuity 250 .065 10'

250 assert∆toScreen '0 util∆round fin∆annuityPayment 1800 .065 10'

3420 assert∆toScreen '1 util∆round .045 fin∆netPresentValue ¯123400 36200 54800 48100'

¯2750 assert∆toScreen '1 util∆round .065 fin∆netPresentValue ¯10000 1000 1200 ¯5000 1500 1600 2000 1800 1700 1500 1450 1400 1200 1000'

0.02385 assert∆toScreen '¯5 util∆round .065 fin∆irr ¯10000 1000 1200 ¯5000 1500 1600 2000 1800 1700 1500 1450 1400 1200 1000'

0.05962 assert∆toScreen '¯5 util∆round .065 fin∆irr ¯123400 36200 54800 48100'

⍝)off
