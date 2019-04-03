#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝ password.apl APL workspace to generate random passwords.
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

∇txt←pw∆all
  ⍝ Function returns a vector of all characters. ie alpha,numeric,alpha
  txt←alpha,numeric,dingbats
∇

∇txt←pw∆alphanumeric
  ⍝ Function returns a vector of alpha numeric characters ie alpha,numeric
  txt←alpha,numeric
∇

∇p←l password set
  ⍝ Function randomly select l characters from set for a password
  p←set[l?⍴set]
∇

pw∆alpha←'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

pw∆dingbats←'~!@#$%^&*()-_=+><'

pw∆numeric←'0123456789' 
