#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ fmt.apl Workspace to implement a substitute for ⎕fmt (STSC and Dyalog)
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

)copy 1 lex
)copy 1 utl

∇bool←fmt_parser_blank fp
  ⍝ Function returns whether blanks should be returned when the amount is zero.
  bool←∨/(fp lex∆lookup 'ba')[;8]
∇

∇bool←fmt_parser_comma fp;bv
   ⍝ Function returns whether comma separators is requested.
   bool←∨/(fp lex∆lookup 'ba')[;9]
∇

∇fp←fmt_parser_init ftxt;txt_delim;ba
  ⍝ Function returns a format parser
  fp←lex∆init
  fp←fp lex∆assign 'ftxt' ftxt
  fp←fp lex∆assign (⊂'repeat'), ⍎'0',(∧\ftxt∊'0123456789')/ftxt
  txt_delim←~≠\ftxt∊'⍞⊂⊃<>⎕"/'
  ba←txt_delim⍀txt_delim⌿ftxt∘.=fmt_parser_tokens
  utl∆es (~∨/fmt_parser_phrase_count↑∨⌿ba)/'NO PHRASE IDENTIFIED. SUPPLY ONE OF A, E, F, G, or I'
  fp←fp lex∆assign 'ba' ba
∇

∇bool←fmt_parser_leftj fp
   ⍝ Function returns whether to left justify the results.
   bool←∨/(fp lex∆lookup 'ba')[;9]
∇

∇decorator←fmt_parser_leftn fp;ba
   ⍝ Function returns the postfix deocration of negative numbers.
   →((0=⍴fmt_parser_rightn fp)∧~∨/(ba←fp lex∆lookup 'ba')[;12])↑nul
   decorator←fmt∆mod∆arg (+/1,∧\~ba[;12])↓fp lex∆lookup 'ftxt'
   →0
 nul:
   decorator←,'-'
   →0
∇

∇decorator←fmt_parser_leftp fp
   ⍝ Function returns the prefix decoration of positive numbers.
   decorator←fmt∆mod∆arg (+/1,∧\~(fp lex∆lookup 'ba')[;15])↓fp lex∆lookup 'ftxt'
∇

∇type←fmt_parser_phraseType fp;phrases
   ⍝ Function returns the phrase type where A is character field, E is
   ⍝ exponential, F is Fixed point, G is a pattern, and I is Integer
   type←(fmt_parser_phrase_count↑∨⌿fp lex∆lookup 'ba')/fmt_parser_phrase_count↑fmt_parser_tokens
∇

∇prec←fmt_parser_prec fp;wdotp
   ⍝ Function returns the number of deciaml places in the result
   →(~∨/'.'=wdotp←fmt_parser_wdotp fp)/zip
   prec←⍎(⌽∧\'.'≠⌽wdotp)/wdotp
   →0
 zip:
   prec←0
   →0
∇

∇count←fmt_parser_repeat fp
   ⍝ Function returns the count of requested repeats of the field
   ⍝ specification
   count←fp lex∆lookup 'repeat'
∇

∇decorator←fmt_parser_rightn fp;p;n;ba;ftxt
   ⍝ Function returns the prefix decoration of negative numbers.
   ba←fp lex∆lookup 'ba'
   ftxt←fp lex∆lookup 'ftxt'
   p←fmt∆mod∆arg (+/1,∧\~ba[;15])↓ftxt
   n←fmt∆mod∆arg (+/1,∧\~ba[;13])↓ftxt
   decorator←((⍴p)⌈⍴n)↑n
∇

∇decorator←fmt_parser_rightp fp;ba;ftxt;p;n
   ⍝ Function returns the prefix decoration of positive numbers.
   ba←fp lex∆lookup 'ba'
   ftxt←fp lex∆lookup 'ftxt'
   p←fmt∆mod∆arg (+/1,∧\~ba[;16])↓ftxt
   n←fmt∆mod∆arg (+/1,∧\~ba[;13])↓ftxt
   decorator←((⍴p)⌈⍴n)↑p
∇

∇exponent←fmt_parser_scale fp;pos;ftxt
   ⍝ Function returns the power of ten to multiply time the numbers to
   ⍝ be formated.
   ftxt←fp lex∆lookup 'ftxt'
   pos←+/1,∧\~(fp lex∆lookup 'ba')[;10]
   exponent←(∧\(pos↓ftxt)∊'0123456789')/pos↓ftxt
   →(0=⍴exponent)/nul
   utl∆es (~utl∆numberis exponent)/'Scale argument (K is the modifier) muse be numeric.'
   exponent←⍎exponent
   →0
 nul:
   exponent←0
