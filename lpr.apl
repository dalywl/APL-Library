#! /usr/local/bin/apl --script
 ⍝ ********************************************************************
 ⍝   $Id: $
 ⍝ $desc: Workspace to print a text array $
⍝ ********************************************************************

)copy 1 utl
)copy 1 lex
)copy 5 FILE_IO

∇ err←printer lpr txt;cmd;pipe;size;print_width
  ⍝ Function to print a text. printer, the left argument is a lexicon,
  ⍝ see lpr∆USLetter below.
  ⍎(2=≡txt)/'txt←utl∆clean ¨ ⊂[2]txt'
  print_width←(printer lex∆lookup 'pageWidth') - (printer lex∆lookup 'leftMargin') - printer lex∆lookup 'rightMargin'
  cmd←'pr --form-feed --length=',⍕printer lex∆lookup 'pageLength'
  cmd←cmd,' --indent=',⍕printer lex∆lookup 'leftMargin'
  cmd←cmd,' --page-width=',⍕print_width
  cmd←cmd,'|lpr  -P ',printer lex∆lookup 'printer'
  pipe←'w' FIO∆popen cmd
  size←{⍵ FIO∆fwrite_utf8 pipe}¨txt
  err←FIO∆pclose pipe
∇

∇ err←printer lpr∆html html;cmd;pipe;size
  ⍝ Function to print text marked up with html.
  cmd←'html2ps | lpr -P',printer lex∆lookup 'printer'
  pipe←'w' FIO∆popen cmd
  size←html FIO∆fwrite_utf8 pipe
  err←FIO∆pclose pipe
∇


∇ printAttr←lpr∆USLetter printer
  ⍝ Function returns default page attributes for 12 point type on a US
  ⍝ letter with margins of 1/2 inch. Printer is the name (that cups
  ⍝ understands) for your printer.
  printAttr←(lex∆init)lex∆assign 'pageWidth' 85
  printAttr←printAttr lex∆assign 'pageLength' 66
  printAttr←printAttr lex∆assign 'topMargin' 3
  printAttr←printAttr lex∆assign 'bottomMargin' 3
  printAttr←printAttr lex∆assign 'leftMargin' 5
  printAttr←printAttr lex∆assign 'rightMargin' 5
  printAttr←printAttr lex∆assign 'printer' printer
∇

∇printAttr←lpr∆a4 printer;stats
  ⍝ Function returns pinter attributes for a4 paper. Printer is the
  ⍝ name (that cups understands) for your printer.
  stats← utl∆round 6 10 × 2 lpr∆din 'A4'
  printAttr←(lex∆init)lex∆assign (⊂'pageWidth'), stats[2]
  printAttr←printAttr lex∆assign (⊂'pageLength'),stats[1]
  printAttr←printAttr lex∆assign 'topMargin' 3
  printAttr←printAttr lex∆assign 'bottomMargin' 3
  printAttr←printAttr lex∆assign 'leftMargin' 5
  printAttr←printAttr lex∆assign 'rightMargin' 5
  printAttr←printAttr lex∆assign 'printer' printer
∇

∇Z←A lpr∆din B;H0;Area;Series;Scale
⍝⍝ return the heigth and the width of a DIN paper size
⍝
⍝ A: the result unit desired:
⍝    1: return sizes in mm
⍝    2: return sizes in inches (1 inch = 25.4mm)
⍝    3: return sizes in points (1 inch = 72 points)
⍝
⍝ B: the DIN series and scale, e.g. 'A4' for DIN A4 sheets
⍝
⍝ Example: 1 DIN 'A4' returns 297.3017788 210.2241038, which is normally
⍝ rounded to full millimeters: 297÷210 mm²
⍝
⍝ The DIN A series is recursively defined by:
⍝
⍝ 1. the area, i.e. height×width of DIN A0, B0, C0, and D0 sheets
⍝ are 2⋆0, 2⋆0.5, 2⋆0.25 and 2⋆¯0.25 respectively.
⍝
⍝ 2. all formats of a series have the same aspect ratio width÷height.
⍝
⍝ 3. height(An+1) = width(An) ÷ 2
⍝
⍝ that is cutting (or folding) an An sheet at the middle of the longer side
⍝ gives two An+1 sheets.
⍝
⍝ Combining 2. and 3. gives an aspect ratio of 2⋆÷2 = 1.41
⍝
⍝ According to: DIN 476, EN ISO 216
⍝
 (Series Scale)←B            ⍝ split e.g. 'A4' into Series 'A' and Scale '4'
 Area←2⋆(↑(-/⎕UCS Series,'A')↓0 2 1 ¯1)÷4   ⍝ area of A0, B0, C0, or D0 in m²
⍝ (Series,'0 area:') Area 'm²'
 H0←(Area×2⋆÷2)⋆÷2            ⍝ height of an A0, B0, C0, or D0 sheet in m
⍝ (Series,'0 height:') H0 'm'
 Z←H0÷2⋆(-/⎕UCS Scale,'0')÷2     ⍝ height of an An, Bn, Cn, or Dn sheet in mm
 Z←Z×↑A↓0 1000, 10000 720000÷254   ⍝ size in mm, inch, and points
 Z←Z,Z÷2⋆÷2                     ⍝ height → height, width
∇

∇Z←lpr⍙metadata                                   
  Z←0 2⍴⍬                                             
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   ''
  Z←Z⍪'Download'        'https://sourceforge.net/projects/apl-library/'
  Z←Z⍪'License'         'GPL version 3'
  Z←Z⍪'Portability'     'L3'
  Z←Z⍪'Provides'        'Functions to print text'
  Z←Z⍪'Requires'        'utl lex FILE_IO'
  Z←Z⍪'Version'                  '0 1 2'
  Z←Z⍪'Last update'         '2019-02-11'
∇
