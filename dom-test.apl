#! /usr/local/bin/apl --script
⍝ dom-test, a workspace to test the document object model
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


)copy 1 dom
)copy 1 assert
)copy 1 utf8

∇pg←dom∆test∆hello;head;body;tag;root
  ⍝ Function to create an hello world web page.
  pg←dom∆createDocument 'html'
  pg←pg dom∆node∆appendChild dom∆createDocumentType 'html'
  root←dom∆createElement 'html'
  tag←(dom∆createElement 'title') dom∆node∆appendChild dom∆createTextNode 'Hello'
  root←root dom∆node∆appendChild (dom∆createElement 'head') dom∆node∆appendChild tag
  tag←(dom∆createElement 'h1') dom∆node∆appendChild dom∆createTextNode 'Hello world!'
  root←root dom∆node∆appendChild (dom∆createElement 'body') dom∆node∆appendChild tag
  pg←pg dom∆node∆appendChild root
∇

'<!DOCTYPE html><html><head><title>Hello</title></head><body><h1>Hello world!</h1></body></html>'assert∆toScreen 'dom∆node∆toxml dom∆test∆hello'

∇xml←dom∆test∆hello2 ;rootElm;headElm;bodyElm;contentElm;curNode
  xml←dom∆createDocument 'html'
  xml←xml dom∆node∆appendChild dom∆createDocumentType 'html'
  rootElm ← dom∆createElement 'html'
  headElm ← dom∆createElement 'head'
  curNode ← dom∆createElement 'title'
  curNode ← curNode dom∆node∆appendChild dom∆createTextNode 'Hello World II'
  headElm ← headElm dom∆node∆appendChild curNode
  rootElm ← rootElm dom∆node∆appendChild headElm
  bodyElm ← dom∆createElement 'body'
  curNode← ( dom∆createElement 'h1') dom∆node∆appendChild dom∆createTextNode 'Hello'
  bodyElm ← bodyElm dom∆node∆appendChild curNode
  curNode ← dom∆createElement 'p'
  curNode ← curNode dom∆node∆setAttribute 'class' 'special'
  curNode ← curNode dom∆node∆setAttribute 'id' '001'
  curNode ← curNode dom∆node∆appendChild dom∆createTextNode 'And now more content than ever.'
  bodyElm ← bodyElm dom∆node∆appendChild curNode
  rootElm ← rootElm dom∆node∆appendChild bodyElm
  xml←xml dom∆node∆appendChild rootElm
∇

'<!DOCTYPE html><html><head><title>Hello World II</title></head><body><h1>Hello</h1><p class="special" id="001">And now more content than ever.</p></body></html>' assert∆toScreen 'dom∆node∆toxml dom∆test∆hello2'

∇b←dom∆test∆parse xml;interests
  ⍝ Function to test reading and parsing an xml file.
  interests←'interests' dom∆document∆getElementsByTagName xml
  b←'interests' utl∆stringEquals dom∆node∆nodeName 1⊃ interests
  b←b∧dom∆ELEMENT_NODE = dom∆node∆nodeType 1⊃interests
∇

'dom∆test∆parse resume' assert∆nil∆toScreen 'resume←dom∆parse utf8∆read ''/home/dalyw/apl-library/test-data/2018-all.resume'''