∇

∇wdotp←fmt_parser_wdotp fp
   ⍝ Function returns the width,'.',precision
   wdotp←(⌽∧\~⌽∨/fp lex∆lookup 'ba')/fp lex∆lookup 'ftxt'
∇

∇int←fmt_parser_width fp;wdotp
   ⍝ Function returns the width of the results
   int←⍎(∧\wdotp≠'.')/wdotp←fmt_parser_wdotp fp
∇

∇bool←fmt_parser_zero fp
   ⍝ Function returns whether to pad all output with zeros.
   bool←∨/(fp lex∆lookup 'ba')[;19]
∇

∇txt←control fmt nums;ctls;cmd;lb;ix;iy
  ⍝ Function returns a character array representation of
  ⍝ nums. Substitute for STSC ⎕fmt.  
  →(once,vector,array,no)[⎕io+⍴⍴nums]
once:
  utl∆es (','∊control)/'LEFT ARGUMENT MUST HAVE ONE FIELD.'
  ctls←fmt_parser_init control
  txt←⍎'ctls fmt∆',(fmt_parser_phraseType ctls),' nums'
  →0
vector:
  ctls←fmt∆withRepeats fmt_parser_init¨',' utl∆split control
  utl∆es ((⍴ctls)≠⍴nums)/'THERE MUST BE A FIELD IN THE LEFT ARGUMET FOR EACH ITEM IN THE RIGHT.'
  txt←''
  ix←1
  lb←((⍴nums)⍴vstart),vend
vstart:
  txt←txt,⍎'(ix⊃ctls) fmt∆',(fmt_parser_phraseType ix⊃ctls),' nums[ix]'
  →lb[ix←ix+1]
vend:
 →0
array:
  ctls←fmt∆withRepeats fmt_parser_init¨',' utl∆split control
  utl∆es ((⍴ctls)≠¯1↑⍴nums)/'NUMBER OF COLUMNS IN RIGHT ARGUMNET NOT EQUAL TO FIELDS IN LEFT.'
  txt←(1↑⍴nums)⍴⊃''
  ix←iy←1
  lb←((⍴nums)⍴astart),anewline
  lb[1↑⍴lb;1↓⍴lb]←aend
astart:
  (iy⊃txt)←(iy⊃txt),⍎'(ix⊃ctls) fmt∆',(fmt_parser_phraseType ix⊃ctls),' nums[iy;ix]'
  →lb[iy;ix←ix+1]
anewline:
  iy←iy+1
  ix←1
  →astart
aend:
  txt←⊃txt
  →0
no:
  utl∆es 'RIGHT ARGUMENT NOT A SCALOR, VECTOR, OR TABLE'
  →0
∇

∇ctls←fmt∆withRepeats old;cc
  cc←⍴ctls←old
  tmp←(((cc,5)⍴'ctls['),⍕(cc,1)⍴⍳cc),']'
  tmp←(⍕(cc,1)⍴1⌈fmt_parser_repeat ¨ ctls),'⍴',tmp
  tmp←'(',tmp,')'
  ctls←⍎¯1↓,tmp,','
∇

∇txt←suffix fmt∆push old
  ⍝ Function to append suffix onto the end of old.
  txt←old,suffix
∇

∇txt←fp fmt∆A chars
  ⍝ Function returns chars as a left justified txt.
  ⍎(1<≡chars)/'chars←⊃chars'
  chars←(~∧\chars=' ')/chars←,chars
  txt←(fmt_parser_width fp)↑chars
∇

∇txt←fp fmt∆E num;mnt;exp;width;prec;mask;prefix;suffix
  ⍝ Function to return scaled format
  width←fmt_parser_width fp
  →(0≤num)/pos
neg:
  prefix←fmt_parser_leftn fp
  suffix←fmt_parser_rightn fp
  →more
pos:
  prefix←fmt_parser_leftp fp
  suffix←fmt_parser_rightp fp
  →more
more:
  ⍝ Not precision, number of significant digits with one left of the decimal
  prec←¯1+fmt_parser_prec fp
  →(0=num)/zip
  exp←⌊10⍟|num
  mnt←num÷10*exp
  txt←⍕exp
  →(width≤2+prec+⍴txt)/bad
  mask←(('3.',prec⍴'0'),'E')
  txt←(-width)↑prefix,(mask⍕mnt),txt,suffix
  →0
