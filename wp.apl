#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝   $Id: $
⍝ $desc: Workspace for accountant's workpapers $
⍝ ********************************************************************

⍝ wp.apl, store, print manipulate an accountant's workpapers
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

)copy 1 html

)copy 1 prompt

)copy 1 lex

)copy 1 fmt

)copy 5 FILE_IO FIO∆read_file FIO∆fopen FIO∆write_utf8 FIO∆fclose FIO∆read_directory

∇html←wp∆assemble wp;dat;size;hattr;ibattr;thead;tbody;hhead;attrs
  ⍝ Function to assemble an html page from a workpaper
  size←⍴dat←wp lex∆lookup 'Data'
  ⍝ Asemble table heading
  thead←size wp∆assemble∆head wp
  ⍝ Assemble body
  tbody←wp∆assemble∆body wp
  ⍝ Assemble html head
  hhead←(html∆title wp lex∆lookup 'Title'),html∆style xml∆mkSheet wp lex∆lookup 'Stylesheet'
  hhead←hhead, html∆meta (lex∆init) lex∆assign 'charset' 'UTF8'
  hhead←html∆head hhead
  ⍝ Assemble document
  →(wp lex∆haskey 'Footer')/withFoot
  html←html∆html hhead, html∆body html∆table thead,tbody
  →0
withFoot:
  html←html∆html hhead, html∆body (html∆table thead,tbody),wp∆assemble∆footer wp
  →0
∇

∇thead← size wp∆assemble∆head wp;hattr;ibattr;lrattr
  ⍝ Function to asemble the report heading for wp∆assemble
  hattr←(lex∆init) lex∆assign 'class' 'page-head'
  hattr←hattr lex∆assign (⊂'colspan'),⊂ ⍕size[2]-1
  ibattr←(lex∆init) lex∆assign 'class' 'initial-block'
  lrattr←(lex∆init) lex∆assign 'class' 'last-head'
  thead←⎕av[11],html∆tr (hattr wp∆∆td wp lex∆lookup 'Entity'),ibattr wp∆∆td wp lex∆lookup 'Id'
  thead←thead,⎕av[11],html∆tr (hattr wp∆∆td wp lex∆lookup 'Title'),ibattr wp∆∆td wp lex∆lookup 'Author'
  thead←thead,⎕av[11],lrattr html∆tr (hattr wp∆∆td wp lex∆lookup 'Period'),ibattr wp∆∆td utl∆today
  thead←html∆thead thead
∇

∇txt←wp∆txt∆assemble wp;shape
  ⍝ function returns a workpaper formated as text
  ⍝shape←⍴wp lex∆lookup 'Data'
  txt←(wp∆txt∆assemble∆head wp),wp∆txt∆assemble∆body wp
  →(~wp lex∆haskey 'Footer')/0
  txt←txt,wp∆txt∆assemble∆footer wp
∇

∇ln←w wp∆text∆center txt;indent
  ⍝ Function returns txt centered on width w.  If w is not supplied,
  ⍝ centered on ⎕pw
  →(2=⎕nc 'w')/w_defined
  w←⎕pw
w_defined:
  indent←(⌊(w-⍴txt←,txt)÷2)⍴' '
  ln←indent,txt,indent
∇

∇thead←wp∆txt∆assemble∆head wp;author;today
  ⍝ Function to assemble the text report heading
  thead←(wp∆text∆center wp lex∆lookup 'Entity'),⎕tc[3]
  author←wp lex∆lookup 'Author'
  today←utl∆today
  thead←thead,((-⍴author)↓wp∆text∆center wp lex∆lookup 'Title'),author,⎕tc[3]
  thead←thead,((-⍴today)↓wp∆text∆center wp lex∆lookup 'Period'),today,2⍴⎕tc[3]
∇


∇tbody←wp∆assemble∆body wp;a;f;d
  ⍝ Function to assemble the report body for wp∆assemble
  shape←⍴d ←wp lex∆lookup 'Data'
  a←wp lex∆lookup 'Attributes'
  →(0=⍴f←wp lex∆lookup 'Function')/pr01
  d←⍎'a ',f,' d'
