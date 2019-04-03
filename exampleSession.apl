#! /usr/local/bin/apl --script
⍝ ********************************************************************
⍝   $Id: $
⍝ $desc: Script to create example workspaces$
⍝ ********************************************************************
⍝ exampleSession a script to demonstrate how tb works.
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

⍝ ********************* Iniktialize and create the chart of accounts *****************
tb_init (((lex∆init)lex∆assign 'name' 'Example Co.')lex∆assign 'YearEnd' '12/31/2017')lex∆assign 'retainedEarnings' 3990
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
tb_acct_add 8920 'State income taxes' 'i' 'd'
tb_acct_chart

⍝ ****************************** Begining Balances ***************************************


begin ← tb_doc_init 'gj' 'begin' '1/1/2017' 'To record opening balances'
begin←begin tb_doc_debit 1010 45000

begin←begin tb_doc_debit 1410 2500

begin←begin tb_doc_debit 1510 1300000

begin←begin tb_doc_debit 1520 755000

⍝ Depreciation in initial year
⍝      (1300000÷40)+755000÷7
⍝140357.1429

begin←begin tb_doc_credit 1590 140400

begin←begin tb_doc_credit 2110 41750

⍝ Long term debt, 80% of PP&E
⍝      .8×1300000+755000
⍝1644000
begin←begin tb_doc_credit 2710 1644000

begin←begin tb_doc_credit 3100 1000

begin←begin tb_doc_credit 3990 275350

tb_doc_show begin
tb_doc_post begin

⍝ ****************************** sales ***************************************
sales←tb_doc_init 'gj' 'sales' '12/31/2017' 'To record sales for year'
sales←sales tb_doc_debit 1110 1000000

sales←sales tb_doc_credit 5010 1000000

tb_doc_show sales
tb_doc_post sales

⍝ ********************** Cost of sales **************************************
cos←tb_doc_init 'gj' 'cos' '12/31/2017' 'To record cost of sales'
cos←cos tb_doc_debit 6010, .5×.65×1000000

cos←cos tb_doc_debit 6110,.4×.65×1000000

cos←cos tb_doc_debit 6110,.4×.65×1000000

cos←cos tb_doc_debit 6910,.1×.65×1000000

cos←cos tb_doc_credit 1310, .5×.65×1000000

cos←cos tb_doc_credit 1320, .4×.65×1000000

cos←cos tb_doc_credit 1390, .1×.65×1000000

tb_doc_show cos
tb_doc_post cos

⍝ ****************************** payrolls *********************************
payroll←tb_doc_init 'gj' 'payroll' '12/31/2017' 'To record payroll'
payroll←payroll tb_doc_debit 1320 346800 ⍝ Direct labor
payroll←payroll tb_doc_debit 7010 100000 ⍝ Admin salaries

payroll←payroll tb_doc_debit 7020,800 + .0765×100000 ⍝ Payroll taxes on admin.  Direct Labor inclueds their payroll taxes

payroll←payroll tb_doc_credit 1010, +/346800 100000 8450

tb_doc_show payroll

tb_doc_post payroll
⍝ ************************* Purchases ********************************************
purchases←tb_doc_init 'gj' 'purchases' '12/31/2017' 'To record purchases'
purchases←purchases tb_doc_debit 1310 434000
purchases←purchases tb_doc_debit 7030 30000

purchases←purchases tb_doc_debit 7110 5000

purchases←purchases tb_doc_debit 7120 7800

purchases←purchases tb_doc_debit 7150 23000

purchases←purchases tb_doc_debit 7210 11000

purchases←purchases tb_doc_debit 7510 12000

purchases←purchases tb_doc_credit 2110 522800

tb_doc_show purchases
tb_doc_post purchases

⍝ ****************************** Cash disbursements ************************************************
checks←tb_doc_init 'cd' 'checks' '12/31/2017' 'To record payment of purchases during year'
checks←checks tb_doc_debit 2110 490600

checks←checks tb_doc_credit 1010 490600

tb_doc_show checks
tb_doc_post checks
⍝ *********************************** Receivables 75 days *****************************
⍝      75×1000000÷365
⍝205479.4521
⍝      1000000 - 205500
⍝794500
deposits←tb_doc_init 'cr' 'deposits' '12/31/2017' 'To record cash receipts'
deposits←deposits tb_doc_debit 1010 794500

deposits←deposits tb_doc_credit 1110 794500

tb_doc_show deposits
tb_doc_post deposits

⍝ ************************** A line of credit to fund working capital **********************
loc←tb_doc_init 'gj' 'loc' '12/31/2017' 'To record net borrowings on line of credit'
loc←loc tb_doc_debit 1010 250000

loc←loc tb_doc_credit 2010 250000

tb_doc_show loc
tb_doc_post loc

⍝ ************************** Display the adjusted trial balance ***************************
⍞←wp∆txt∆assemble tb_trialbalance_adj

