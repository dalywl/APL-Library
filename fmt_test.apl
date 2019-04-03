#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ fmt_test.apl Unit testing of fmt workspaces
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

)copy 1 fmt
)copy 1 assert
)copy 1 import

assert∆setup 'inv←import∆file ''test-data/inv.txt'''

tmask_float01←'N⍞ Cr⍞Q⍞ Dr⍞F14.2'

'    1234.00 Dr' assert∆toScreen 'tmask_float01 fmt 1234'
'    1234.00 Cr' assert∆toScreen 'tmask_float01 fmt ¯1234'
'       0.00 Dr' assert∆toScreen 'tmask_float01 fmt 0'
'**************' assert∆toScreen 'tmask_float01 fmt 1.5E9'

tmask_float02←'N⍞ Cr⍞Q⍞ Dr⍞CF14.2'
'   1,234.00 Dr' assert∆toScreen 'tmask_float02 fmt 1234'
'   1,234.00 Cr' assert∆toScreen 'tmask_float02 fmt ¯1234'

tmask_float03←'M⍞(⍞N⍞)⍞F10.3'

' 1234.000 ' assert∆toScreen 'tmask_float03 fmt 1234'
'(1234.000)' assert∆toScreen 'tmask_float03 fmt ¯1234'

tmask_float04←'M⍞(⍞N⍞)⍞CF10.3'

'1,234.000 ' assert∆toScreen 'tmask_float04 fmt 1234'
'**********' assert∆toScreen 'tmask_float04 fmt ¯1234'

tmask_int01←'N⍞ Cr⍞Q⍞ Dr⍞I12'

'     1234 Dr' assert∆toScreen 'tmask_int01 fmt 1234'
'     1234 Cr' assert∆toScreen 'tmask_int01 fmt ¯1234'

tmask_int02←'N⍞ Cr⍞Q⍞ Dr⍞CI10'
'  1,234 Dr' assert∆toScreen 'tmask_int02 fmt 1234'
'  1,234 Cr' assert∆toScreen 'tmask_int02 fmt ¯1234'

tmask_int03←'M⍞(⍞N⍞)⍞I10'
'     1234 ' assert∆toScreen 'tmask_int03 fmt 1234'
'    (1234)' assert∆toScreen 'tmask_int03 fmt ¯1234'


tmask_int04←'M⍞(⍞N⍞)⍞CI10'
'    1,234 ' assert∆toScreen 'tmask_int04 fmt 1234'
'   (1,234)' assert∆toScreen 'tmask_int04 fmt ¯1234'

⍝ test test delimiters
tmask_float05←'N/ Cr/Q/ Dr/F14.2'
'    1234.00 Dr' assert∆toScreen 'tmask_float05 fmt 1234'
'    1234.00 Cr' assert∆toScreen 'tmask_float05 fmt ¯1234'

'12345678.00 Dr' assert∆toScreen 'tmask_float05 fmt 12345678'
'12345678.00 Cr' assert∆toScreen 'tmask_float05 fmt ¯12345678'

tmask_float06←'N/ Cr/Q/ Dr/CF14.2'

'  12,345.00 Dr' assert∆toScreen 'tmask_float06 fmt 12345'
'  12,345.00 Cr' assert∆toScreen 'tmask_float06 fmt ¯12345'

tmask_float07←'M/(/N/)/F10.3'
' 1234.000 ' assert∆toScreen 'tmask_float07 fmt 1234'
'(1234.000)' assert∆toScreen 'tmask_float07 fmt ¯1234'

tmask_float08←'M/(/N/)/CF13.3'
' 123,456.000 ' assert∆toScreen 'tmask_float08 fmt 123456'
'(123,456.000)' assert∆toScreen 'tmask_float08 fmt ¯123456'

⍝ test scaling of output
tmask_float11←'M/(/N/)%/Q/%/K2F14.2'
'       12.35% ' assert∆toScreen 'tmask_float11 fmt .123456'
'      (12.35)%' assert∆toScreen 'tmask_float11 fmt ¯.123456'

tmask_float12←'M/(/N/)%/Q/%/CK2F14.2'
'       12.35% ' assert∆toScreen 'tmask_float12 fmt .123456'
'      (12.35)%' assert∆toScreen 'tmask_float12 fmt ¯.123456'

tmask_zeros←'ZM/(/N/)/CF14.2'
'0000001234.00 ' assert∆toScreen 'tmask_zeros fmt 1234'
'(000001234.00)' assert∆toScreen 'tmask_zeros fmt ¯1234'

tmask_exp01←'M/(/N/)/E10.4'
'  1.234E3 ' assert∆toScreen 'tmask_exp01 fmt 1234'
' (1.234E3)' assert∆toScreen 'tmask_exp01 fmt ¯1234'
'  1.000E0 ' assert∆toScreen 'tmask_exp01 fmt 1'
'  0.000E0 ' assert∆toScreen 'tmask_exp01 fmt 0'

tmask_exp02←'M/-/E6.4'
'******' assert∆toScreen 'tmask_exp02 fmt 12345'

tmask_blank01←'BCM<(>N<)>F14.2'
(14⍴' ') assert∆toScreen 'tmask_blank01 fmt 0'
'   (98,765.00)' assert∆toScreen 'tmask_blank01 fmt ¯98765'

tmask_info01←'P<To prove Info assertion >F35.2,F9.2'
'  To prove Info assertion 101000.00999750.00'assert∆toScreen 'tmask_info01 fmt 101000 999750'

⍞←'Formating a nested array: ',⎕tc[3]
'A5,A25,K2Q⍞%⍞F6.2,M⍞(⍞N⍞)⍞CF14.2' fmt 1 0↓inv[;1 2 5 11]

⍞←⎕tc[3],'Formating a simple array',⎕tc[3]
'38A1,K2Q/%/F6.2,M/(/N/)/CF14.2' fmt 1 0↓((⊃inv[;1]),' ',⊃inv[;2]),inv[;5 11]

⍞←⎕tc[3],'Formating a simple array with repeating formats of numeric columns.',⎕tc[3]
'A6,A25,3M/(/N/)/CF14.2' fmt 1 0↓inv[;1 2 11 12 13]
