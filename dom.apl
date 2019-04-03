#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ dom.apl Workspace to implement the Document Object Model $
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
⍝ ********************************************************************


)copy 1 utl
)copy 1 lex
)copy 5 FILE_IO

dom∆ELEMENT_NODE←1

dom∆ATTRIBUTE_NODE←2

dom∆TEXT_NODE←3

dom∆CDATA_SECTION_NODE←4

dom∆ENTITY_REFERENCE_NODE←5

dom∆ENTITY_NODE←6

dom∆PROCESSING_INSTRUCTION_NODE←7

dom∆COMMENT_NODE←8

dom∆DOCUMENT_NODE←9

dom∆DOCUMENT_TYPE_NODE←10

dom∆DOCUMENT_FRAGMENT_NODE←11

dom∆NOTATION_NODE←12

dom∆type∆DESC←12⍴0
dom∆type∆DESC[1]←⊂'Element'
dom∆type∆DESC[2]←⊂'Attribute'
dom∆type∆DESC[3]←⊂'Text'
dom∆type∆DESC[4]←⊂'CDATA section'
dom∆type∆DESC[5]←⊂'Entity reference'
dom∆type∆DESC[6]←⊂'Entity'
dom∆type∆DESC[7]←⊂'Processing instruction'
dom∆type∆DESC[8]←⊂'Comment'
dom∆type∆DESC[9]←⊂'Document'
dom∆type∆DESC[10]←⊂'Document type'
dom∆type∆DESC[11]←⊂'Document fragment'
dom∆type∆DESC[12]←⊂'Notation'

dom∆TRUE←'True'

dom∆FALSE←'False'

dom∆defaultImplementation←'THIS WORKSPACE'

dom∆error∆NOT_FOUND←'NOT FOUND'


∇attr←parent dom∆createAttribute name
   ⍝ Function creates an element's attribute
   attr←dom∆createNode name
   attr[2]←⊂(⊃attr[2]) lex∆assign 'nodeType' dom∆ATTRIBUTE_NODE
∇

∇node← dom∆createComment txt
   node← dom∆createNode 'Comment'
   node[2]←⊂(⊃node[2]) lex∆assign 'nodeType' dom∆COMMENT_NODE
   node[2]←⊂(⊃node[2]) lex∆assign 'nodeValue' txt
∇

∇docNode← dom∆createDocument rootName;rootNode;typeNode;uri;dn
   ⍝ Function to create a document. If root name is a nested vector
   ⍝ rootName[1] is the document qualifiedName and rootName[2] is its
   ⍝ URI. Left argument docType is optional and if ommitted will be deduced.
  docNode← dom∆createNode 'Document'
  docNode←docNode dom∆node∆setNodeType dom∆DOCUMENT_NODE
  →0
∇

∇documentTypeNode← dom∆createDocumentType rootName;dt
   →((2=≡rootName)∧2=⍴rootName)/create
   rootName←' ' utl∆split rootName
 create:
   documentTypeNode←dom∆createNode ⊃rootName[1]
   dt←(⊃documentTypeNode[2]) lex∆assign 'nodeType' dom∆DOCUMENT_TYPE_NODE
   dt←dt lex∆assign (⊂'nodeValue'), ⊂rootName[1]
   →(1=⍴rootName)/end
   dt←dt lex∆assign 2↑1↓rootName,dom∆TRUE
end:
  documentTypeNode[2]←⊂dt
   →0
∇

∇elementNode← dom∆createElement name;en
   elementNode← dom∆createNode name
   en←(⊃elementNode[2]) lex∆assign 'nodeType' dom∆ELEMENT_NODE
   elementNode[2]←⊂en lex∆assign (⊂'attributes'),⊂0⍴0
∇

∇node←dom∆createTextNode txt;attrs
  node← dom∆createNode '#text#'
  attrs←(⊃node[2]) lex∆assign 'nodeType' dom∆TEXT_NODE
  node[2]←⊂attrs lex∆assign 'nodeValue' txt
∇

∇pi←dom∆createProcessingInstruction txt;b;target;data;pn
  ⍝ Function creates processor specific instructions node
  txt←utl∆clean txt
  target←(b←∧\txt≠' ')/txt
  data←1↓(~b)/txt
  pi← dom∆createNode target
  pn←(⊃pi[2]) lex∆assign 'nodeType' dom∆PROCESSING_INSTRUCTION_NODE
  pn←pn lex∆assign 'target' target
  pi[2]←⊂pn lex∆assign 'data' data
∇

