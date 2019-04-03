#!/usr/local/bin/apl --script
 ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝
⍝ date 2016-11-29 12:51:06 (GMT-5)
⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ date workspace implements lillian dates
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

)copy 1 utl
)copy 1 lex

∇date←date∆lillian ts;b1;b2;b3;yrs;days
⍝ Function to convert time stamp dates to lillian dates
ts[1]←ts[1]-date∆dates lex∆lookup 'Year 0'
⍝yrs←¯1+⍳ts[1]
yrs←⍳ts[1]
b1←0=400|yrs
b2←0=100|(~b1)/yrs
b3←0=4|(~b2)/(~b1)/yrs
days←(b3×366)+(~b3)×365
days←(b2×365)+(~b2)\days
days←(b1×366)+(~b1)\days
ix←1+365=days[ts[1]]
date←+/¯1↓days
date←date++/(ts[2]-1)↑date∆cal[ix;]
date←date+ts[3]
date←date-date∆dates lex∆lookup 'Pre lillian'
⎕es (date ≤ 0)/'PRE LILLIAN DATE'
∇

∇days←date∆marshalYears ts;yrs;b1;b2;b3
 ⍝ Function to assemble vector of days in each year starting with rarg
 yrs←⍳''⍴ts-date∆dates lex∆lookup 'Year 0'
 b1←0=400|yrs
 b2←0=100|(~b1)/yrs
 b3←0=4|(~b2)/(~b1)/yrs
 days←(b3×366)+(~b3)×365
 days←(b2×365)+(~b2)\days
 days←(b1×366)+(~b1)\days
∇

∇ts←date∆unlillian date;yrs;b1;b2;b3;ix
 ⍝ Function to covert a lillian date to a ts formatted date.
 date←date + date∆dates lex∆lookup 'Pre lillian'
 yrs←⍳2+⌈date÷365.25
 b1←0=400|yrs
 b2←0=100|(~b1)/yrs
 b3←0=4|(~b2)/(~b1)/yrs
 days←(b3×366)+(~b3)×365
 days←(b2×365)+(~b2)\days
 days←(b1×366)+(~b1)\days
 ts←3⍴0
 ts[1]←1++/date>+\days
 date←date-+/days[⍳ts[1]-1]
 ix←1+365=days[ts[1]]
 ts[2]←+/date>+\date∆cal[ix;]
 ts[3]←date-+/date∆cal[ix;⍳ts[2]]
 ts[1]←ts[1] + date∆dates lex∆lookup 'Year 0'
 ts[2]←ts[2]+1
∇

∇ts←locale date∆parse str;num;epoch
 ⍝ Function to parse a string and return a integer vector of year, month, day.
 ⍝ One ISO 8601 format
 ⍎(utl∆numberp str)/'ts←''NOT TEXT''◊→0'
 str← date∆delim utl∆split str
 →(∧/~num←utl∆numberis ¨ str)/err
 str[num/⍳⍴num]←⍎,' ',⊃num/str
 →(3=⍴ts←locale date∆parse∆ISO str)/tests
 →(3=⍴ts←locale date∆parse∆long str)/tests
 →(3=⍴ts←locale date∆parse∆short str)/tests
 tests:
 epoch←locale lex∆lookup 'epoch'
 →(ts[1]=0)/er2		⍝ Year tests failed
 →((ts[1]=epoch[1])^ts[2]<epoch[2])/er2
 →(∧/(ts[1 2]=epoch[1 2]),ts[3]<epoch[3])/er2
 →((ts[2]<1)∨ts[2]>12)/err
 max_days←(locale lex∆lookup 'days')[ts[2]]
 max_days←max_days+date∆US date∆parse∆leap_day ts
 →((ts[3]<1)∨ts[3]>max_days)/err
 →0
 err:
 ts←'NOT A DATE'
 →0
 er2:
 ts←'DATE BEFORE EPOCH STARTING ','0006-06-06'⍕epoch
 →0
∇

