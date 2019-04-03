#! /usr/local/bin/apl --script
 ⍝ ********************************************************************
 ⍝   $Id: $
 ⍝ $desc: Workspace of statistical functions $
 ⍝ ********************************************************************
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


∇count←stat∆count vector
  ⍝ Function to return a count of the items in vector, as a scaler
  count←''⍴⍴vector
∇

⍝ Least mean squared

∇a←b stat∆lms∆intercept data
 ⍝ Computes the y intercept of the Least Mean Squares function given
 ⍝ the slop as the left argument
 a ← ((+/data[;2])-b×+/data[;1])÷1↑⍴data
∇

∇b← stat∆lms∆slope data;n;d
 ⍝ Function calculates the slope of a least mean square regression
 ⍝ given array of dependent,[1..1]independant data
 n←((⍴data[;2])×+/data[;2]×data[;1])-(+/data[;2])×+/data[;1]
 d←((⍴data[;1])×+/data[;1]*2)-(+/data[;1])*2
 b←n÷d
∇

∇r←stat∆lms∆cor data;n;nm;dm
  ⍝ Function to calculate the coefficient of correlation
  n←1↑⍴data
  nm←(n×+/data[;1]×data[;2])-(+/data[;1])×+/data[;2]
  dm← (((n×+/data[;1]*2)-(+/data[;1])*2)*.5)×((n×+/data[;2]*2)-(+/data[;2])*2)*.5
  r←nm÷dm
∇

⍝ Population locations and distributions

∇range←stat∆range vector
  ⍝ Function to compute the range of a set
  range←--/vector[⍋vector][1,⍴vector]
∇

∇v←stat∆popVar vector
  ⍝ Function to compute the population variance
  v←(+/(vector - stat∆mean vector)*2)÷stat∆count vector←,vector
∇

∇sd←stat∆popSD vector
  ⍝ Functio to compute the population standard deviation
  sd←(stat∆popVar vector)*.5
∇

⍝ Sample locations and distributions

∇mean←stat∆mean vector
  ⍝ Function to compute the sample mean of a vector
  mean←(+/vector)÷stat∆count vector←,vector
∇

∇v←stat∆sampleVar vector;shape
  ⍝ Function to compute the sample variance
  v←((shape×(+/vector*2))-(+/vector)*2) ÷shape×¯1+shape←stat∆count vector←,vector
∇

∇s←stat∆sampleSD vector
  ⍝ Function to compute sample standard deviation
  s←(stat∆sampleVar vector)*.5
∇

∇median←stat∆median vector;count
⍝ Function to find the median of a vector
count← stat∆count vector←,vector
vector←vector[⍋vector]
→(0=2|count)/even
odd:
median←vector[.5+.5×count]
→0
even:
median←.5×+/vector[0 1 + .5×count]
→0
∇



⍝ Grouped data measures

∇cm←stat∆gd∆classMark gd
  ⍝ Function to calculate the class mark for grouped data where gd is
  ⍝ an array with three columns
  ⍝ gd[;1] is the lower class limit
  ⍝ gd[;2] is the upper class limit
  ⍝ gd[;3] the class frequency
  cm←.5×+/gd[;1 2]
∇

∇mean←stat∆gd∆mean gd
  ⍝ Function to calculate the mean of grouped data where gd is an
  ⍝ array with three columns:
  ⍝ gd[;1] is the lower class limit
  ⍝ gd[;2] is the upper class limit
  ⍝ gd[;3] the class frequency
  mean←(+/gd[;3]×stat∆gd∆classMark gd)÷+/gd[;3]
∇

∇sd←stat∆gd∆sd gd
  ⍝ Function to calculate the standard deviation of grouped data where
  ⍝ gd is an array with three columns
  ⍝ gd[;1] is the lower class limit
  ⍝ gd[;2] is the upper class limit
  ⍝ gd[;3] the class frequency
  sd←(+/gd[;3]×((stat∆gd∆classMark gd)-stat∆mean gd)*2)÷¯1+1↓⍴gd
∇

⍝Generate random numbers

∇s←n stat∆prob∆uniform m
  ⍝ Function to generate a random sample of n items uniformly
  ⍝ distributed over positive integers to m
  s←1?m
  →(n=1)/0
  s←s,(n-1)stat∆prob∆uniform m
∇

∇skewness←stat∆pearson vector;mm;md;sd
  ⍝ Function returns the Pearson coefficient of skewness
  mn←stat∆mean vector←,vector
  md←stat∆median vector
  sd←stat∆sampleSD vector
  skewness←(3×mn-md)÷sd
∇

∇ skew←type stat∆skewness vector;n;var;sq
  ⍝ Function returns a measure of skewness
  ⍎(0=⎕nc 'type')/'type←1'
  type←4⌊type
  n←stat∆count vector
  var←vector - stat∆mean vector
  skew←(n*.5)×(+/var*3)÷(+/var*2)*3÷2
  →(one,two,three,four)[type]
one:
  →end
two:
  ⎕es (n<3)/'At least three observations are required.'
  skew←skew ×  ((n × ( n -1))*.5)÷n - 2
  →end
three:
  skew←skew×(1-1÷n)*3÷2
  →end
four:
  skew←stat∆pearson
  →end
end:
∇

∇tiles←rank stat∆tile data;bp;size;ix
  ⍝ Function returns the data in tiles based on rank.  A rank of 4
  ⍝ yields quartiles and of 5 quintiles.
  data←data[⍋data]
  bp←utl∆round ((size←⍴data←,data)÷rank)×⍳rank
  ix←(⊂⍳size){⍵/⍺}¨⊂[2](bp∘.>⍳size)∧(0,¯1↓bp)∘.≤⍳size
  tiles←{data[⍵]}¨ix
∇

∇Z←stat⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'html.txt'
  Z←Z⍪'Download'        'https://sourceforge.net/projects/apl-library'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L1'
  Z←Z⍪'Provides'        'Basic statiscal functions'
  Z←Z⍪'Requires'        ''
  Z←Z⍪'Version'                  '0 1 2'
  Z←Z⍪'Last update'         '2019-02-11'
∇