⍝ ************************** Build a schedule **********************************
s1←tb_sched_init 'TB' 'Trial Balance'
⍞←'s1←tb_sched_init ''TB'' ''Trial Balance''',⎕tc[3]
s1← s1 tb_line_init 'CA' 1 'Current Assets' 'd' 'a' 1010 1110 1310 1320 1390 1410
⍞←'s1← s1 tb_line_init ''CA'' 1 ''Current Assets'' ''d'' ''a'' 1010 1110 1310 1320 1390 1410',⎕tc[3]
s1← s1 tb_line_init  'CL' 10 'Current Liabilities' 'c' 'a' 2010 2110 2310
⍞←'s1← s1 tb_line_init  ''CL'' 10 ''Current Liabilities'' ''c'' ''a'' 2010 2110 2310',⎕tc[3]
s1← s1 tb_line_init  'LTD' 11 'Long-term Debt' 'c' 'a' 2710
⍞←'s1← s1 tb_line_init  ''LTD'' 11 ''Long-term Debt'' ''c'' ''a'' 2710',⎕tc[3]
s1← s1 tb_line_init 'EQ' 15 'Equity' 'c' 'a' 3100 3990
⍞←'s1← s1 tb_line_init ''EQ'' 15 ''Equity'' ''c'' ''a'' 3100 3990',⎕tc[3]
s1← s1 tb_line_init 'S' 40 'Sales' 'c' 'a' 5010
⍞←'s1← s1 tb_line_init ''S'' 40 ''Sales'' ''c'' ''a'' 5010',⎕tc[3]
s1← s1 tb_line_init 'COS' 45 'Costs of Sales' 'd' 'a' 6010 6110 6910
⍞←'s1← s1 tb_line_init ''COS'' 45 ''Costs of Sales'' ''d'' ''a'' 6010 6110 6910'
s1← s1 tb_line_init 'PPE' 2 'Plant Property and Equipment' 'd' 'a' 1510 1520 1590
⍞←'s1← s1 tb_line_init ''PPE'' 2 ''Plant Property and Equipment'' ''d'' ''a'' 1510 1520 1590',⎕tc[3]
s1← s1 tb_line_init 'TAX' 90 'Income Taxes' 'd' 'a' 8910 8920
⍞←'s1← s1 tb_line_init ''TAX'' 90 ''Income Taxes'' ''d'' ''a'' 8910 8920',⎕tc[3]
s1← s1 tb_line_init 'SGA' 60 'Selling, General, and Administrative Expense' 'd' 'a' 7010 7020 7030 7110 7120 7150 7210 7510
⍞←'s1← s1 tb_line_init ''SGA'' 60 ''Selling, General, and Administrative Expense'' ''d'' b''a''7 010 7020 7030 7110 7120 7150 7210 7510',⎕tc[3]
s1←s1 tb_line_init 'ASSETS' 9 'Total Assets' 'd' 'g' 1 2
⍞←'s1←s1 tb_line_init ''ASSETS'' 9 ''Total Assets'' ''d'' ''g'' 1 2',⎕tc[3]
s1←s1 tb_line_init 'HD1' 0 'Assets' 'q' 'd'
⍞←'s1←s1 tb_line_init ''HD1'' 0 ''Assets:'' ''q'' ''d''',⎕tc[3]
⍞←'s1←s1 tb_line_init ''GM'' 50 ''Gross Margin'' ''c'' ''g'' 40 45',⎕tc[3]
s1←s1 tb_line_init 'GM' 50 'Gross Margin' 'c' 't' 40 45
⍞←'s1←s1 tb_line_init ''EBIT'' 80 ''Income before tax'' ''c'' ''g'' 50 80',⎕tc[3]
s1←s1 tb_line_init 'EBIT' 80 'Income before tax' 'c' 't' 50 60
⍞←'s1←s1 tb_line_init ''NET'' 100 ''Net income'' ''c'' ''g'' 80 90',⎕tc[3]
s1←s1 tb_line_init 'NET' 100 'Net income' 'c' 'g' 80 90
⍝ ************************** Display the schedule

⍞←'⍞←wp∆txt∆assemble tb_sched_workpaper s1',⎕tc[3]
⍞←wp∆txt∆assemble tb_sched_workpaper s1

s2←tb_sched_init 'FS' 'Financial Statements'
s2←s2 tb_line_init 'Inc' 1 'Statement of Income' ' ' 'd'
s2←s2 tb_line_init 'SLS' 40 'Sales' 'c' 'a' 5010
s2←s2 tb_line_init 'COS' 45 'Cost of Sales' 'd' 'a' 6010 6110 6910
s2←s2 tb_line_init 'GM' 50 'Gross Margin' 'c' 't' 40 45
s2←s2 tb_line_init 'SGA' 60 'Selling, General, and Admin' 'd' 'a' 7010 7020 7030 7110 7120 7150 7210 7510
s2←s2 tb_line_init 'EBIT' 80 'Income before tax' 'c' 't' 50 60
s2←s2 tb_line_init 'TAX' 90 'Income taxes' 'd' 'a' 8910 8920
s2←s2 tb_line_init 'NET' 100 'Net income' 'c' 'g' 80 90
s2←s2 tb_line_init 'CA' 205 'Current Assets' 'd' 'a' 1010 1110 1310 1320 1390 1410
s2←s2 tb_line_init 'PG1' 201 'Assets' ' ' 'd'
s2←s2 tb_line_init 'PPE' 250 'Plant Property and Equipment' 'd' 'a' 1510 1520 1590
s2←s2 tb_line_init 'ASSETS' 299 'Total Assets' 'd' 'g' 205 250
s2←s2 tb_line_init 'PG2' 301 'Liabilities and Equity' ' ' 'd'
s2←s2 tb_line_init 'CL' 305 'Current Liabilities' 'c' 'a' 2010 2110 2310
s2←s2 tb_line_init 'LTD' 350 'Long-term Debt' 'c' 'a' 2710
s2←s2 tb_line_init 'EQ' 400 'Equity' 'c' 'a' 3100 3990
s2←s2 tb_line_init 'INC' 410 'Current Income' 'c' 't' 100
s2←s2 tb_line_init 'EQT' 420 'Equity with current income' 'c' 't' 400 410
s2←s2 tb_line_init 'EQTS' 490 'Liabilites and Equity' 'c' 'g' 305 350 420

⍞←'⍞←wp∆txt∆assemble ''acct'' tb_sched_workpaper s2'
⍞←wp∆txt∆assemble 'acct' tb_sched_workpaper s2