∇dt←locale date∆parse∆ISO txt
 ⍝ Function attempts to convert text in an ISO 8601 format to a date
 ⍝ made up of year month day.
 dt←3⍴0
 →(3=⍴txt)/extended
 →(1≠⍴txt)/err
 basic_iso:
 dt[1]←⌊txt÷10000
 txt←10000 | txt
 dt[2]←⌊txt÷100
 dt[3]←100 | txt
 →0
 extended:
 →(3≠+/utl∆numberp ¨ txt)/err
 →(0=⍴dt[1]←locale date∆test∆year txt)/err
 →(dt[1]=txt[1])/iso_date
 dt[2 3]←txt[(locale lex∆lookup 'month_pos'),locale lex∆lookup 'day_pos']
 →0
 iso_date:
 dt←txt
 →0
 err:
 dt←''
 →0
∇

∇dt←locale date∆parse∆leap_day ts;leap_month
 ⍝ Function returns 1 if the leap-month number of days should be incremented.
 leap_month←locale lex∆lookup 'leap-month'
 →(~dt←ts[2]=leap_month)/0
 →(dt←0=400|ts[1])/0
 →(~dt←0≠100|ts[1])/0
 dt←0=4|ts[1]
∇

∇dt←locale date∆parse∆long txt;b;mo
 ⍝ Function attempts to convert test in a long, spelled out form to a
 ⍝ date made up of year month day.
   dt←3⍴0
   b←utl∆numberp ¨ txt
   →b[1]/err
   →(13=mo←(locale lex∆lookup 'months') utl∆listSearch utl∆lower ⊃txt[1])/err
   dt[2]←mo
   →(∨/~b[2 3])/err
   dt[1]←txt[3]
   dt[3]←txt[2]
   →0
 err:
 dt←''
 →0
∇

∇dt←locale date∆parse∆short txt;m;mo;b
   ⍝ Function attempts to convert text in a short abbreviate form to a
   ⍝ date made up of year month day.
   dt←3⍴0
   m←locale lex∆lookup 'MTH'
   b←utl∆numberp ¨ txt
   →b[1]/mil
   →(0=⍴mo←m utl∆listSearch utl∆upper ⊃txt[1])/mil
   dt[2]←mo
   →(∨/~b[2 3])/mil
   dt[1]←txt[3]
   dt[3]←txt[2]
 →0
 mil:				⍝ Try military format
   →(0=⍴mo←m utl∆listSearch utl∆upper ⊃txt[2])/err
   dt[2] ← mo
   →(∨/~b[1 3])/err
   dt[1]←txt[3]
   dt[3]←txt[1]
   →0
 err:
   dt←''
   →0
∇

∇yr←locale date∆test∆year dt;e;t
 ⍝ Function called when all three elements of a date are numeric to
 ⍝ determine what the year is.
 yr←dt[1]			⍝ We try ISO dates first
 →(yr≥e←1↑locale lex∆lookup 'epoch')/0
 yr←dt[locale lex∆lookup 'year_pos']
 →(yr≥e)/0
 →((dt[1]>1000)∨yr≥100)/err
 t←locale lex∆lookup 'two-digit-cutoff'
 yr←yr+(1900 2000)[1+(yr>0)∧yr<t]
 →0
 err:
 yr←0
 →0
∇

