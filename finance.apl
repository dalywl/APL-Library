#! /usr/local/bin/apl --script
⍝ finance, a workspace of functions used in finance.
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


⍝ discounting for the time value of money

∇value←fin∆compoundValue args;cash;i;n
  ⍝ Function calculates the future value of a single sum.  Arguments
  ⍝ are amount of cash invested, interest rate per periood, and number
  ⍝ of periods.
  args←3↑,args
  cash←args[1] ◊ i ← args[2] ◊ n←args[3]
  value ← cash × (1 + i)*n
∇

∇ value←fin∆presentValue args;cash;i;n
  ⍝ Function calculates the present value of a single sum payable in n
  ⍝ periods. Argument are future cash, interest rate per period, and
  ⍝ number of periods.
  args←3↑,args
  cash←args[1] ◊ i ← args[2] ◊ n←args[3]
  value←cash ÷ (1 + i) * n
∇

∇ loan ← fin∆presentValueAnnuity args;payment;i;n
  ⍝ Function calculates the present value of an annuity. That is the
  ⍝ amount of a loan today in exchange for a payment of args[1] each
  ⍝ period for n periods at i interest per period.  Arguments are
  ⍝ payment, interest and number of periods.
  payment←args[1] ◊ i←args[2] ◊ n←args[3]
  loan ← +/payment÷(1+i)*⍳n
∇

∇ value←fin∆compoundAnnuity args;payment;i;n
  ⍝ Function calculates the future value of annuity.  That is the
  ⍝ amount in a savings account after n periods of depositing the same
  ⍝ amount. Arguments are payment, interest per period and number of
  ⍝ periods.
  payment←args[1] ◊ i ← args[2] ◊ n← args[3]
  value←+/payment × (1+i) * ⍳n
∇

∇value←i fin∆netPresentValue flow
  ⍝ Function calculates the net present value of a series of a cash⍝
  ⍝ flow vector. Left argument is the interest rate per period. This
  ⍝ is the general case for present value.
  value←+/flow ÷ (1+i) * ⍳⍴flow←,flow
∇

∇rate← guess fin∆irr flow;old_rate;new_rate;rate;old_pv;pv
  ⍝ Function calculates the internatl rate of return of a cash flow vector.
  old_rate←0 ◊ old_pv← +/flow
  rate←guess
st:
  pv← rate fin∆netPresentValue flow
  new_rate←rate-pv×(-/rate-old_rate)÷pv-old_pv
  old_rate←rate
  rate←new_rate
  old_pv←pv
  →(1<|pv)/st
∇

∇pymt←fin∆annuityPayment args;pv;i;n
  ⍝ Function returns the payment to amortize a single ammount. IE
  ⍝ Amount of a mortgage payment. Argument is the single amount,
  ⍝ interest per period, and number of periods.
  args←3↑,args ◊ pv←args[1] ◊ i←args[2] ◊ n←args[3]
  pymt←pv×i÷1 - (1 + i)*-n
∇

∇Z←fin⍙metadata                                 
  Z←0 2⍴⍬                                                
  Z←Z⍪'Author'          'Bill Daly '
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'                         
  Z←Z⍪'Documentation'   ''
  Z←Z⍪'Download'        'https://sourceforge.net/projects/apl-library/'   
  Z←Z⍪'License'         'GPL version 3'
  Z←Z⍪'Portability'     'L1'
  Z←Z⍪'Provides'        'Time value of money functions.'
  Z←Z⍪'Requires'        ''
  Z←Z⍪'Version'                  '0 1 1'
  Z←Z⍪'Last update'         '2018-11-23'
∇
