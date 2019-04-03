#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ cl_test, unit testing form workspace cl
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

)copy 1 cl

⍝ cl is a lexicon implemented as a apl component file (5
⍝ APLComponentFiles). The first task is connecting to a postgresql
⍝ server and the second creating a database.

)copy 1 assert
)copy 1 import 

⍝ Your SQL administrator must set you up as a user.  My administrator
⍝ always creates a database so that I can make a connection.  You'll
⍝ need both.

∇cl_test_setup;sqlh
  ⍝ Function to set up the test environment
  cl_test_type ← 'postgresql'
  cl_test_spec← 'host=localhost user=dalyw password=1BBmXEc0 dbname=apl_comp'
  cl_test_dir←'/home/dalyw/apl-library/test-data/'
  cash_flow_I←import∆file cl_test_dir,'cash_flow_I.txt'
  f500←import∆file cl_test_dir,'f500.txt'
  fifthq←import∆file cl_test_dir,'inv-fifthQ.txt'
  websites←import∆file cl_test_dir,'inv_f500_websites.txt'
∇

∇cl_test_cleanup
  ⍝ Function to close the component file and the database connection
  cl∆close cfh
  cl∆erase 'cl_test01'
  cl∆close_db
∇

 assert∆setup 'cl_test_setup'

'2=⎕nc ''_CF_DB''' assert∆nil∆toScreen 'cl_test_type cl∆open_db cl_test_spec'

True assert∆toScreen 'utl∆numberp cfh←cl∆init ''cl_test01'''

'cfh cl∆haskey ''cash_flow_I''' assert∆nil∆toScreen 'cfh cl∆assign ''cash_flow_I'' cash_flow_I'

'cfh cl∆haskey ''fifthq''' assert∆nil∆toScreen 'cfh cl∆assign ''fifthq'' fifthq'

'cfh cl∆haskey ''websites''' assert∆nil∆toScreen 'cfh cl∆assign ''websites'' websites'

'cfh cl∆haskey ''f500''' assert∆nil∆toScreen 'cfh cl∆assign ''f500'' f500'

cash_flow_I assert∆toScreen 'cfh cl∆lookup ''cash_flow_I'''

fifthq assert∆toScreen 'cfh cl∆lookup ''fifthq'''

websites assert∆toScreen 'cfh cl∆lookup ''websites'''

f500 assert∆toScreen 'cfh cl∆lookup ''f500'''

assert∆cleanUp 'cl∆close cfh' 'cl∆erase ''cl_test01''' 'cl∆close_db'



⍝)off
