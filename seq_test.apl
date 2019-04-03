#! /usr/local/bin/apl --script
 ⍝ ********************************************************************
 ⍝   $Id: $
 ⍝ $desc: Unit test for seq $
 ⍝ ********************************************************************
⍝ Copyright (C) 2017 2018 Bill Daly

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


)load 1 seq
)copy 1 assert

1 assert∆toScreen 'seq∆next ''INV'''

'INV0002' assert∆toScreen 'seq∆posting∆ref ''INV'''

'INV03' assert∆toScreen '''00'' seq∆posting∆ref ''INV'''

'CR0001' assert∆toScreen 'seq∆posting∆ref ''CR'''

'INV04' assert∆toScreen '''00'' seq∆posting∆ref ''INV'''

'CR0002' assert∆toScreen 'seq∆posting∆ref ''CR'''

'CHK' seq∆set 10000

'CHK10001' assert∆toScreen '''00000'' seq∆posting∆ref ''CHK'''

⍝)off
