#! /usr/local/bin/apl --script
 ⍝ ********************************************************************
 ⍝   $Id: $
 ⍝ $desc: Script to invoke confirm errors are generated for bad data. $
 ⍝ ********************************************************************
⍝ tb_errors, A script to call various function with errors in their arguments.
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

)load 1 tb


⍞←'Initiate the workspace supplying name, period end and retained earnings:',⎕tc[3]
⍞←'tb_init (((lex∆init)lex∆assign ''name'' ''Example Co.'')lex∆assign ''end'' ''12/31/2017'')',⎕tc[3]
tb_init (((lex∆init)lex∆assign 'name' 'Example Co.')lex∆assign 'end' '12/31/2017')

⍞←'tb_init ''Example Co'' ''12/31/2017''',⎕tc[3]
tb_init 'Example Co' '12/31/2017'

⍞←'tb_init ''Example Co.'' ''12/31/2017'' 3990',⎕tc[3]
tb_init 'Example Co.' '12/31/2017' 3990

⍞←'tb_init (((lex∆init)lex∆assign ''name'' ''Example Co.'')lex∆assign ''end'' ''12/31/2017'')lex∆assign ''retainedEarnings'' 3990',⎕tc[3]
tb_init (((lex∆init)lex∆assign 'name' 'Example Co.')lex∆assign 'end' '12/31/2017')lex∆assign 'retainedEarnings' 3990

⍞←'Creating chart of accounts.',⎕tc[3]
tb_acct_add 3100 'Common Stock' 'b' 'c'
tb_acct_add 1010 'Cash' 'b' 'd'
tb_acct_add 1110 'Accounts Receivable' 'b' 'd'
tb_acct_add 1310 'Inventory' 'b' 'd'
tb_acct_add 1320 'Labor in inventory' 'b' 'd'
tb_acct_add 1390 'Overhead in inventory' 'b' 'd'
tb_acct_add 1410 'Prepaid expense' 'b' 'd'
tb_acct_add 1510 'Plant' 'b' 'd'
tb_acct_add 1520 'Equipment' 'b' 'd'
tb_acct_add 1590 'Accumulated Depreciation' 'b' 'd'
tb_acct_add 2010 'Current notes payable' 'b' 'c'
tb_acct_add 2110 'Accounts payable' 'b' 'c'
tb_acct_add 2310 'Accrued expense' 'b' 'c'
tb_acct_add 2710 'Long-term debt' 'b' 'c'
tb_acct_add 5010 'Sales' 'i' 'c'
tb_acct_add 6010 'Material cost of sales' 'i' 'd'
tb_acct_add 6110 'Labor cost of sales' 'i' 'd'
tb_acct_add 6910 'Overhead cost of sales' 'i' 'd'
tb_acct_add 7010 'Salaries and wages' 'i' 'd'
tb_acct_add 7020 'Payroll taxes' 'i' 'd'
tb_acct_add 7030 'Health insurance' 'i' 'd'
tb_acct_add 7110 'Janitorial supplies' 'i' 'd'
tb_acct_add 7120 'Building repairs and maintenance' 'i' 'd'
tb_acct_add 7150 'Utilities' 'i' 'd'
tb_acct_add 7210 'Professional fees' 'i' 'd'
tb_acct_add 7510 'Insurance' 'i' 'd'
tb_acct_add 8910 'Federal income taxes' 'i' 'd'
tb_acct_chart

⍞←'Adding final account:',⎕tc[3]

⍞←'tb_acct_add  ''State income taxes'' ''i'' ''d''',⎕tc[3]
tb_acct_add  'State income taxes' 'i' 'd'

⍞←'First argument (account number) defined in chart of accounts.',⎕tc[3]
⍞←'tb_acct_add  8910 ''State income taxes'' ''i'' ''d''',⎕tc[3]
tb_acct_add  8910 'State income taxes' 'i' 'd'

⍞←'Attempt to add retained earnings (defined by tb_init)'⎕tc[3]
⍞←'tb_acct_add  3990 ''Retained earnings'' ''b'' ''c''',⎕tc[3]
tb_acct_add  3990 'Retained earnings' 'b' 'c'

⍞←'Assign invalid account type:',⎕tc[3]
⍞←'tb_acct_add  8920 ''State income taxes'' ''q'' ''d''',⎕tc[3]
tb_acct_add  8920 'State income taxes' 'q' 'd'


⍞←'Assign invalid balance type:',⎕tc[3]
⍞←'tb_acct_add  8920 ''State income taxes'' ''i'' ''q''',⎕tc[3]
tb_acct_add  8920 'State income taxes' 'i' 'q'

⍞←'Create valid account:',⎕tc[3]
⍞←'tb_acct_add  8920 ''State income taxes'' ''i'' ''d''',⎕tc[3]
tb_acct_add  8920 'State income taxes' 'i' 'd'

⍞←'Create a journal entry:',⎕tc[3]
⍞←'Error one, wrong number of arguments:',⎕tc[3]
⍞←'aje01←tb_doc_init ''gj'' ''AJE01'' ''12/31/2017'' ',⎕tc[3]
aje01←tb_doc_init 'gj' 'AJE01' '12/31/2017'
⍞←'Actual initialize the document',⎕tc[3]
aje01←tb_doc_init 'gj' 'AJE01' '12/31/2017' 'To amortize prepaid insurance'

⍞←'aje01←aje01 tb_doc_debit 7510 225',⎕tc[3]
aje01←aje01 tb_doc_debit 7510 225

⍞←'Post to a non-existant account:',⎕tc[3]
⍞←'aje01←aje01 tb_doc_debit 9600 1000',⎕tc[3]
aje01←aje01 tb_doc_credit 9600 1000

⍞←'Journal entry not in balance. Step one a credit <> to the debits.',⎕tc[3]
⍞←'aje01←aje01 tb_doc_credit 1410 100'
aje01←aje01 tb_doc_credit 1410 100

⍞←'Step two post entry',⎕tc[3]
⍞←'tb_doc_post aje01            ⍝ Now the error message',⎕tc[3]
tb_doc_post aje01

