#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ version_history; script to setup workspace
⍝ Copyright (C) 2018 Bill Daly

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

)copy 1 version_control

  

ver∆files←(ver∆files∆init) ver∆files∆add 'assert.apl' '0 0 2'  ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'cl.apl' '0 0 2' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'convert2utl.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'date.apl' '0 0 5' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'dom.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'export.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'finance.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'html.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'import.apl' '0 0 2' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'lex1.apl' '0 0 3' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'lex.apl' '0 0 4' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'lpr.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'prompt.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'seq.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'stat.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'tb.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'utf8.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'utl.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'version_control.apl' '0 0 1' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'wp.apl' '0 0 3' ,⊂2018 10 24
ver∆files←ver∆files ver∆files∆add 'xml.apl' '0 0 1' ,⊂2018 10 24

∇vhist∆write fnames;ix;lb;src
  ix←1
  lb←((1↑⍴fnames)⍴st),ed
st:
  src←2 ver∆new ix⊃fnames
  src utf8∆write ix⊃fnames
  →lb[ix←ix+1]
ed:
∇