pr01:
  d←,d
  a←,a
  tbody←∊⎕av[11],¨html∆tr ¨ ∊¨ ⊂[2] size⍴ a wp∆∆td ¨ ,d
∇

∇tbody←wp∆txt∆assemble∆body wp;dat;a;ix;f;shape
  ⍝ Function to assemble the body of a text reppr
  shape←⍴dat ←wp lex∆lookup 'Data'
  a←wp lex∆lookup 'Attributes'
  →(0=⍴f←wp lex∆lookup 'Function')/pr01
  dat←⍎'a ',f,' dat'
pr01:
  a←,a
  dat←,dat
  ix←(utl∆numberp ¨ dat)/⍳×/shape
  dat[ix]←a[ix] wp∆∆txtCell ¨ dat[ix]
  tbody←1⌽,⎕tc[3],utl∆concatColumns shape⍴dat
∇

∇tfoot←wp∆assemble∆footer wp
  ⍝ Function to assemble the footer
  tfoot←html∆footer wp lex∆lookup 'Footer'
∇

∇tfoot←wp∆txt∆assemble∆footer wp
  ⍝ Functio to assemble the footer for a text rendering
  tfoot ← (wp∆text∆center wp lex∆lookup 'Footer'),⎕tc[3]
∇

∇txt←wp∆exportTxt wp;shape;data;attr;nix
  ⍝ Function to create a tab delimited text array from a workpaper.
  shape←⍴data←wp lex∆lookup 'Data'
  data←,data
  attr←,wp lex∆lookup 'Attributes'
  nix←({⍵ lex∆haskey 'format'}¨attr)/⍳⍴attr
  data[nix]←({⍵ lex∆lookup 'format'}¨attr[nix])⍕¨data[nix]
  txt←(4 0+shape)⍴⊂' '
  txt[4+⍳shape[1];]←shape⍴data
  txt[1;1 2]←(⊂'Entity:'),⊂ wp lex∆lookup 'Entity'
  txt[2;1 2]←(⊂'Title:'),⊂ wp lex∆lookup 'Title'
  txt[3;1 2]←(⊂'Period:'),⊂ wp lex∆lookup 'Period'
  txt[1;shape[2]-1 0]←(⊂'Id'),⊂ wp lex∆lookup 'Id'
  txt[2;shape[2]-1 0]←(⊂'Author'),⊂ wp lex∆lookup 'Author'
  txt← ⎕av[11] utl∆join ⎕av[10] utl∆join ¨ ⊂[2]txt
∇

∇wp←wp∆importTxt fname;txt;shape;bv;data;meta
  ⍝ Function to import a tab delimted file as a workpaper
  wp←lex∆init
  txt←wp∆readPage fname
  shape←0 0
  shape[1]←+/1,bv←⎕av[11]=txt
  txt[bv/⍳⍴txt]←⎕av[10]
  shape[2]←(⍴ data←⎕av[10] utl∆split txt)÷shape[1]
  data←shape⍴data
  meta←data[⍳4;]
  data←4 0↓data
  ⍝ Assume we're reading an export file we generated
  →(~∧/'Entity:'=⊃meta[1;1])/oh_well
  wp←wp lex∆assign (⊂'Entity'),meta[1;2]
  wp←wp lex∆assign (⊂'Title'),meta[2;2]
  wp←wp lex∆assign (⊂'Period'),meta[3;2]
  wp←wp lex∆assign (⊂'Id'),meta[1;shape[2]]
  wp←wp lex∆assign (⊂'Author'),meta[2;shape[2]]
  wp←wp lex∆assign (⊂'Attributes'),⊂(⍴data)⍴⊂lex∆init
  wp←wp lex∆assign (⊂'Stylesheet'),⊂lex∆init
  wp←wp lex∆assign (⊂'Data'),⊂data
  →0
oh_well:
  ⍞←'Not a workpaper'
  →0
∇