∇node← dom∆createNode name
   ⍝ Fn creates a DOM node
   node←lex∆init
   node←node lex∆assign 'nodeName' name
   node←node lex∆assign 'nodeValue' ' '
   node←node lex∆assign 'nodeType' 0
   node←(⊂0⍴0),⊂node
∇

∇new←node dom∆node∆appendChild child;children
  ⍝ Function to add a child to the end of our vector
  new←node
  children←(⊃node[1]),⊂child
  new[1]←⊂children
   
∇

∇new←node dom∆node∆prependChild child; children
  ⍝ Function to add a child tot he begining of our vector
  new←node
  children←(⊂child),1⊃node
  new[1]←⊂children
∇

∇n←dom∆node∆nodeName node
   n←(⊃node[2])lex∆lookup 'nodeName'
∇

∇new←node dom∆node∆setNodeName name
  new←node[1],⊂(⊃node[2]) lex∆assign 'nodeName' name
∇

∇t←dom∆node∆nodeType node
   t←(⊃node[2]) lex∆lookup 'nodeType'
∇

∇new←node dom∆node∆setNodeType type
  new←node[1],⊂(⊃node[2]) lex∆assign 'nodeType' type
∇

∇v←dom∆node∆nodeValue node
   v←(⊃node[2])lex∆lookup 'nodeValue'
∇

∇new←node dom∆node∆setNodeValue value
  new←node[1],⊂(⊃node[2]) lex∆assign 'nodeValue' vale
∇

∇o←dom∆node∆ownerDocument node
   o←(⊃node[2]) lex∆lookup 'ownerDocument'
∇

∇new←node dom∆node∆setOwenerDocument doc
  new←node[1],⊂(⊃node[2]) lex∆assign 'ownerDocument' doc
∇

∇ch←dom∆node∆children node
  ch←⊃node[1]
∇

∇b←dom∆node∆hasChildren node
  b←0≠1↑⍴1⊃node
∇

∇new←node dom∆node∆setChildren children
  ⍝ Out with the old in with the new.  This function replaces what
  ⍝ ever children there are with an new list.
  new←(⊂children),node[2]
∇

∇attrs←dom∆node∆attributes node
  ⍝ Function returns a vector of attributes
  attrs←(⊃node[2]) lex∆lookup 'attributes'
∇

∇new←node dom∆node∆setAttribute item;attr;cix;attr_vector
   ⎕es(1≠⍴⍴item)/'RARG NOT AN ATTRIBUTE'
   →((1=≡item)∨1=⍴item)/single
 double:
   attr←node dom∆createAttribute ⊃item[1]
   attr[2]←⊂(⊃attr[2]) lex∆assign (⊂'nodeValue'),item[2]
   →end
 single:
   →(2≠≡item)/s2
   item←⊃item
 s2:
   attr←dom∆createAttribute item
   attr[2]←⊂(⊃attr[2]) lex∆assign 'nodeValue' dom∆TRUE
   →end
end:
  attr_vector←((⊃node[2]) lex∆lookup 'attributes'),⊂attr
  new←node[1],⊂(⊃node[2]) lex∆assign 'attributes' attr_vector
∇

∇xml←dom∆node∆toxml node;next;nextix
  ⍝ Function returns an xml text vector for a node
  →(elm,attr,txt,cdata,ref,ent,pi,com,doc,type,frag,note)[dom∆node∆nodeType node]
elm:				⍝ Element
  xml←'<',(dom∆node∆nodeName node)
  xml←xml,dom∆node∆toxml ¨ dom∆node∆attributes node
  ⍎(~dom∆node∆hasChildren node)/'xml←xml,''/>''◊→0'
  xml←xml,'>'
  xml←xml,∊dom∆node∆toxml ¨ dom∆node∆children node
  xml←xml,'</',(dom∆node∆nodeName node),'>'
  →0
attr:				⍝ Attribute
  →(dom∆TRUE utl∆stringEquals dom∆node∆nodeValue node)/single_attr
double_attr:
  xml←' ',(dom∆node∆nodeName node),'="',(dom∆node∆nodeValue node),'"'
  →0
single_attr:
  xml←' ',dom∆node∆nodeName node
  →0
txt:				⍝ Text
  xml←dom∆node∆nodeValue node
  →0
cdata:				⍝ CDATA
  xml←dom∆node∆nodeValue node
  →0
ref:				⍝ Entity Reference
  xml←'NOT IMPLEMENTED'
  →0
ent:				⍝ Entity
  xml←'NOT IMPLEMENTED'
  →0
pi:				⍝ Processing Instruction
  xml←'<?',(dom∆pi∆target node),' ',(dom∆pi∆data node),'?>'
  →0
