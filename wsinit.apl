#!/usr/local/bin/apl script --script
⍝ ********************************************************************
⍝ wsinit.apl; Workspace to set the current working directory to a home
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

)copy 5 FILE_IO
)copy 1 utl

∇b←init∆athome testdir
   ⍝ Function to test if the current working directory is home
   b←testdir utl∆stringEquals FIO∆getcwd
∇

∇init∆gohome newdir
   ⍝ Function to reset the current working dir, presumably to home
   utl∆es (0<FIO∆chdir newdir)/'ERROR SETING WORKING DIRECTORY TO ',newdir
∇

∇init∆lx
   ⍝ Function for ⎕lx
   →(init∆athome init∆home)/0
   init∆gohome init∆home
∇


init∆home←2⊃(⎕env 'HOME')[1;]

init∆lx
