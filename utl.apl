#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝   $Id: $
⍝ $desc: Library of useful apl functions $
⍝ ********************************************************************

⍝ Util
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

∇msg←utl∆helpFns fn;src;t
  ⍝ Display help about a function
  src←⎕cr fn
  t←(+/∧\src=' ')⌽src
  msg←(1,∧\'⍝'=1↓t[;1])⌿src
∇

∇t←utl∆numberp v
  ⍝ Is arg a number?
  →(0=⍴t←''⍴0=⍴v)/0
  ⍎(1<≡v)/'t←0◊→0'
  t←''⍴0=1↑0⍴v
∇

∇ t←utl∆stringp s
  ⍝ Is arg a string?
  ⍝ test for nested array
  →(~t←1=≡s)/0			
  t←''⍴' '=1↑0⍴s←,s
  
∇

∇b←utl∆numberis tst
  ⍝ Test whether a number can be obtained by executing a string
  ⍎(0=⍴tst←,tst)/'b←0 ◊ →0'
  ⍝ Rotate spaces to right side
  tst←(+/∧\tst=' ')⌽tst
  ⍝ Test for spaces imbedded in numbers
  →(~b←(+/∧\b)=+/b←tst≠' ')/0		
  b←(∧/tst∊' 1234567890-¯.')∧∨/0 1=+/tst='.'
  b←b∧∧/~(1↓tst)∊'-¯'
∇

∇New←utl∆stripArraySpaces old;b
  ⍝ Strips off leading and trailing spaces. Function operates on both
  ⍝ vectors and arrays of rank 2. See also utl∆clean.
  New←(+/∧\old=' ')⌽old
  b←⌊/+/∧\⌽New=' '
  →(V,M,E)[3⌊⍴⍴old]
  ⍝ Vector
V:
  New←New[⍳-b-⍴New]
  →0
  ⍝ Matrix
M:
  New←New[;⍳-b-1↓⍴New]
  →0
  ⍝ Error -- rank of old is too high
E:
  ⎕es 'Rank of array is too high'
∇

∇cl←utl∆clean txt;b
   ⍝ Converts all whites space to spaces and then removes duplicate
   ⍝ spaces. See also utl∆stringArraySpaces.
   txt[(txt∊⎕tc,⎕av[10])/⍳⍴txt←,txt]←' '
   txt←(~(1⌽b)∧b←txt=' ')/txt
   cl←(txt[1]=' ')↓(-txt[⍴txt]=' ')↓txt
∇

∇o←k utl∆sub d
  ⍝ Calculates subtotals for each break point in larg
  o←+\[1]d
  ⍝ Test for rank of data
  ⎕es (~(⍴⍴d) ∊ 1 2)/'RANK ERROR'
  →(V,A)[⍴⍴d]
  ⍝ Vectors
V:o←o[k]-¯1↓0,o[k]
  →0
  ⍝ Arrays (of rank 2)
A: o←o[k;]-0,[1] o[¯1↓k;]
  →0
∇

∇string←delim utl∆join vector
  ⍝ Returns a character string with delim delimiting the items
  ⍝ in vector.
  string←1↓∊,delim,(⌽1,⍴vector)⍴vector
∇

∇v←delim utl∆split string;b;c
  ⍝ Splits a character string into a nested vector of strings using
  ⍝ delim as the delimiter.
  →(1≠⍴delim←,delim)/many
  →(∧/b←string ≠ delim)/last
  →exit
many:
  →(∧/~b←string∊delim)/last
  string←(c←~b∧1⌽b)/string
  b←c/~b
  →exit
exit:
  v←(⊂b/string),delim utl∆split 1↓(~b←∧\b)/string
  →0
last:
  v←1⍴⊂string
∇

∇ix← list utl∆listSearch item;rl;ri;l
  ⍝ Search a character list for an item.
  →(1=≡list)/arr
  list←⊃list
arr:
  ⎕es(2≠⍴rl←⍴list)/'RANK ERROR'
  ri←⍴item←,item
  l←rl[2]⌈ri
  →(0=⍴ix←(((rl[1],l)↑list)∧.=l↑,item)⌿⍳rl[1])/naught
  ix←''⍴ix
  →0
naught:
  ix←1+''⍴⍴list
∇

∇ix←txt utl∆search word;⎕io;old∆io;ixx;bv
  ⍝ Search for larg in rarg.
  old∆io←⎕io
  ⎕io←0
  ixx←⍳⍴txt←,txt
  bv←(txt=1↑word←,word)∧ixx≤(⍴txt)-⍴word
  ix←bv/ixx
  ix←old∆io+(txt[ix∘.+⍳⍴word]∧.=word)/ix
