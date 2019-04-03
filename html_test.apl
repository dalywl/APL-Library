#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝   $Id: $
⍝ $desc: A test for the xml package.  Creates a set of html 5 tag
⍝ functions and provide html∆fmt_table to create an html page from an
⍝ apl array of rank 2$
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

)load 1 html
)copy 1 xml
)copy 5 FILE_IO

∇page←h1 html∆fmt_table table;noAttr;numberAttr;styleAttr;css;cellAttr;cellType;table;body;rt;nx
  ⍝ Function to format an array as an html page
  ⍝ Create attributes for tags
  noAttr←lex∆init
  numberAttr←noAttr lex∆assign 'class' 'number'
  styleAttr←noAttr lex∆assign 'type' 'text/css'
  ⍝ create a cascading style sheet
  css←'.number { text-align: right;}'
  ⍝ Assemble a list of cell attributes for the array
  cellType←,⊃∧⌿util∆numberp ¨ 1 0↓table
  cellAttr←(⍴cellType)⍴⊂noAttr
  cellAttr[cellType/⍳⍴cellType]←⊂numberAttr
  ⍝ Make all cells text
  rt←⍴table
  nx←(,⊃util∆numberp ¨ table)/⍳⍴table←,table
  table[nx]←⍕¨table[nx]
  table←rt⍴table
  ⍝ Assemble the page head
  page←html∆head (html∆title h1),styleAttr html∆style css
  ⍝ Add the body of the page
  table← html∆table ∊ html∆tr ¨ ⊂[2]((⍴table)⍴cellAttr) html∆td ¨ table
  body←html∆body (html∆h1 h1), table
  page←page,body
  ⍝ Complete the page
  page←html∆html page
∇

∇t←util∆numberp v
  ⍝ Fns returns true if its argument is numeric.
  ⍎(1<≡v)/'t←0◊→0'
  t←0=1↑0⍴v
∇

∇fname write_file txt;fh
  ⍝ Function to write a text file from text
  fh←'w' FIO∆fopen fname
  (⎕ucs txt) FIO∆fwrite fh
  FIO∆fclose fh
∇

(⊂'html') xml∆MkTagFns ¨ html5∆tagList
(⊂'html') xml∆MkClosedTagFns ¨ html5∆closedTagList

Sch_revenue←5 9⍴0 ⍝ prolog ≡1
  (,Sch_revenue)[⍳16]←00 00 00 00 00 00 00 00 00 00 450 00 75 33750 125 56250
  (,Sch_revenue)[16+⍳14]←175 78750 00 6000 00 3 18000 5 30000 5 30000 00 00 00
  (,Sch_revenue)[30+⍳15]←00 63000 00 0 00 0 00 00 00 00 10000 00 10000 00 10000
    ((⎕IO+(⊂0 0))⊃Sch_revenue)←'Desc'
    ((⎕IO+(⊂0 1))⊃Sch_revenue)←'Each'
    ((⎕IO+(⊂0 2))⊃Sch_revenue)←'Unit'
    ((⎕IO+(⊂0 3))⊃Sch_revenue)←'Count 16'
    ((⎕IO+(⊂0 4))⊃Sch_revenue)←'Amt 16'
    ((⎕IO+(⊂0 5))⊃Sch_revenue)←'Count 17'
    ((⎕IO+(⊂0 6))⊃Sch_revenue)←'Amt 17'
    ((⎕IO+(⊂0 7))⊃Sch_revenue)←'Count 18'
    ((⎕IO+(⊂0 8))⊃Sch_revenue)←'Amt 18'
    ((⎕IO+(⊂1 0))⊃Sch_revenue)←'Membership'
    ((⎕IO+(⊂1 2))⊃Sch_revenue)←'Members'
    ((⎕IO+(⊂2 0))⊃Sch_revenue)←'Rent'
  ((⎕IO+(⊂2 2))⊃Sch_revenue)←0⍴((⎕IO+(⊂2 2))⊃Sch_revenue)
    ((⎕IO+(⊂3 0))⊃Sch_revenue)←'Start up Grants'
  ((⎕IO+(⊂3 1))⊃Sch_revenue)←0⍴((⎕IO+(⊂3 1))⊃Sch_revenue)
  ((⎕IO+(⊂3 2))⊃Sch_revenue)←0⍴((⎕IO+(⊂3 2))⊃Sch_revenue)
  ((⎕IO+(⊂3 3))⊃Sch_revenue)←0⍴((⎕IO+(⊂3 3))⊃Sch_revenue)
  ((⎕IO+(⊂3 5))⊃Sch_revenue)←0⍴((⎕IO+(⊂3 5))⊃Sch_revenue)
  ((⎕IO+(⊂3 7))⊃Sch_revenue)←0⍴((⎕IO+(⊂3 7))⊃Sch_revenue)
    ((⎕IO+(⊂4 0))⊃Sch_revenue)←'Contributions'
  ((⎕IO+(⊂4 1))⊃Sch_revenue)←0⍴((⎕IO+(⊂4 1))⊃Sch_revenue)
  ((⎕IO+(⊂4 2))⊃Sch_revenue)←0⍴((⎕IO+(⊂4 2))⊃Sch_revenue)
  ((⎕IO+(⊂4 3))⊃Sch_revenue)←0⍴((⎕IO+(⊂4 3))⊃Sch_revenue)
  ((⎕IO+(⊂4 5))⊃Sch_revenue)←0⍴((⎕IO+(⊂4 5))⊃Sch_revenue)
((⎕IO+(⊂4 7))⊃Sch_revenue)←0⍴((⎕IO+(⊂4 7))⊃Sch_revenue)

fname←(⊃(⎕env 'HOME')[1;2]),'/test.html'

fname write_file 'HTML test page' html∆fmt_table Sch_revenue

⍞←fname,' written to disk.  Load into your favorite browser.'

⍝)off
