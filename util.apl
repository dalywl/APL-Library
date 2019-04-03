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

∇rpt←bfld util∆breakon data;bv;b2;cols;bc;tl
  ⍝ Function builds a report of the data by inserting subtotals where
  ⍝ bfld changes
  cols←(,⊃∧⌿util∆numberp¨data)/⍳1↓⍴data
  tl←(1↓⍴data)⍴⊂' '
  →(∧/bv←∧\bfld=bfld[1])/exit
  tl[cols]←+⌿bv⌿data[;cols]
  rpt←(bv⌿data),[1]tl,[1](b2/bfld) util∆breakon (b2←~bv)⌿data
  →0
exit:
  tl[cols]←+⌿data[;cols]
  rpt←data,[1]tl
  →0
∇

∇msg←util∆helpFns fn;src
  ⍝ Function to display help about a function
  src←⎕cr fn
  msg←(1,∧\'⍝'=1↓src[;1])⌿src
∇

∇t←util∆numberp v
  ⍝ Fns returns true if its argument is a number.
  →(0=⍴t←''⍴0=⍴v)/0
  ⍎(1<≡v)/'t←0◊→0'
  t←''⍴0=1↑0⍴v
∇

∇ t←util∆stringp s
⍝ Fns returns true if its argument is a string.
  →(~t←1=≡s)/0			⍝ test for nested array
  t←' '=1↑0⍴s←,s
  
∇

∇b←util∆numberis tst
  ⍝ Function test if a number can be obtained by executing a string
  ⍎(0=⍴tst←,tst)/'b←0 ◊ →0'
  tst←(+/∧\tst=' ')⌽tst	                ⍝ Rotate spaces to right side
  →(~b←(+/∧\b)=+/b←tst≠' ')/0		⍝ Test for spaces imbedded in numbers
  b←(∧/tst∊' 1234567890-¯.')∧∨/0 1=+/tst='.'
  b←b∧∧/~(1↓tst)∊'-¯'
∇

∇a←t util∆over b;w;tr;br
  ⍝ fn to return an array (of rank 2) with t on the top and b on the bottom.
  t←(rt←¯2↑1 1,⍴t)⍴t
  b←(br←¯2↑1 1,⍴b)⍴b
  w←rt[2]⌈br[2]
  rt[2]←br[2]←w
  a←(rt↑t),[1]br↑b
∇

∇New←util∆trim old;b
  ⍝ Function to strip off leading and  trailing spaces.
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

∇new←util∆strip txt;b
  ⍝ Function to remove leading and trailing spaces
  b←~(∧\b)∨⌽∧\⌽b←txt=' '
  new←b/txt
∇

∇o←k util∆sub d
  ⍝ Function to calculate subtotals for each break point in larg
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

∇n←util∆import∆numbers s;bv
 ⍝ Function to turn a column of figures (ie characters) into numbers
 ⍎(2=≡s)/'s←⊃s'
 bv←~∧/s=' '
 s[(s∊'(-')/⍳⍴s←,' ',s]←'¯'
 n←bv\⍎(~s∊'),')/s
∇

∇string←delim util∆join array
  ⍝ Function returns a character string with delim delimiting the items
  ⍝ in array.
  string←1↓∊,delim,(⌽1,⍴array)⍴array
∇

∇v←delim util∆split string;b;c
  ⍝ Function splits a character string into a nested array of strings
  ⍝ using delim as the delimiter.
  →(1≠⍴delim←,delim)/many
  →(∧/b←string ≠ delim)/last
  →exit
many:
  →(∧/~b←string∊delim)/last
  string←(c←~b∧1⌽b)/string
  b←c/~b
  →exit
exit:
  v←(⊂b/string),delim util∆split 1↓(~b←∧\b)/string
  →0
last:
  v←1⍴⊂string
∇

∇ix← list util∆stringSearch item;rl;ri;l
  ⍝ Utility to search a character list for an item.
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

∇ix←txt util∆search word;⎕io;old∆io;ixx;bv
  ⍝ Function to search for larg in rarg
  old∆io←⎕io
  ⎕io←0
  ixx←⍳⍴txt←,txt
  bv←(txt=1↑word←,word)∧ixx≤(⍴txt)-⍴word
  ix←bv/ixx
  ix←old∆io+(txt[ix∘.+⍳⍴word]∧.=word)/ix
∇