∇dat←wp∆importArray txt;heads;tails;lns;numbers
  ⍝ Function to convert a tab delimited character vector into a table
  dat←⊃⎕av[10] utl∆split ¨ ⎕av[11] utl∆split txt
  heads←∧/~utl∆numberp ¨ dat[1;] ⍝ Do we have column headings?
  tails←⊃∧/~0=¨⍴¨dat[''⍴⍴dat;]
  lns←heads↓tails↓⍳1↑⍴dat
  numbers←(∧⌿utl∆numberis¨dat)/⍳1↓⍴dat
  dat[lns;numbers]←∆numbers dat[lns;numbers]
∇

∇new←meta wp∆init id;data;entity;title;period;auth;fn
  ⍝ Function to create a store of a workpaper's meta data
  →(2=⎕nc 'meta')/p0
  meta ←lex∆init
p0:  				⍝ Remember id
  meta←meta lex∆assign (⊂'Id'),⊂id
p1:				⍝ Prompt for data variable
  data←prompt 'Data variable name:    '
  ⍎(utl∆numberp data)/'→(qu,p1,dn,p1)[⎕io+data]'
  ⍎(2≠⎕nc data)/'⍞←data,'' does not exist in workspace. ''◊→p1'
  meta←meta lex∆assign (⊂'Data'), ⊂⍎data
  →p2
  ⍝⍞←⎕av[11]
  →p2
p2:				⍝ Prompt for entity
  entity←prompt 'Name of entity         '
  ⍎(utl∆numberp entity)/'→(qu,p1,dn,p1)[⎕io+entity]'
  meta←meta lex∆assign 'Entity' entity
  ⍝⍞←⎕av[11]
  →p3
p3:				⍝ Prompt for title
  title←prompt  'Title of workpaper     '
  ⍎(utl∆numberp title)/'→(qu,p1,dn,p2)[⎕io+title]'
  meta←meta lex∆assign 'Title' title
  ⍝⍞←⎕av[11]
  →p4
p4:				⍝ Prompt for period
  period←prompt 'Period of workpaper    '
  ⍎(utl∆numberp period)/'→(qu,p1,dn,p3)[⎕io+period]'
  meta←meta lex∆assign 'Period' period
  ⍝⍞←⎕av[11]
  →p5
p5:				⍝ Prompt for author
  auth←prompt   'Author of workpaper    '
  ⍎(utl∆numberp auth)/'→(qu,p1,dn,p4)[⎕io+period]'
  meta←meta lex∆assign 'Author' auth
  ⍝⍞←⎕av[11]
  →p6
p6:		                ⍝ Prompt for function name
  fn←prompt     'Function to calculate workpaper '
  ⍎(utl∆numberp fn)/'→(qu,p1,dn,p5)[⎕io+fn]'
  meta←meta lex∆assign 'Function' fn
  ⍝⍞←⎕av[11]
  →p7
p7:				⍝ Prompt for stylesheet variable
  fn←prompt     'Variable holding the stylesheet '
  ⍎(utl∆numberp fn)/'→(qu,p1,dn,p6)[⎕io+fn]'
  ⍎((0≠⍴fn)∧2≠⎕nc fn)/'⍞←fn,'' does not exist in this workspace''◊→p7'
  ⍎(0≠⍴fn)/'meta←meta lex∆assign (⊂''Stylesheet''),⊂',fn,'◊→p8'
  meta←meta lex∆assign (⊂'Stylesheet'),⊂ wp∆defaultcss
p8:				⍝ Prompt for attributes
  fn←prompt      'Variable holding the attribute array  '
  ⍎(utl∆numberp fn)/'→(qu,p1,dn,p7)[⎕io+fn]'
  ⍎(0≠⍴fn)/'meta←meta lex∆assign (⊂''Attributes''),⊂',fn,'◊→p1'
  meta←meta lex∆assign (⊂'Attributes'),⊂wp∆init∆attributes meta lex∆lookup 'Data'
  →p1
  ⍞←fn,' does not exist in the workspace.  '◊→p8
dn:				⍝ Finish and exit
  new←meta
  →0
qu:
  new←lex∆init
  →0
∇