∇

∇new←txt utl∆replace args;ix
  ⍝ Search for and replace an item in rarg.  Larg is a two element
  ⍝ vector where Larg[1] is the text to search for, Larg[2] is the
  ⍝ replacement text.
  ix← txt utl∆search ⊃args[1]
  new←((¯1+ix)↑txt),(,⊃args[2]),(¯1+(ix←''⍴ix)+⍴,⊃args[1])↓txt
∇


∇t←n utl∆execTime c;ts;lb;i
  ⍝ Returns the number of milliseconds a command took. larg is the
  ⍝ number of times to execute command.  If larg is missing we execute
  ⍝ once.
  →(2=⎕nc 'n')/many
  ts←⎕ts
  ⍎c
  →ed
many:
  lb←(n⍴st),ed
  i←0
  ts←⎕ts
st:
  ⍎c
  →lb[i←i+1]
ed:
  t←⎕ts
  t←(60 1000⊥t[6 7])-60 1000⊥ts[6 7]
  →0
∇

∇today←utl∆today
  ⍝ Today's date as a string
  today←'06/06/0000'⍕⎕ts[2 3 1]

∇

∇txt←utl∆lower m;ix
  ⍝ Convert text to all lower case.
  m←⎕ucs m←,m
  ix←((m≥65)∧m≤90)/⍳⍴m
  m[ix]←m[ix]+32
  txt←⎕ucs m
∇

∇txt←utl∆upper m;ix
  ⍝ Convert text to all upper case.
  m←⎕ucs m←,m
  ix←((m≥97)∧m≤122)/⍳⍴m
  m[ix]←m[ix]-32
  txt←⎕ucs m
∇

∇v←delim utl∆split_with_quotes string;b;c
  ⍝ Split a string on a delimiter where some delimiter(s) may be
  ⍝ inside quotes and therefore ignored.
  delim←,delim
  b←~(string∊delim)∧~≠\string='"'
  v←(⊂c/string), ((~c)/b) utl∆swq_helper (~c←∧\b)/string
  v←utl∆strip_quotes ¨ v
∇

∇v←b utl∆swq_helper string;c;d
  ⍝ Helper function for utl∆split_with_quotes
  →(0=+/~b)/end
  d←~c←∧\1↓b
  v←(⊂c/1↓string), (d/1↓b) utl∆swq_helper d/1↓string
  →0
end:
  v←0⍴0
∇

∇b←str1 utl∆stringEquals str2;l
  ⍝ Compare two strings.
  l←(⍴str1)⌈⍴str2
  b←∧/(l↑str1)=l↑str2
∇

∇txt←utl∆crWithLineNo name;l
  ⍝ Add line numbers to a character representation of a function.
  l←¯1+1↑⍴txt←⎕cr name
  txt←('     ∇',[1]'[000] '⍕⍪⍳l),txt
∇

