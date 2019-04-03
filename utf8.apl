#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ utf8 workspace to read and write utf8 files
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

∇err←txt utf8∆write fname;fh;size
⍝ Function to write utf8 files
fh ←'w' ⎕FIO[3] fname
size←txt ⎕FIO[23] fh
err←⎕FIO[4] fh
∇

∇txt← utf8∆read fname;fh;size;stat
  ⍝ Function to read utf8 files
  fh←'r' ⎕FIO[3] fname
  stat←⎕FIO[18] fh
  txt←19 ⎕cr ⎕ucs stat[8] ⎕FIO[6] fh
  ⍞←⎕FIO[4] fh
∇

∇Z←utf8⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'commments in file.'
  Z←Z⍪'Download'        'https://sourceforge.net/projects/apl-library'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L3'
  Z←Z⍪'Provides'        'Functions to read and write utf8 files.'
  Z←Z⍪'Requires'        ''
  Z←Z⍪'Version'                  '0 1 2'
  Z←Z⍪'Last update'         '2019-02-11'
∇

