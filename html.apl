#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝   $Id: $
⍝ $desc: Provides functions to tag items and build an html file. $
⍝ ********************************************************************


⍝ Copyright (C) 2017 Bill Daly 

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

⍝ html workspace
							
⍝ This is a workspace to create html files. html is a text markup scheme
⍝ used by the world wide web.  At its most basic level html is a
⍝ collection of tags, that is a word enclosed in angle brackets, which
⍝ instruct a web browser how to display the text.

)copy 1 xml

html5∆closedTagList←3⍴0
((⎕IO+0)⊃html5∆closedTagList)←2⍴'br'
((⎕IO+1)⊃html5∆closedTagList)←2⍴'hr'
((⎕IO+2)⊃html5∆closedTagList)←4⍴'meta'

html5∆tagList←34⍴0
html5∆tagList[0+⍳34]←'a∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘∘'
((⎕IO+1)⊃html5∆tagList)←1⍴'b'
((⎕IO+2)⊃html5∆tagList)←10⍴'blockquote'
((⎕IO+3)⊃html5∆tagList)←4⍴'body'
((⎕IO+4)⊃html5∆tagList)←7⍴'caption'
((⎕IO+5)⊃html5∆tagList)←4⍴'cite'
((⎕IO+6)⊃html5∆tagList)←3⍴'div'
((⎕IO+7)⊃html5∆tagList)←2⍴'em'
((⎕IO+8)⊃html5∆tagList)←6⍴'footer'
((⎕IO+9)⊃html5∆tagList)←2⍴'h1'
((⎕IO+10)⊃html5∆tagList)←2⍴'h2'
((⎕IO+11)⊃html5∆tagList)←2⍴'h3'
((⎕IO+12)⊃html5∆tagList)←2⍴'h4'
((⎕IO+13)⊃html5∆tagList)←2⍴'h5'
((⎕IO+14)⊃html5∆tagList)←4⍴'head'
((⎕IO+15)⊃html5∆tagList)←6⍴'header'
((⎕IO+16)⊃html5∆tagList)←2⍴'hr'
((⎕IO+17)⊃html5∆tagList)←4⍴'html'
((⎕IO+18)⊃html5∆tagList)←1⍴'i'
((⎕IO+19)⊃html5∆tagList)←2⍴'li'
((⎕IO+20)⊃html5∆tagList)←4⍴'link'
((⎕IO+21)⊃html5∆tagList)←3⍴'nav'
((⎕IO+22)⊃html5∆tagList)←1⍴'p'
((⎕IO+23)⊃html5∆tagList)←3⍴'pre'
((⎕IO+24)⊃html5∆tagList)←4⍴'span'
((⎕IO+25)⊃html5∆tagList)←6⍴'strong'
((⎕IO+26)⊃html5∆tagList)←5⍴'style'
((⎕IO+27)⊃html5∆tagList)←2⍴'td'
((⎕IO+28)⊃html5∆tagList)←2⍴'th'
((⎕IO+29)⊃html5∆tagList)←5⍴'thead'
((⎕IO+30)⊃html5∆tagList)←2⍴'tr'
((⎕IO+31)⊃html5∆tagList)←5⍴'title'
((⎕IO+32)⊃html5∆tagList)←5⍴'table'
((⎕IO+33)⊃html5∆tagList)←5⍴'thead'


(⊂'html') xml∆MkTagFns ¨ html5∆tagList
(⊂'html') xml∆MkClosedTagFns ¨ html5∆closedTagList

∇Z←html⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'html.txt'
  Z←Z⍪'Download'        'https://sourceforge.net/p/apl-library/code/ci/master/tree/html.apl'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L1'
  Z←Z⍪'Provides'        ''
  Z←Z⍪'Requires'        ''
  Z←Z⍪'Version'                  '0 1 1'
  Z←Z⍪'Last update'         '2018-11-23'
∇