zip:
  txt←(-width)↑'0.',(prec⍴'0'),'E0 '
  →0
bad:
  txt←width⍴'*'
  →0
∇

∇txt←fp fmt∆F num;mask
   ⍝ Function returns a fully formated fixed point number
  mask←fp fmt∆mask num
  scale←10*fmt_parser_scale fp
  →((num=0)∧fmt_parser_blank fp)/zip
  'txt←(⍴mask)⍴''*''◊→0' ⎕ea 'txt←mask⍕scale×num'
  →0
zip:
  txt←(⍴mask)⍴' '
  →0
∇

∇txt← fp fmt∆G num
  ⍝ Functionm returns a pattern
  txt←'G not implemented.'
∇

∇txt←fp fmt∆I num;mask
   ⍝ Function returns a fully formated integer
   mask←fp fmt∆mask num
  scale←10*fmt_parser_scale fp
  →((num=0)∧fmt_parser_blank fp)/zip
  'txt←(⍴mask)⍴''*''◊→0' ⎕ea 'txt←mask⍕scale×num'
  →0
zip:
  txt←(⍴mask)⍴' '
  →0
∇

∇txt←fp fmt∆T num
  ⍝ Function returns abvsolute tabulation
  txt←'T not implemented.'
∇

∇txt←fp fmt∆X num
  ⍝ Function returns relative tabulation
  txt← 'X not implemented.'
∇

∇mask←fp fmt∆mask num;prefix;suffix;width;mwidth;prec;ctrlchar
   ⍝ Function returns a mask, the left argument for format by example.
   →(0≤num)/pos
   prefix← fmt_parser_leftn fp
  suffix← fmt_parser_rightn fp
  ctrlchar←'1'
  →step2
 pos:
   prefix← fmt_parser_leftp fp
  suffix← fmt_parser_rightp fp
  ctrlchar←'2'
   →step2
 step2:
   prec←fmt_parser_prec fp
   width←fmt_parser_width fp
   mwidth←width-prec+(⍴prefix)+(⍴suffix)+'F'=fmt_parser_phraseType fp
   mask←((mwidth-2)⍴'50'[⎕io+fmt_parser_zero fp]),ctrlchar,'0'
  →(fmt_parser_comma fp)↓step3
  →(fmt_parser_zero fp)↑step3
   mask[1+mwidth-4×⍳⌊.25×mwidth]←','
 step3:
   →(prec=0)/noPrec
   mask←prefix,mask,'.',(prec⍴'0'),suffix
   →0
 noPrec:
   mask←prefix,mask,suffix
   →0
∇

∇arg←fmt∆mod∆arg ftxt
   ⍝ Function returns modifier arguments (Quoted text follwing a
   ⍝ modifier.
   →(0=⍴ftxt)/nul
   delim←1↑ftxt
   utl∆es (~delim∊'<⊂"⎕⍞/')/'Text delimiters are <>, ⊂⊃,"",⎕⎕,⍞⍞//'
   delim←'>⊃"⎕⍞/'['<⊂"⎕⍞/'⍳delim]
   arg←(0,∧\delim≠1↓ftxt)/ftxt
   →0
 nul:				⍝Nul argument.  IE no modifier
   arg←0⍴' '
   →0
∇

∇b←fmt∆STSC mask
  ⍝ Test a format string. Returns true for format strings for function fmt.
  mask←',' utl∆split mask
  b←(fmt_parser_phrase_count↑fmt_parser_tokens)∊⊃mask
  b←∧/∨/b
∇

∇Z←fmt⍙metadata
Z←0 2⍴⍬
Z←Z⍪'Author'          'Bill Daly'
Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
Z←Z⍪'Documentation'   'Source code'
Z←Z⍪'Download'        'sourceforge.net/projects/apl-library/'
Z←Z⍪'License'         'GPL V3.0'
Z←Z⍪'Portability'     'L1'
Z←Z⍪'Provides'        'fmt; function to substitute ⎕fmt'
Z←Z⍪'Requires'        'utl lex'
Z←Z⍪'Version'         '0 0 1'
∇

fmt_parser_tokens←'AEFGITXBCKLMNOPQRSZ'

fmt_parser_phrase_count←7


