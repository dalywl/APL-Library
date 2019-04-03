#! /usr/local/bin/apl --script

⍝ cl, a library for a component file based lexicon
⍝ Copyright (C) 2016 Bill Daly

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
 

)copy 1 lex

)copy 5 APLComponentFiles/ComponentFiles.apl
)copy 1 utl
)copy 1 prompt

cl∆explain←⊃⎕inp 'end'
  This workspace uses APLComponentFiles (lib 5) to store items in the
  lexicon.  That workspace in turn uses workspace, SQL. I will be
  helpful to read the documentation for these two workspaces if only
  to determine how to connect the the SQL server.

  In short cl∆open_db must be executed to establish the connection. It
  is dyatic with the left argument of either 'postgresql' or 'mysql'
  and the right argument identifying the specific database to use. Our
  testing was done connecting to the postgres sql server at localhost.

  Once the database connection has been made, one connects to the
  particular component file with cl∆open.  It is monadic requiring a
  file name and returning a file handle for use as the lexicon in
  cl∆keys, cl∆assign, cl∆lookup and so forth.

  Use cl∆init to create the component file together with its table of
  contents. Use cl∆close to close the component file and cl∆close_db
  to disconnect from the database.

  Function cl∆setup_db will ask for appropriate connection
  information, storing the results in cl∆∆db_type and cl∆∆db_spec.
end


⍝⎕lx←'cl∆explain'

cl∆∆max←20			⍝ Maxmimum count of items for cl∆values
cl∆∆db_type←'postgresql'
cl∆∆db_spec←'host= user= password= dbname='

∇cl∆setup_db;host;user;password;dbname;type;prt;lbl
  ⍝ Function to prompt data base connection information
  prt←p1
p1:  →(utl∆numberp type←prompt 'Server type:  ')/tqd
  prt←p2
p2: →(utl∆numberp host←prompt 'Host:         ')/tqd
  prt←p3
p3: →(utl∆numberp user←prompt 'User:         ')/tqd
  prt←p4
p4: →(utl∆numberp password←prompt   'Password:     ')/tqd
  prt←p5
p5: →(utl∆numberp dbname←prompt 'Database:     ')/tqd
  prt←p1
tqd:				⍝ Top Quit Done
  →(quit,top,done,back)[prt]
quit:→0
top:→prt←p1
done:
  cl∆∆db_type←type
  cl∆∆db_spec←'host=',host,' user=',user,' password=',password,' dbname=',dbname
  →0
back:→(lbl,0)[(lbl←pr1,pr2,pr3,pr4,pr5)⍳prt]
  ∇  

∇db_type cl∆open_db db_spec
  ⍝ Connect to sql server for access to component files
  db_type CF_DBCONNECT db_spec
∇

∇cl∆close_db
  ⍝ Niladic function to disconnect from the sql server.
  CF_DBDISCONNECT
∇
  

∇ch←cl∆open cfilename
  ⍝ Function to open a component file
  utl∆es (2≠⎕nc '_CF_DB')/'No connection to an sql database has been made.'
  ch←CF_OPEN cfilename
∇

∇cl∆close ch
  ⍝ Function to close a component file
  CF_CLOSE ch
∇

∇toc←cl∆keys fh
 ⍝ Function to display the table of contents of a component store
  toc←CF_READ fh,1
  toc←(~(⊂cl∆dropFlag) utl∆stringEquals¨toc[;1])⌿toc
∇

∇fh←cl∆init fname;toc;rec
 ⍝ Function initiates a component store
 toc ← lex∆init
 ⍎(CF_FILEEXISTS fname)/'⍞←fname'' Exists''◊→0'
 fh←CF_CREATE fname
 rec←toc CF_APPEND fh
∇

∇fh cl∆assign val;toc;rec
 ⍝ Function to post a new component to the component store
 ⍎(2≠⎕nc 'fh')/'⍞←''An open component file should be supplied as a left argument'''
  toc←CF_READ fh,1
  →(toc lex∆haskey 1⊃val)/replace
  →(0≠rec←1↑((⊂cl∆dropFlag) utl∆stringEquals ¨ toc[;1])/toc[;2])/fill_hole
add:
 rec←(2⊃val)CF_APPEND fh
 toc←toc lex∆assign (val[1]),⊂rec
  toc CF_WRITE fh,1
  →0
fill_hole:
  toc[toc[;2]⍳rec;1]←val[1]
  toc CF_WRITE fh,1
  (2⊃val) CF_WRITE fh,rec
  →0
replace:  
  rec←toc lex∆lookup 1⊃val
  (2⊃val) CF_WRITE fh,rec
  toc[toc[;2]⍳rec;1]←val[1]
  toc CF_WRITE fh,1
  →0
∇

∇fh cl∆drop val;toc;ix
  ⍝ Function to remove a component.
  toc←CF_READ fh,1
  ix←toc lex∆lookup val
  utl∆es ((1↑⍴toc)<ix←(lex∆values toc)⍳ix)/val,' NOT FOUND'
  toc[ix;1]←⊂cl∆dropFlag
  toc CF_WRITE fh,1
∇  

∇dat←fh cl∆lookup key;rec;toc
 ⍝ Function retrieves a component from a component store and
 ⍝ establishes it in the database.
 toc←CF_READ fh,1
 rec←toc lex∆lookup key
 dat←CF_READ fh,rec
∇

∇b←fh cl∆haskey key;toc
  toc←CF_READ fh,1
  b←toc lex∆haskey key
∇

∇b←cl∆is fh;toc
  ⍝ Function tests if fh handle points to a component based lexicon.
  'b←0◊→0' ⎕EA 'toc←CF_READ fh,1'
  b←lex∆is toc
∇

∇msg←cl∆values fh;lb;i;⎕io
  ⍝ Returns all the values is a component base lexicon up to cl∆∆max
  ⍝ items and get obnoxious for large component files.
  ⎕io←1
  toc←CF_READ fh,1
  →(cl∆∆max<1↑⍴toc)/oh_well
  lb←((1↑⍴toc)⍴st),end
  i←1
  msg←0⍴0
st:
  msg←msg,⊂CF_READ fh,toc[i;2]
  →lb[i←i+1]
end:
  →0
oh_well:
  msg←'I''m balking on this one as file is too large.'
  →0
∇

∇cl∆erase cf_name
  ⍝ function to drop a component file
  CF_ERASE cf_name
∇


∇Z←lex⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'cl.txt'
  Z←Z⍪'Download'        'https://sourceforge.net/p/apl-library/code/ci/master/tree/cl.apl'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L2'
  Z←Z⍪'Provides'        ''
  Z←Z⍪'Requires'        'lex' 'ComponentFiles.apl' 'utl' 'prompt'
  Z←Z⍪'Version'                  '0 1 3'
  Z←Z⍪'Last update'         '2018-11-23'
∇

cl∆dropFlag ← '∆∆DROPPED∆∆'