∇new←txt util∆replace args;ix
  ⍝ Function to search for and replace an item in rarg.  Larg is a two
  ⍝ element vector where Larg[1] is the text to search for, Larg[2] is
  ⍝ the replacement text.
  ix← txt util∆search ⊃args[1]
  new←((¯1+ix)↑txt),(,⊃args[2]),(¯1+(ix←''⍴ix)+⍴,⊃args[1])↓txt
∇


∇t←n util∆execTime c;ts;lb;i
  ⍝ Function returns the number of milliseconds a command took. larg
  ⍝ is the number of to execute command.  If larg is missing we
  ⍝ execute once.
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

∇today←util∆today
  ⍝ Function to return today's date as a string
  today←'06/06/0000'⍕⎕ts[2 3 1]

∇

∇txt←util∆lower m;ix
  ⍝ Function to convert text to all lower case.
  m←⎕ucs m←,m
  ix←((m≥65)∧m≤90)/⍳⍴m
  m[ix]←m[ix]+32
  txt←⎕ucs m
∇

∇txt←util∆upper m;ix
  ⍝ Function to convert text to all lower case.
  m←⎕ucs m←,m
  ix←((m≥97)∧m≤122)/⍳⍴m
  m[ix]←m[ix]-32
  txt←⎕ucs m
∇

∇v←delim util∆split_with_quotes string;b;c
  ⍝ Function to split a string on a delimiter where some delimiter(s)
  ⍝ may be inside quotes
  delim←,delim
  b←~(string∊delim)∧~≠\string='"'
  v←(⊂c/string), ((~c)/b) util∆swq_helper (~c←∧\b)/string
  v←util∆strip_quotes ¨ v
∇

∇v←b util∆swq_helper string;c;d
  ⍝ Helper function for util∆split_with_quotes
  →(0=+/~b)/end
  d←~c←∧\1↓b
  v←(⊂c/1↓string), (d/1↓b) util∆swq_helper d/1↓string
  →0
end:
  v←0⍴0
∇

∇b←str1 util∆stringEquals str2;l
  ⍝ Function to compare two strings
  l←(⍴str1)⌈⍴str2
  b←∧/(l↑str1)=l↑str2
∇

∇cl←util∆clean txt;b
   ⍝ Function to remove all whitespace but spaces and then duplicate spaces
   txt[(txt∊⎕tc,⎕av[10])/⍳⍴txt←,txt]←' '
   txt←(~(1⌽b)∧b←txt=' ')/txt
   cl←(txt[1]=' ')↓(-txt[⍴txt]=' ')↓txt
∇

∇txt←util∆crWithLineNo name;l
  ⍝ Function returns a character representation with line numbers
  l←¯1+1↑⍴txt←⎕cr name
  txt←('     ∇',[1]'[000] '⍕(l,1)⍴⍳l),txt
∇

∇clean←util∆strip_quotes txt;bv
 ⍝ Function to strip of beginging and quotes if they exists.
 clean←txt
 →(~1↑bv←≠\clean∊'''"')/0
 clean←(bv∧¯1⌽bv)/clean
∇

∇new←om util∆round old
⍝ Function to round numbers based on the o(order of) m(agnitude). om
  ⍝ will be evaluated as a power of so that ¯2 is two digits to the
  ⍝ right of the decimal and 2 is to the left
  om←10*om
  new←om×⌊.5+old÷om
∇

∇ar←util∆concatColumns na
  ⍝ Function returns a 2 dimensional text array from a nested array of text
  →(1=¯1↑⍴na)/lastCol
  ar←(⊃na[;1]),' ', util∆concatColumns 0 1↓na
  →0
lastCol:
  ar←⊃,na
  →0
∇
  
∇n←util∆numberFromString s;bv;a                                       
  ⍝ Function to convert a vector of characters to a number.  Function
  ⍝ returns the original string when it fails in this attempt.       
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

∇util∆es msg
  ⍝ Function to simulate an error. Similar to ⎕es with better control
  ⍝ the error message. Thanks JAS
  →(0=⍴msg)/0
  msg ⎕es 100 0
∇

∇b←list util∆member item
⍝ Function returns whether for item, a character vector, is in list, a
  ⍝ character array or nested list of strings.
  b←(1+1↑⍴list)>list util∆stringSearch item
∇

∇Z←util⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'lex.txt'
  Z←Z⍪'Download'        'https://sourceforge.net/p/apl-library/code/ci/master/tree/util.apl'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L1'
  Z←Z⍪'Provides'        ''
  Z←Z⍪'Requires'        ''
  Z←Z⍪'Version'                  '0 0 15'
  Z←Z⍪'Last update'         '2018-11-23'
∇
