#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ cfg_test.apl Workspace to test cfg_file
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

)copy 1 cfg_file
)copy 1 assert

assert∆setup 't1←cfg∆parse_file ''/home/dalyw/apl-library/test-data/sample.ini'''

'topsecret.server.com' 'bitbucket.org' 'DEFAULT' assert∆toScreen 'lex∆keys t1'

'ServerAliveInterval' 'Compression' 'CompressionLevel' 'ForwardX11' assert∆toScreen 'lex∆keys t1 lex∆lookup ''DEFAULT'''

'yes' assert∆toScreen '(t1 lex∆lookup ''DEFAULT'') lex∆lookup ''Compression'''

assert∆setup 't1←cfg∆parse_file ''/home/dalyw/apl-library/test-data/sample2.ini'''

'IMC_10i2' '<Generic Network Card>' 'Ports' assert∆toScreen 'lex∆keys t1'

'PORTS' 'NAME' 'PROTOCOL1' 'PORTNUMBER1' 'SNMP1' assert∆toScreen 'lex∆keys t1 lex∆lookup ''<Generic Network Card>'''

'Generic Network Card' assert∆toScreen '(t1 lex∆lookup ''<Generic Network Card>'') lex∆lookup ''NAME'''
