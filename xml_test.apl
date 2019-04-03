#! /usr/local/bin/apl --script
 ⍝ ********************************************************************
 ⍝   $Id: $
 ⍝ $desc: Routines to test workspace xml $
⍝ ********************************************************************

)copy 1 xml
)copy 1 assert

⍝ Data

tcss1← ⎕inp 'ecss1'
body {
    font-family: sanserif;
    font-size: 12pt;
    }

nav {
    float: left;
}

footer {
    font-size: 8pt;
    text-align: center;
}

header {
    height: 120px;
}

header img {
    float: left;
}

header h1 {
    margin-right: 2em;
    text-align: right;
}

header h2 {
    margin-right: 2em;
    text-align: right;
}

article {
    margin-left: 12em;
}

p.footnote {
    font-size: 8pt;
}

article li {
    margin-bottom: 1em;
}

div.comment {
    margin-left: 12em;
}

section {
    margin: 0.5em;
}

figure.right {
    float: right;
    width: 250px;
}

figure.left {
    float: left;
    width: 250px;

}

figure.landscape {
    float: right;
    width: 400px;
}

figure.center {
    width: 250px;
    clear: both;
}

figcaption {
    text-align: center;
    font-style: italic;
    font-size: small;
}

p.bio {
    margin-left: 5em;
    font-style: italic;
}

ecss1

tcss2←'body { background-color: blue; }'

tresult2←(lex∆init)lex∆assign (⊂'body'),⊂ (lex∆init)lex∆assign 'background-color' 'blue'

(lex∆keys tresult2) assert∆toScreen 'lex∆keys xml∆parseStylesheet tcss2'

⍝ This thing doesn't work as lex∆values returns a lexicon:
⍝ (lex∆values tresult2) assert∆toScreen 'lex∆values xml∆parseStylesheet tcss2'

'one="two"' assert∆toScreen '''one'' xml∆lex2attr ''two'''

'one="2"' assert∆toScreen '''one'' xml∆lex2attr 2'

'test∆first' assert∆toScreen '''test'' xml∆MkTagFns ''first'''

'<first>A message</first>' assert∆toScreen 'test∆first ''A message'''

'test∆second' assert∆toScreen '''test'' xml∆MkClosedTagFns ''second'''

'<second/>' assert∆toScreen 'test∆second lex∆init'

test∆thirdAttr←((lex∆init)lex∆assign 'one' 'two')lex∆assign 'three' 4

'<third one="two" three="4"/>' assert∆toScreen 'test∆thirdAttr xml∆closed ''third'''

'</fourth>' assert∆toScreen 'xml∆end ''fourth'''

'<fourth one="two" three="4">' assert∆toScreen 'test∆thirdAttr xml∆start ''fourth'''

⍝)off