com:				⍝ Comment Node
  xml←'<!--',(dom∆node∆nodeValue node),'-->'
  →0
doc:				⍝ Document node
  xml← ∊dom∆node∆toxml ¨ dom∆node∆children node
  →0
type:				⍝ Document Type node
  xml←'<!DOCTYPE ',(dom∆node∆nodeName node)
  →(~(2⊃node) lex∆haskey 'SYSTEM')/typePublic
  xml←xml,' SYSTEM ',(2⊃node)lex∆lookup 'SYSTEM'
typePublic:
  →(~(2⊃node) lex∆haskey 'PUBLIC')/typeEnd
  xml←xml,' PUBLIC ',(2⊃node)lex∆lookup 'PUBLIC'
typeEnd:
  xml←xml,'>'
  →0
frag:				⍝ Document fragment
  xml←'NOT IMPLEMENTED'
  →0
note:				⍝ Notation
  xml←'NOT IMPLEMENTED'
  →0
∇

∇child←node dom∆node∆getChild n
  ⍝ Returns the nth child of node
  child←⊃(dom∆node∆children node)[n]
∇

∇children← dom∆node∆getChildren node
  children←1⊃node
∇

∇node←dom∆document∆rootElement doc;children;i;lb
  ⍝ Function returns the root element of a document
  children←dom∆node∆children doc
  i←1
  lb←((⍴children)⍴st),ed
st:
  node←⊃children[i]
  →(dom∆ELEMENT_NODE=dom∆node∆nodeType node)/0
  →lb[i←i+1]
ed:
  node←dom∆createElement 'MALFORMED DOCUMENT'
  →0
∇

∇doc←doc dom∆document∆setRootElement rootElm;children;i;lb
  ⍝ Function replaces the root element of a document. Function should
  ⍝ be called after updating or changing nodes of a document.
  i←1
  lb←((⍴children←⊃doc[1])⍴st),ed
st:
  →(~dom∆ELEMENT_NODE=dom∆node∆nodeType ⊃children[i])/next
  children[i]←⊂rootElm
next:
  →lb[i←i+1]
ed:
  doc[1]←⊂children
∇

∇type←dom∆document∆getDocumentType doc;children
  ⍝ Function returns the document type node.
  children←dom∆node∆getChildren doc
  type←(dom∆DOCUMENT_TYPE_NODE = dom∆node∆nodeType¨children)/children
∇

∇doc←doc dom∆document∆setDocumentType typeNode;children;i;lb
  ⍝ Function replaces the root element of a document. Function should
  ⍝ be called after updating or changing nodes of a document.
  i←1
  lb←((⍴children←⊃doc[1])⍴st),ed
st:
  →(~dom∆DOCUMENT_TYPE_NODE=dom∆node∆nodeType ⊃children[i])/next
  children[i]←⊂typeNode
next:
  →lb[i←i+1]
ed:
  doc[1]←⊂children
∇

∇nl←name dom∆document∆getElementsByTagName node;children;child;lb
  ⍝ Function returns a NodeList of elements with the give name
  →(name utl∆stringEquals dom∆node∆nodeName node)/ahit
  nl←⊂dom∆createNodeList
  →ch
ahit:
  nl←(⊂node),dom∆createNodeList
  →ch
ch:
  →(0=⍴children←dom∆node∆getChildren node)/0
  child←1
  lb←((⍴children)⍴st),end
st:
  nl←nl,name dom∆document∆getElementsByTagName child⊃children
  nl←(0≠∊⍴¨nl)/nl
  →lb[child←child+1]
end:
∇

⍝ NodeList functions

∇nl←dom∆createNodeList
  nl←0⍴0
∇

∇length←dom∆nodeList∆length list
  length←''⍴⍴list
∇

∇node←list dom∆nodeList∆item item
  ⍝ Returns the itemth
  ⍎(item>⍴list)/'item←0⍴0 ◊ →0'
  node←item⊃list
∇

∇new←list dom∆nodeList∆appendNode node
  ⍝ Function appends a node to a node list
  →(0≠⍴list)/append
  list←1⍴⊂node
  →0
append:
  new←list,⊂node
∇

⍝ Parse functions

∇doc←dom∆parse txt;nodes;i;lb;type;nt;docName
  ⍝ Function to parse an xml file.
  doc←dom∆createDocument '⍙parsed⍙'
  nodes←(1⍴⊂doc) dom∆parse∆nextNode txt
  doc←doc dom∆parse∆postDocumentChild 1↓nodes
