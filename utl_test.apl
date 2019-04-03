#! /usr/local/bin/apl --script
 ⍝ ********************************************************************
 ⍝   $Id: $
 ⍝ $desc: Script to test util workspaces $
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

)copy 1 utl
)copy 1 assert
)copy 1 import

⍞←'Creating function test∆help',⎕av[11]
⎕fx t1←(⊂'b←test∆help'),(⊂'⍝ Function created to test utl∆helpFns'),(⊂'b←1'),⊂'⍝ Comment to be ignored'

(⊃'b←test∆help' '⍝ Function created to test utl∆helpFns') assert∆toScreen 'utl∆helpFns ''test∆help'''

True assert∆toScreen 'utl∆numberp ?100'

True assert∆toScreen 'utl∆numberp 5?100'

False assert∆toScreen 'utl∆numberp ''Test string'''

False assert∆toScreen 'utl∆numberp '''''

'A string' assert∆toScreen 'utl∆stripArraySpaces ''   A string        '''


(3 10⍴'Line one  Line two  Line three') assert∆toScreen 'utl∆stripArraySpaces ⊃''   Line one    '' ''  Line two'' ''Line three    '''

'one' 'two' 'three' 'four' 'five' assert∆toScreen '''/'' utl∆split ''one/two/three/four/five''',⎕av[11]

'one/two/three/four' assert∆toScreen '''/'' utl∆join ''one'' ''two'' ''three'' ''four'''

45 ¯16738.8 187 0.006 10510 assert∆toScreen 'utl∆import∆numbers ''/'' utl∆split ''45/(16,738.80)/187/0.006/10,510'''

45 ¯167 1887 ¯.06 5 assert∆toScreen 'utl∆import∆numbers ''/'' utl∆split ''45/-167/1887/-.06/5'''

100 assert∆toScreen 'utl∆convertStringToNumber ''  100  '''


txt←742⍴0 ⍝ prolog ≡1
  (txt)[⍳48]←'Duke.',(,⎕UCS 10),'No, holy father; throw away that thought;',(,⎕UCS 10)
  (txt)[48+⍳48]←'Believe not that the dribbling dart of love',(,⎕UCS 10),'Can '
  (txt)[96+⍳48]←'pierce a complete bosom.  Why I desire thee',(,⎕UCS 10),'To g'
  (txt)[144+⍳47]←'ive me secret harbour, hath a purpose',(,⎕UCS 10),'More grav'
  (txt)[191+⍳47]←'e and wrinkled than the alms and ends',(,⎕UCS 10),'Of burnin'
  (txt)[238+⍳32]←'g youth.',(,⎕UCS 10),'Friar Thomas.',(,⎕UCS 10 9 9),' May yo'
  (txt)[270+⍳34]←'ur grace speak of it?',(,⎕UCS 10),'Duke.',(,⎕UCS 10),'My hol'
  (txt)[304+⍳47]←'y sir, none better knows than you',(,⎕UCS 10),'How I have ev'
  (txt)[351+⍳45]←'er lov''d the life remov''d,',(,⎕UCS 10),'And held in idle p'
  (txt)[396+⍳47]←'rice to haunt assemblies',(,⎕UCS 10),'Where youth, and cost,'
  (txt)[443+⍳46]←' and witless bravery keeps.',(,⎕UCS 10),'I have deliver''d t'
  (txt)[489+⍳47]←'o Lord Angelo,',(,⎕UCS 10),'A man of stricture and firm abst'
  (txt)[536+⍳47]←'inence,',(,⎕UCS 10),'My absolute power and place here in Vie'
  (txt)[583+⍳45]←'nna,',(,⎕UCS 10),'And he supposes me travell''d in Poland;',(,⎕UCS 10)
  (txt)[628+⍳46]←'For so I have strew''d it in the common ear,',(,⎕UCS 10),'An'
  (txt)[674+⍳46]←'d so receiv''d. Now, pious sir,',(,⎕UCS 10),'You will demand'
  (txt)[720+⍳22]←' of me why I do this?',(,⎕UCS 10)