∇css←wp∆init∆styleSheet sheet
  ⍝ Function returns a stylesheet. If sheet is blank
  ⍝ wp∆defaultcss. If sheet is a file, that file processed by
  ⍝ xml∆parseStylesheet. If sheet is text, that text processed by
  ⍝ xml∆parseStylesheet.
  →(0≠⍴sheet←,sheet)/file
  css←wp∆defaultcss
  →0
file:
  sheet←FIO∆read_file sheet
  
∇

∇attr←wp∆acctg∆heurisitcs data;percent;currency;coins;text;colhead;year;shape;yr;dlx;useCols;tCols;rule
  ⍝ Function returns an attribute array based first on wp∆defaultcss
  ⍝ and second on the assumption that the data is used in accounting.
  shape←⍴data
  ⍝ Attribute lexicon for percent includes key for use by wp∆acctg∆restatePercent
  percent←(((lex∆init)lex∆assign 'class' 'number')lex∆assign 'format' '553.0%')lex∆assign 'percent' 1
  currency←((lex∆init)lex∆assign 'class' 'number')lex∆assign 'format' wp∆largeFormat
  coins←((lex∆init)lex∆assign 'class' 'number') lex∆assign 'format' '550.00'
  colhead←(lex∆init)lex∆assign 'class' 'colhead'
  year←((lex∆init)lex∆assign 'class' 'colhead')lex∆assign 'format' '0000'
  text←lex∆init
  attr←shape⍴⊂text
  ⍝ colhead?
  rule←utl∆stringp ¨ data[1;]
  →(∧/rule)/skip_year
  yr←(~rule)\(2100<(~rule)/data[1;])∧1700<(~rule)/data[1;]
  →(~∧/yr∨rule)/0		⍝ This doesn't look like accounting data
  attr[1;yr/⍳shape[2]]←⊂year
  →txt
skip_year:
  attr[1;rule/⍳shape[2]]←⊂colhead
txt:				⍝ Find text columns
  dlx←1↓⍳shape[1]
  useCols←(~(⍳1↓⍴data)∊wp∆acctg∆text data[dlx;])/⍳1↓⍴data
pct:				⍝ Find percentages
  tCols←useCols wp∆acctg∆percent data[dlx;]
  attr[dlx;tCols]←⊂percent
cn:				⍝ Find small dollar amounts
  tCols←useCols wp∆acctg∆small data[dlx;]
  attr[dlx;tCols]←⊂coins
cur:				⍝ Find currency
  tCols←useCols wp∆acctg∆large data[dlx;]
  utl∆es (tCols wp∆acctg∆tooLarge data[dlx;])/'Amounts over 99 million in data'
  attr[dlx;tCols]←⊂currency
  ⍝ At last!
  →0
∇

∇col←wp∆acctg∆text data
  ⍝ Function applies a heuristic to test for charcter data
  col←(∨⌿utl∆stringp ¨ data)/⍳1↓⍴data
∇



∇col←numericCols wp∆acctg∆percent data
  ⍝ Function applies a heuristic to test for percentages and returns
  ⍝ column numbers.
  col←(∧⌿1>data[;numericCols])/numericCols
∇

∇col←numericCols wp∆acctg∆small data
  ⍝ Function applies a heuristic to test for small dollar amounts and
  ⍝ returns column numbers.
  col←((∧⌿500>data[;numericCols])∧∨⌿1≤data[;numericCols])/numericCols
∇

∇col←numericCols wp∆acctg∆large data
  ⍝ Function applies a heuristic to test for large dollar amounts,
  ⍝ that is not small, and returns column numbers.
  col←(~∧⌿500>data[;numericCols])/numericCols
∇

∇bool ← largeCols wp∆acctg∆tooLarge data
  ⍝ Function tests for data greater than the format rules in this workspace.
  bool←∨/,wp∆tooLarge<data[;largeCols]
∇

∇data←att wp∆acctg∆restatePercent old;ix;shape
  ⍝ Function to multiplier percentages by 100 to format properly.
  shape←⍴old
  ix←({⍵ lex∆haskey 'percent'}¨,att)/⍳×/shape
  data←,old
  data[ix]←100×data[ix]
  data←shape⍴data
