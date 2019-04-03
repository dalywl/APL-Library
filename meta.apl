#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ Template for meta function for each workspaces
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
∇Z←meta⍙metadata
Z←0 2⍴⍬
Z←Z⍪'Author'          'Bill Daly'
Z←Z⍪'BugEmail'        'bugs@dalywebandedit'
Z←Z⍪'Documentation'   'apl-library.info'
Z←Z⍪'Download'        'https://sourceforge.net/projects/apl-library'
Z←Z⍪'License'         'GPL v3'
Z←Z⍪'Portability'     ('L1' 'L2' 'L3']?3
Z←Z⍪'Provides'        ''
Z←Z⍪'Requires'        ''
Z←Z⍪'Version'         '0 0 1'
∇
