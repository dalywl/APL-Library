#!/usr/local/bin/apl --script

⍝ assert, a workspace to assert the results of tests.
⍝ Copyright (C) 2016, 2017, 2018 Bill Daly

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

∇assert∆setup cmds;lb;ix
  ⍝ Function to setup for  testing.
  ⍎(1=≡cmds)/'cmds←1⍴⊂cmds'
  ix←1
  lb←((1↑⍴cmds)⍴st),ed
st:
  ⍞←(6⍴' '),(ix⊃cmds),⎕tc[3]
  ⍎ix⊃cmds
  →lb[ix←ix+1]
ed:
∇

∇assert∆cleanUp cmds;lb;ix
  ⍝ Function to cleanup after testing.
  ⍎(1=≡cmds)/'cmds←1⍴⊂cmds'
  ix←1
  lb←((1↑⍴cmds)⍴st),ed
st:
  ⍞←(6⍴' '),(ix⊃cmds),⎕tc[3]
  ⍎ix⊃cmds
  →lb[ix←ix+1]
ed:
∇

∇assert∆message msg
  ⍝ Simple (minded) function to display a message
  ⍞←msg,⎕tc[3]
∇

∇result assert∆toScreen test
  ⍝ Function performs test and prints result to screen.
   ⍞←'      ',test,⎕tc[3]
   →(result assert∆01 ⍎test)/yes
 no:
   ⍞←'test failed.',⎕tc[3]
   →0
 yes:
   ⍞←'test succeeded.'⎕tc[3]
   →0
∇

∇b←result assert∆return test
   ⍝ Function performs tests and returns its comparison to result.
   ⍞←'      ',test,⎕tc[3]
  b←result assert∆01 test
∇

∇err assert∆error test
  ⍝ Function to test that an error is raised
∇  

∇b← result assert∆01 test
 ⍝ Helper function to recursively evaluate nested test results
 →((≡test)≠≡result)/no
 →((⍴⍴test)≠⍴⍴result)/no
 →((⍴test)≠⍴result)/no
 →(1<≡test)/test_many
 →(0≠⍴⍴test)/t2
 t1:
 b←test=result
 →0
 t2:
 →(b←∧/(,test)=,result)/0
 →no
 test_many:
 →(b←∧/test assert∆01 ¨ result)/0
 no:
 b←0
 →0
∇

∇eval_fns assert∆nil∆toScreen  test;b
  ⍝ Function to perform a niladic test (ie there are side
  ⍝ effects). eval_fns is a function that returns true or false and
  ⍝ confirms the side effects.
  ⍞←'      ',test,⎕tc[3]
  ⍎test
  ⍎'b←',eval_fns
  →b/yes
 no:
   ⍞←'test failed.',⎕tc[3]
   →0
 yes:
   ⍞←'test succeeded.'⎕tc[3]
   →0
∇

∇b←eval_fns assert∆nil∆return  test
  ⍝ Function to perform a niladic test (ie there are side
  ⍝ effects). eval_fns is a function that returns true or false and
  ⍝ confirms the side effects.
  ⍞←'      ',test,⎕tc[3]
  ⍎test
  ⍎'b←',eval_fns
∇


∇Z←util⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'assert.txt'
  Z←Z⍪'Download'        'https://sourceforge.net/p/apl-library/code/ci/master/tree/assert.apl'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L1'
  Z←Z⍪'Provides'        ''
  Z←Z⍪'Requires'        ''
  Z←Z⍪'Version'                           '0 1 2'
  Z←Z⍪'Last update'              '2018-12-13'
∇

True←1
False←0