∇


∇attr←wp∆init∆attributes data;shape;ix
  ⍝ Function creates an array of attributes based on the data
  ⍝ supplied.
  attr←(×/shape←⍴data)⍴⊂lex∆init
  ix←(,utl∆numberp ¨ data)/⍳⍴attr
  attr[ix]←⊂(lex∆init)lex∆assign 'class' '.number'
  attr←shape⍴attr
  →(∧/~utl∆numberp ¨ data[1;])/0
  attr[1;]←⊂(lex∆init)lex∆assign 'class' 'colhead'
∇

∇txt←wp∆readPage fname;fh
  ⍝ Function to read (and return a text file).
  txt←FIO∆read_file fname
  ⎕es (utl∆numberp txt)/fname,' NOT FOUND'
∇

∇bytes←fname wp∆writePage page;fh
  ⍝ Function to write a page to a disk file.
  fh←'w' FIO∆fopen fname
  bytes←(⎕ucs page) FIO∆write fh
  fh←FIO∆fclose fh
∇

∇var←wp∆∆extractData wp
  ⍝ Function returns the data array from a workpaper
  var←wp lex∆lookup 'Data'
∇

∇wp wp∆∆storeData data
  ⍝ Function stores its righ argument in the workpaper left argument
  wp lex∆assign data
∇

∇txt←attr wp∆∆td val;fs
  ⍝ Function to format numeric data and return an html td element.
  txt←(attr lex∆drop 'format')html∆td attr wp∆∆txtCell val
∇

∇txt←attr wp∆∆txtCell val;fs
  ⍝ Funcion returns a numberic cell as text
  →(attr lex∆haskey 'format')/hf
  txt←⍕val
  →0
hf:
  →(fmt∆STSC fs ← attr lex∆lookup 'format')/stsc
  txt←fs⍕val
  →0
stsc:
  txt←fs fmt val
  →0
∇

∇new←wp∆clean old;tix;shape
  ⍝ Function to insert spaces into empty cells
  shape←⍴old
  new←,old
  tix←(∊1=⍴¨⍴¨new)/⍳⍴new
  tix←(∊0=⍴¨ new[tix])/tix
  new[tix]←⊂' '
  new←shape⍴new
∇

∇attr←wp∆EstimatedAttr data;ix;cx;lb;percent;currency
  ⍝ Function returns an attribute array based on the data. This is a
  ⍝ very  experimental function. It tests for numbers less than one
  ⍝ and formats that column as percentages.  Otherwise numeric
  ⍝ columns are formated as currecny. No attempt is made to guess or
  ⍝ control the width of the report.
  percent ← ⊂lex∆from_alist 'class' 'number' 'format' 'K2Q<%>F7.1'
  currency ←⊂lex∆from_alist 'class' 'number' 'format' 'M<(>N<)>CF14.2'
  attr←(⍴data)⍴⊂lex∆init
  →(⍲/utl∆stringp ¨ data[1;])/noColumnHead
  ix←1↓⍳1↑⍴data
  attr[1;]←⊂lex∆from_alist 'classs' 'colhead'
  →table_attrs
noColumnHead:
  ix←⍳1↑⍴data
  →table_attrs
table_attrs:
  cx←1 ◊ lb←((1↓⍴data)⍴st),ed
st:
  →(~∧/utl∆numberp ¨ data[ix;cx])/repeator
  attr[ix;cx]←(currency,percent)[⎕io+1≥⌈/data[ix;cx]]
repeator:
  →lb[cx←cx+1]
ed:
  →0
∇

∇Z←wp⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'wp.txt'
  Z←Z⍪'Download'        'https://sourceforge.net/p/apl-library'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L2'
  Z←Z⍪'Provides'        ''
  Z←Z⍪'Requires'        ''
  Z←Z⍪'Version'                  '0 1 2'
  Z←Z⍪'Last update'         '2019-02-11'
∇

cl∆∆max←20