∇clean←utl∆strip_quotes txt;bv
 ⍝ Strip quotes from the start and end of character string.
 clean←txt
 →(~1↑bv←≠\clean∊'''"')/0
 clean←(bv∧¯1⌽bv)/clean
∇

∇new←om utl∆round old
  ⍝ Round numbers based on the Order of Magnitude.  Left
  ⍝ arg is thus a power of ten where positive numbers round to the
  ⍝ left of the decimal point and negative to the right.
  ⍎(2≠⎕nc'om')/'om←0'
  om←10*om
  new←om×⌊.5+old÷om ∇

∇ar←utl∆concatColumns na
  ⍝ Function returns a 2 dimensional text array from a nested array of text.
  →(1=¯1↑⍴na)/lastCol
  ar←(⊃na[;1]),' ', utl∆concatColumns 0 1↓na
  →0
lastCol:
  ar←⊃,na
  →0
∇
  
∇n←utl∆convertStringToNumber s;bv;a                                       
  ⍝ Converts a vector of characters to a number.  Function
  ⍝ returns the original string when it fails in this attempt. For
  ⍝ strings multiple numbers see utl∆import∆numbers.
  →(~∧/s∊'0123456789.,-¯ ()')/fail                                      
  →(1<+/s='.')/fail                                                  
  →(0=⍴(s≠' ')/s)/fail
  a←((~∧\bv)∧⌽~∧\⌽bv←s=' ')/s                                       
  →(0≠+/a=' ')/fail                                                  
  a[(a∊'(-')/⍳⍴a←,' ',a]←'¯'                                         
  n←⍎(~a∊'),')/a                                                     
  →0                                                                 
fail:                                                                
  n←s                                                                
∇

∇n←utl∆import∆numbers s;bv
 ⍝ Function to turn a column of figures (ie characters) into
 ⍝ numbers. For a single number see util∆convertStringToNumber
 ⍎(2=≡s)/'s←⊃s'
 bv←~∧/s=' '
 s[(s∊'(-')/⍳⍴s←,' ',s]←'¯'
 n←bv\⍎(~s∊'),')/s
∇


∇utl∆es msg
  ⍝ Simulate an error. Similar to ⎕es with better control of the error
  ⍝ message. Thanks JAS
  →(0=⍴msg)/0
  msg ⎕es 100 0
∇

∇b←list utl∆member item
  ⍝ Tests whether a character vector is in list, a character array,
  ⍝ or a nested list of strings.
  b←(1+1↑⍴list)>list utl∆stringSearch item
∇

∇parsed←utl∆fileName∆parse fname;suffix
  ⍝ Function breaks a fname down into three strings:
  ⍝  1) Path to directory
  ⍝  2) root name
  ⍝  3) suffix, that is whatever trails the final '.'.
  parsed←'/' utl∆split fname
  suffix←'.' utl∆split (⍴parsed)⊃parsed
  →(one,many)[2⌊⍴suffix]
one:
  parsed←(⊂'/' utl∆join ¯1↓ parsed),⊃suffix,⊂''
  →0
many:
  parsed←(⊂'/' utl∆join ¯1↓ parsed),(⊂'.'utl∆join ¯1↓suffix),¯1↑suffix
  →0
∇

∇dir←utl∆fileName∆dirname parsed
  ⍝ Function returns the directory portion of a parsed file name
  dir→1⊃parsed
∇

∇base←utl∆fileName∆basename parsed
  ⍝ Function returns the base of the file name from a parsed file name
  base←2⊃parsed
∇

∇suffix←utl∆fileName∆suffixname parsed
  ⍝ Function returns the suffix of a parsed file name.
  suffix ← 3⊃parsed
∇

∇backup←utl∆fileName∆backupname parsed
  ⍝ Function returns a name to which a file can be backed up.
  backup←(1⊃parsed),'/',(2⊃parsed),'.bak'
∇

∇ar←utl∆concatColumns na
  ⍝ Function returns a 2 dimensional text array from a nested array of text
  →(1=¯1↑⍴na)/lastCol
  ar←(⊃na[;1]),' ', utl∆concatColumns 0 1↓na
  →0
lastCol:
  ar←⊃,na
  →0
∇
  
∇sub←breakFld utl∆breakon amts;ix
  ⍝ function to calculate subtotals for changes in breakFld
  ix←(~breakFld utl∆stringEquals ¨ 1⌽breakFld)/⍳⍴breakFld←,breakFld
  sub←ix utl∆sub amts
∇

∇numbered←utl∆numberedArray array;shape;level
  ⍝ Function prepends a line number on to an array
  shape←⍴array
  utl∆es ((0=level)∨(2≠⍴⍴array)∨2<level←≡array)/'Malformed array for these purposes'
  numbered←('[003] '⍕(shape[1],1)⍴⍳shape[1]),array
∇

∇ix←utl∆gradeup data;t1;base
  ⍝ Function to alphabetically grade up data
  ⍎(∧/(2=≡data),t1←utl∆stringp ¨ data)/'data←⊃data'
  utl∆es (~∧/t1)/'DATA NOT CHARACTERS'
  base←2*⍳20
  base←base[+/1,∧\base<⌈/⎕ucs ∊,data]
  ix←⍋(⊂(¯1↑⍴data)⍴base)⊥¨⊂[2]⎕ucs¨data
∇
  

∇new ← utl∆sort old;base
  ⍝ Function sorts a character array or nested character vectors
  new←old[utl∆gradeup old]
∇

∇Z←utl⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'utl.txt'
  Z←Z⍪'Download'        'https://sourceforge.net/p/apl-library/code/ci/master/tree/utl.apl'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L1'
  Z←Z⍪'Provides'        ''
  Z←Z⍪'Requires'        ''
  Z←Z⍪'Version'                  '0 1 3'
  Z←Z⍪'Last update'          '2019-02-11'
∇