date∆US←11 2⍴0 ⍝ prolog ≡1
  (,date∆US)[⍳22]←00 00 00 00 00 00 00 00 00 00 00 50 00 2 00 1 00 00 00 3 00 2
    ((⎕IO+(⊂0 0))⊃date∆US)←'months'
    ((⎕IO+(⊂0 1))⊃date∆US)←00 00 00 00 00 00 00 00 00 00 00 00
      ((⎕IO+(0 1) 0)⊃date∆US)←'january'
      ((⎕IO+(0 1) 1)⊃date∆US)←'february'
      ((⎕IO+(0 1) 2)⊃date∆US)←'march'
      ((⎕IO+(0 1) 3)⊃date∆US)←'april'
      ((⎕IO+(0 1) 4)⊃date∆US)←'may'
      ((⎕IO+(0 1) 5)⊃date∆US)←'june'
      ((⎕IO+(0 1) 6)⊃date∆US)←'july'
      ((⎕IO+(0 1) 7)⊃date∆US)←'august'
      ((⎕IO+(0 1) 8)⊃date∆US)←'september'
      ((⎕IO+(0 1) 9)⊃date∆US)←'october'
      ((⎕IO+(0 1) 10)⊃date∆US)←'november'
      ((⎕IO+(0 1) 11)⊃date∆US)←'december'
    ((⎕IO+(⊂1 0))⊃date∆US)←'MTH'
    ((⎕IO+(⊂1 1))⊃date∆US)←00 00 00 00 00 00 00 00 00 00 00 00
      ((⎕IO+(1 1) 0)⊃date∆US)←'JAN'
      ((⎕IO+(1 1) 1)⊃date∆US)←'FEB'
      ((⎕IO+(1 1) 2)⊃date∆US)←'MAR'
      ((⎕IO+(1 1) 3)⊃date∆US)←'APR'
      ((⎕IO+(1 1) 4)⊃date∆US)←'MAY'
      ((⎕IO+(1 1) 5)⊃date∆US)←'JUN'
      ((⎕IO+(1 1) 6)⊃date∆US)←'JUL'
      ((⎕IO+(1 1) 7)⊃date∆US)←'AUG'
      ((⎕IO+(1 1) 8)⊃date∆US)←'SEP'
      ((⎕IO+(1 1) 9)⊃date∆US)←'OCT'
      ((⎕IO+(1 1) 10)⊃date∆US)←'NOV'
      ((⎕IO+(1 1) 11)⊃date∆US)←'DEC'
    ((⎕IO+(⊂2 0))⊃date∆US)←'weekdays'
    ((⎕IO+(⊂2 1))⊃date∆US)←00 00 00 00 00 00 00
      ((⎕IO+(2 1) 0)⊃date∆US)←'sunday'
      ((⎕IO+(2 1) 1)⊃date∆US)←'monday'
      ((⎕IO+(2 1) 2)⊃date∆US)←'tuesday'
      ((⎕IO+(2 1) 3)⊃date∆US)←'wednesday'
      ((⎕IO+(2 1) 4)⊃date∆US)←'thursday'
      ((⎕IO+(2 1) 5)⊃date∆US)←'friday'
      ((⎕IO+(2 1) 6)⊃date∆US)←'saturday'
    ((⎕IO+(⊂3 0))⊃date∆US)←'wkd'
    ((⎕IO+(⊂3 1))⊃date∆US)←00 00 00 00 00 00 00
      ((⎕IO+(3 1) 0)⊃date∆US)←'SUN'
      ((⎕IO+(3 1) 1)⊃date∆US)←'MON'
      ((⎕IO+(3 1) 2)⊃date∆US)←'TUE'
      ((⎕IO+(3 1) 3)⊃date∆US)←'WED'
      ((⎕IO+(3 1) 4)⊃date∆US)←'THU'
      ((⎕IO+(3 1) 5)⊃date∆US)←'FRI'
      ((⎕IO+(3 1) 6)⊃date∆US)←'SAT'
    ((⎕IO+(⊂4 0))⊃date∆US)←'days'
    ((⎕IO+(⊂4 1))⊃date∆US)←31 28 31 30 31 30 31 31 30 31 30 31
    ((⎕IO+(⊂5 0))⊃date∆US)←'two-digit-cutoff'
    ((⎕IO+(⊂6 0))⊃date∆US)←'leap-month'
    ((⎕IO+(⊂7 0))⊃date∆US)←'month_pos'
    ((⎕IO+(⊂8 0))⊃date∆US)←'epoch'
    ((⎕IO+(⊂8 1))⊃date∆US)←1582 10 15
    ((⎕IO+(⊂9 0))⊃date∆US)←'year_pos'
    ((⎕IO+(⊂10 0))⊃date∆US)←'day_pos'

∇Z←date⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'date.txt'
  Z←Z⍪'Download'        'https://sourceforge.net/p/apl-library/code/ci/master/tree/date.apl'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L1'
  Z←Z⍪'Provides'        ''
  Z←Z⍪'Requires'        'utl' 'lex'
  Z←Z⍪'Version'                  '0 1 2'
  Z←Z⍪'Last update'         '2019-02-11'
∇

date∆delim←'/\- ,'

date∆dates←((lex∆init) lex∆assign 'Year 0' 1200) lex∆assign 'Pre lillian' 139444

date∆cal←31,29 28,2 10 ⍴ 31 30 31 30 31 31 30 31 30 31