wp∆defaultcss←6 2⍴00 00 00 00 00 00 00 00 00 00 00 00
    ((⎕IO+(⊂0 0))⊃wp∆defaultcss)←'body'
    ((⎕IO+(⊂0 1))⊃wp∆defaultcss)←3 2⍴00 00 00 00 00 00
      ((⎕IO+(0 1) (0 0))⊃wp∆defaultcss)←' font'
      ((⎕IO+(0 1) (0 1))⊃wp∆defaultcss)←' 12pt sans-serif'
      ((⎕IO+(0 1) (1 0))⊃wp∆defaultcss)←' text-align'
      ((⎕IO+(0 1) (1 1))⊃wp∆defaultcss)←' left'
      ((⎕IO+(0 1) (2 0))⊃wp∆defaultcss)←' border'
      ((⎕IO+(0 1) (2 1))⊃wp∆defaultcss)←'none 2pt black'
    ((⎕IO+(⊂1 0))⊃wp∆defaultcss)←'.colhead'
    ((⎕IO+(⊂1 1))⊃wp∆defaultcss)←2 2⍴00 00 00 00
      ((⎕IO+(1 1) (0 0))⊃wp∆defaultcss)←' text-align'
      ((⎕IO+(1 1) (0 1))⊃wp∆defaultcss)←' center'
      ((⎕IO+(1 1) (1 0))⊃wp∆defaultcss)←' font-size'
      ((⎕IO+(1 1) (1 1))⊃wp∆defaultcss)←' 8pt'
    ((⎕IO+(⊂2 0))⊃wp∆defaultcss)←'.number'
    ((⎕IO+(⊂2 1))⊃wp∆defaultcss)←1 2⍴00 00
      ((⎕IO+(2 1) (0 0))⊃wp∆defaultcss)←' text-align'
      ((⎕IO+(2 1) (0 1))⊃wp∆defaultcss)←' right'
    ((⎕IO+(⊂3 0))⊃wp∆defaultcss)←'.page-head'
    ((⎕IO+(⊂3 1))⊃wp∆defaultcss)←2 2⍴00 00 00 00
      ((⎕IO+(3 1) (0 0))⊃wp∆defaultcss)←' font-size'
      ((⎕IO+(3 1) (0 1))⊃wp∆defaultcss)←' large'
      ((⎕IO+(3 1) (1 0))⊃wp∆defaultcss)←' font-weight'
      ((⎕IO+(3 1) (1 1))⊃wp∆defaultcss)←' bold'
    ((⎕IO+(⊂4 0))⊃wp∆defaultcss)←'.initial-block'
    ((⎕IO+(⊂4 1))⊃wp∆defaultcss)←2 2⍴00 00 00 00
      ((⎕IO+(4 1) (0 0))⊃wp∆defaultcss)←' font-size'
      ((⎕IO+(4 1) (0 1))⊃wp∆defaultcss)←' small'
      ((⎕IO+(4 1) (1 0))⊃wp∆defaultcss)←' border'
      ((⎕IO+(4 1) (1 1))⊃wp∆defaultcss)←' solid 1pt black'
    ((⎕IO+(⊂5 0))⊃wp∆defaultcss)←'.last-head'
    ((⎕IO+(⊂5 1))⊃wp∆defaultcss)←4 2⍴00 00 00 00 00 00 00 00
      ((⎕IO+(5 1) (0 0))⊃wp∆defaultcss)←' font-size'
      ((⎕IO+(5 1) (0 1))⊃wp∆defaultcss)←' large'
      ((⎕IO+(5 1) (1 0))⊃wp∆defaultcss)←' font-weight'
      ((⎕IO+(5 1) (1 1))⊃wp∆defaultcss)←' bold'
      ((⎕IO+(5 1) (2 0))⊃wp∆defaultcss)←' height'
      ((⎕IO+(5 1) (2 1))⊃wp∆defaultcss)←' 36pt'
      ((⎕IO+(5 1) (3 0))⊃wp∆defaultcss)←' vertical-align'
      ((⎕IO+(5 1) (3 1))⊃wp∆defaultcss)←' top'

wp∆tooLarge ←1e8
wp∆largeFormat←'55,555,550'