35 61 assert∆toScreen 'txt utl∆search ''that'''

(1⍴673) assert∆toScreen 'txt utl∆search ''And so'''

rs←'And then receiv''d. Now, pious sir,'
rs←rs,,(,⎕ucs 10),'You will demand of me why I do this?',,⎕ucs 10
rs assert∆toScreen '(672↓txt) utl∆replace ''so'' ''then'''

'AND THEN RECEIV''D' assert∆toScreen 'utl∆upper ''And then Receiv''''d'''

'and then receiv''d' assert∆toScreen 'utl∆lower ''And then Receiv''''d'''

True assert∆toScreen 'utl∆numberis ''45'''

True assert∆toScreen 'utl∆numberis ''¯45'''

False assert∆toScreen 'utl∆numberis ''4¯5'''

True assert∆toScreen 'utl∆numberis ''45.'''

False assert∆toScreen 'utl∆numberis ''4.5.'''

True assert∆toScreen 'utl∆numberis ''  123.76 '''

False assert∆toScreen 'utl∆numberis '' 123 76  '''

False assert∆toScreen 'utl∆numberis ''Now is the winter of our discontent'''

⍝execCmd←'tst←utl∆upper ''once'''	⍝ Escaping quotes is tedious

⍝assertCmd←'100 utl∆execTime execCmd'
True assert∆toScreen '0<100 utl∆execTime ''tst←utl∆upper ''''one'''''''

'100' 'A string' '500' assert∆toScreen ''','' utl∆split_with_quotes ''100,"A string",500'''

t1←'A string of many Things including multiple spaces tabs and linefeeds.'
t2←'	A string    of many Things including   ',⎕tc[3],'multiple spaces tabs and linefeeds.     '
t1 assert∆toScreen 'utl∆clean t2'

True assert∆toScreen '''A test string'' utl∆stringEquals ''A test string'''
False assert∆toScreen '''Yet another test string'' utl∆stringEquals ''A test string'''

t1←'/' utl∆split 'one/two/three/four/fifteen/sixty-five'
4 assert∆toScreen 't1 utl∆listSearch ''four'''
7 assert∆toScreen 't1 utl∆listSearch ''seven'''

('06/06/0000' ⍕ ⎕ts[2 3 1]) assert∆toScreen 'utl∆today'

True assert∆toScreen 'utl∆stringp ''A string'''
False assert∆toScreen 'utl∆stringp 16'
False assert∆toScreen 'utl∆stringp 3 4⍴⍳12'
False assert∆toScreen 'utl∆stringp ''A'' ''nested array'' ''of strings'''

105 assert∆toScreen 'utl∆round 104.973'
105 assert∆toScreen '¯1 utl∆round 104.973'
104.97 assert∆toScreen '¯2 utl∆round 104.973'
100 assert∆toScreen '1 utl∆round 104.973'

assert∆setup 'numbered←(⊃''/'' utl∆split ''[001] one/[002] two/[003] fourteen/[004] seventeen/[005] random numbers'')'

numbered assert∆toScreen 'utl∆numberedArray ⊃''one'' ''two'' ''fourteen'' ''seventeen'' ''random numbers'''

assert∆setup 'break_data←import∆file ''/home/dalyw/apl-library/test-data/breakon_data.txt'''

31703 9161 58845 assert∆toScreen 'break_data[;1] utl∆breakon break_data[;2]'

assert∆setup 'sort_test←import∆file ''test-data/inv-fifthQ.txt'''
sort_result← 'ABBV' 'CTL' 'CVX' 'DUK' 'EPD' 'GE' 'GIS' 'GM' 'IBM' 'IEP' 'INTL' 'IP' 'KHC' 'MET' 'MO' 'NWL' 'PAGP' 'PM' 'PRU' 'QCOM' 'SO' 'TRV' 'VLO' 'VZ' 'WDC' 'WRK' 'XONA.F'
sort_result assert∆toScreen 'utl∆sort 1↓sort_test[;1]'

⍝)off