∇

∇node←doc dom∆parse∆comment txt
  ⍝ Helper function to dom∆parse to parse the text of a comment or
  ⍝ doctype tag.
  →(∧/'!DOCTYPE'=8↑txt)/doc_type
comment:
  node←dom∆createComment txt
  →0
doc_type:
  txt←' ' utl∆split 9↓txt
  node←dom∆createDocumentType ⊃txt[1]
  →(1=⍴txt)/0
  node←node dom∆node∆setNodeValue 1↓txt
∇

∇node←doc dom∆parse∆elementName name;lb;curAttr;b;i
  ⍝ subroutine of dom∆parse to parse the text between < and >.
  name←utl∆clean name
  b←(name=' ')∧~≠\name∊'''"'
  name←b dom∆parse∆elementNameHelper name
  node←dom∆createElement ⊃name[1]
  →(0=⍴name←1↓name)/ed
  attr←'=' utl∆split ¨ name
  lb←((⍴attr)⍴st),ed
  i←1
st:
  curAttr←⊃attr[i]
  curAttr[2]←⊂1↓¯1↓⊃curAttr[2]
  node←node dom∆node∆setAttribute curAttr
  →lb[i←i+1]
ed:
∇

∇ary←b dom∆parse∆elementNameHelper txt;d;c
  ⍝ Function recursively breaks the node name in name and attributes.
  ⍝ The left argument is a boolean vector showing delimited points and
  ⍝ the right the text to be split.
  →(0=+/b)/end
  d←~c←∧\~b
  ary←(⊂c/txt), (1↓d/b) dom∆parse∆nodeNameHelper 1↓d/txt
  →0
end:
  ary←1⍴⊂txt
∇

∇doc←nodes dom∆parse∆nextNode txt;lx;name;thisNode;b;ntxt;closedElm;docName
  ⍝ Helper function to parse xml. nodes is a vector of nodes with
  ⍝ nodes[1] the document we're parsing. txt is the text we're
  ⍝ currently parsing
  docName←dom∆node∆ownerDocument ⊃nodes[1]
  b←(∧/txt[⍳3]='<!-'),(∧/txt[⍳3]='<!D'),(∧/txt[1 2]='</'),(∧/txt[1 2]='<?'),txt[1]='<',1
  →b/(commentNode,doctypeNode,closeElm,proc,openElm,txtNode)
txtNode:			⍝ Create a text node
  ntxt←(b←∧\txt≠'<')/txt
  txt←(~b)/txt
  thisNode←dom∆createTextNode ntxt
  doc←(nodes,⊂thisNode)
  →end
proc:				⍝ Processing Instruction
  ntxt←¯1↓(b←∧\'>'≠txt)/txt←2↓txt
  txt←1↓(~b)/txt
  thisNode←dom∆createProcessingInstruction ntxt
  doc←nodes,⊂thisNode
  →end
openElm:			⍝ Open an element node
  ntxt←(b←∧\'>'≠txt)/txt←1↓txt
  txt←1↓(~b)/txt
  closedElm←'/'=¯1↑ntxt
  ntxt←(-closedElm)↓ntxt
  thisNode←docName dom∆parse∆elementName ntxt
  doc←nodes,⊂thisNode
  →(~closedElm)/end
  doc←doc dom∆parse∆postChild dom∆node∆nodeName thisNode
  →end
closeElm:			⍝ Close an element node
  ntxt←(b←∧\'>'≠txt)/txt←2↓txt
  txt←1↓(~b)/txt
  doc←nodes dom∆parse∆postChild ntxt
  →end
commentNode:			⍝ Create a comment or document type node
  ntxt←¯2↓(b←∧\'>'≠txt)/txt←4↓txt
  txt←1↓(~b)/txt
  closedElm←'/'=¯1↑ntxt
  doc←nodes,⊂docName dom∆parse∆comment (-closedElm)↓ntxt
  →(end,closeElm)[1+closedElm]
doctypeNode:
  ntxt←10↓(b←∧\txt≠'>')/txt
  txt←1↓(~b)/txt
  thisNode←dom∆createDocumentType ntxt
  doc←nodes,⊂thisNode
  →end
end:
  →((0=⍴txt)∨∧/txt∊' ',⎕tc)/0
  ⍝'doc←0⍴'' ''◊→0'
  doc←doc dom∆parse∆nextNode txt
∇

∇node←doc dom∆parse∆nodeName txt;ary;b;lb;attr;i
  ⍝ Function to parse text of a tag and return a dom node.
  b←(txt=' ')∧~≠\txt='"'
  ary←b dom∆parse∆nodeNameHelper txt
  node←dom∆createElement ⊃ary[1]
  lb←((⍴ary)⍴st),ed
  i←2
  →lb
st:
  attr←'=' utl∆split ⊃ary[i]
  attr[2]←⊂1↓¯1↓⊃attr[2]
  node←node dom∆node∆setAttribute attr
  →lb[i←i+1]
ed:
  →0
∇

∇ary←b dom∆parse∆nodeNameHelper txt;d;c
  ⍝ Function recursively breaks the node name in name and attributes.
  ⍝ The left argument is a boolean vector showing delimited points and
  ⍝ the right the text to be split.
  →(0=+/b)/end
  d←~c←∧\~b
  ary←(⊂c/txt), (1↓d/b) dom∆parse∆nodeNameHelper 1↓d/txt
  →0
end:
  ary←1⍴⊂txt
∇

∇new←doc dom∆parse∆postDocumentChild nodes;curNode;nodeType;rootElmName;typeNode
  ⍝ Final assembly.  Colapse all nodes into doc, the document, recursively.
  new←doc
  →(0=⍴nodes)/0
  new←new dom∆parse∆postDocumentChild ¯1↓nodes
  new←new dom∆node∆appendChild curNode←(⍴nodes)⊃nodes
  →(dom∆ELEMENT_NODE≠dom∆node∆nodeType curNode)/0
  new←new dom∆node∆setNodeName dom∆node∆nodeName curNode
  →0
∇
⍝   curNode←1⊃nodes
⍝   nodeType←dom∆node∆nodeType curNode
⍝   →((nodeType=dom∆DOCUMENT_TYPE_NODE),(nodeType=dom∆TEXT_NODE),(nodeType=dom∆ELEMENT_NODE),nodeType=dom∆PROCESSING_INSTRUCTION_NODE,1)/type,txt,elm,proc,oops
⍝ type:
⍝   doc←doc dom∆document∆setDocumentType curNode
⍝   ⍝doc←doc dom∆node∆setNodeName dom∆node∆nodeName curNode
⍝   →ed
⍝ txt:
⍝   doc←doc dom∆node∆appendChild curNode
⍝ elm:
⍝   rootElmName←dom∆node∆nodeName curNode
⍝   ⍝typeNode←dom∆document∆getDocumentType doc
⍝   ⍝typeNode←typeNode dom∆node∆setNodeName rootElmName
⍝   ⍝doc←doc dom∆document∆setDocumentType typeNode
⍝   doc←doc dom∆node∆setNodeName rootElmName
⍝   doc←doc dom∆document∆setRootElement curNode
⍝   →ed
⍝ proc:
⍝   doc←doc dom∆node∆appendChild,curNode
⍝   →ed
⍝ oops:
⍝   ⎕es 'ERROR ASSEMBLING XML DOCUMENT'
⍝   →0
⍝ ed: →(1=⍴nodes)/out
⍝   doc←(1↓nodes) dom∆parse∆postDocumentChild doc
⍝ out:
⍝   new←doc


∇new←nodes dom∆parse∆postChild name;thisNode
  ⍝ Function recursively looks a parent node with nodeName = name,
  ⍝ posts the  child Nodes to the parent and removes the child nodes.
  thisNode←⊃''⍴¯1↑ new←nodes
  →(dom∆DOCUMENT_NODE=dom∆node∆nodeType thisNode)/end
  →(name utl∆stringEquals dom∆node∆nodeName thisNode)/end
look:
  new←(¯1↓new) dom∆parse∆postChild name
  new[''⍴⍴new]←⊂(⊃new[''⍴⍴new]) dom∆node∆appendChild thisNode
end:
  →0
∇

⍝ Processing instructions are dom∆pi

∇target←dom∆pi∆target node
  target←(⊃node[2]) lex∆lookup 'target'
∇

∇data←dom∆pi∆data node
  data←(⊃node[2]) lex∆lookup 'data'
∇

∇Z←dom⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@DalyWebAndEdit.com'
  Z←Z⍪'Documentation'   'file:\\doc/dom.txt'
  Z←Z⍪'Download'        'https://sourceforge.net/projects/apl-library/files/latest/download?source=directory'
  Z←Z⍪'License'         'GPL'
  Z←Z⍪'Portability'     'L2'
  Z←Z⍪'Provides'        'dom'
  Z←Z⍪'Requires'        'util lex FILE_IO'
  Z←Z⍪'Version'                  '0 2 3'
  Z←Z⍪'Last update'         '2019-02-11'
∇
