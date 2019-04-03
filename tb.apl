#!/usr/local/bin/apl --script

⍝ tb

⍝ This workspaceprovides functions to load and adjust trial balances.
⍝ A trial balance is a list of accounts together with their balances
⍝ to demonstrate that a company's books of account balances.  That the
⍝ debits equal the credits.  Accountants use trial balances to prepare
⍝ financial reports.

⍝ Doc is the basic unit of data for the trial balance.  It is a two
⍝ element vector made up of the head and body.  The Head it self is a
⍝ vector of doc_id, Journal, Name, Date and Description.  Once posted
⍝ the head becomes a line in the db_Documents table.

⍝ The body is a list of lines.  Each line is a vector of five items:
⍝ doc_id (to link it to the tb_Documents table), line_no, Acct_no (a
⍝ pointer to the tb_Accounts table), Debit and Credit.  Once posted
⍝ each line is appended to the tb_DocLines table.

⍝ Each document is uniquely identified by it's journal, name and date.

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

)copy 1 import
)copy 1 wp
)copy 1 prompt
)copy 1 date

∇tb_acct_add acct;re;locale
  ⍝ Function adds an account to tb_accounts. At a minimum aact must be
  ⍝ a two element vector of account number and title. The account
  ⍝ type, element 3, and sign type, element 4 may also be supplied.
  re←(tb_accounts[;3]='r')/tb_accounts[;1]
  utl∆es (~utl∆numberp acct[1])/'THE ACCOUNT NUMBER MUST BE A NUMBER'
  utl∆es (' '≠1↑0⍴⊃acct[2])/'THE ACCOUNT TITLE MUST BE TEXT'
  utl∆es (acct[1]∊tb_accounts[;1])/(⍕acct[1]),' IS CURRENTLY IN THE CHART OF ACCOUNTS'
  →(4=⍴acct←,acct)/just_add
  →(3=⍴acct)/with_acct_type
  ⍎(re>acct[1])/'acct←acct,''b''◊→with_acct_type'
  acct←acct,'i'
with_acct_type:			⍝ acct has three items
  locale←+/∧\acct[1]>tb_accounts[⍋tb_accounts[;1];1]
  acct←acct,tb_accounts[locale;4]
just_add:			⍝ acct has all four items
  utl∆es ('r'=acct[3])/'ONE MAY HAVE ONLY ONE RETAINED EARNINGS ACCOUNT.'
  utl∆es (~acct[3] ∊ 'bri')/'ACCOUNT TYPE MUST BE ONE OF b r OR i'
  utl∆es (~acct[4] ∊ 'dc')/'SIGN TYPE MUST BE ONE OF d OR c'
  tb_accounts←tb_accounts,[1]acct
  →0
∇

∇chart←tb_acct_chart
  ⍝ Function lists the chart of accounts
  chart←tb_accounts[⍋tb_accounts[;1];]
∇

∇test←tb_acct_proof acct
  ⍝ Function proves that acct (a number) exists in the chart of accounts
  ⍕(~utl∆numberp acct←''⍴acct)/'test←0◊→0'
  test←∨/tb_accounts[;1]=acct
∇

∇ln←tb_acct_select amt
  ⍝ Function displays the list of accounts; prompts for the account
  ⍝ number or line number and returns the selected account
  ln←tb_accounts[⍋tb_accounts[;1];] tb_select amt
∇

∇wp←tb_acct_workpaper acct;dat;attr
  ⍝ Function returns a general ledger page for the acct in workpaper format
  utl∆es (~utl∆numberp acct←''⍴acct)/'THE ACCOUNT MUST BE A NUMBER'
  utl∆es (~acct∊tb_accounts[;1])/(⍕acct),' NOT FOUND IN CHART OF ACCOUNTS.'
  utl∆es (0=1↑⍴dat←(acct=tb_DocLines[;3])⌿tb_DocLines)/'NO TRANSACTIONS POSTED TO ',⍕acct
  dat←tb_Documents[dat[;1];2 3 4],dat[;3 4 5]
  dat← dat,[1]'' 'Total' '' '',+⌿dat[;5 6]
  dat← 'Jrnl' 'Post Ref' 'Date' 'Acct No' 'Debit' 'Credit',[1]dat
  wp←lex∆init
  wp←wp lex∆assign 'Data' dat
  wp←wp lex∆assign (⊂'Entity'),⊂ tb_config lex∆lookup 'name'
  wp←wp lex∆assign (⊂'Title'),⊂ ' ' utl∆join (⊂⍕acct),tb_accounts[tb_accounts[;1]⍳acct;2]
  wp←wp lex∆assign (⊂'Period'),⊂tb_config lex∆lookup 'end'
  wp←wp lex∆assign (⊂'Id'),⊂'tb_gl_',⍕acct
  wp←wp lex∆assign 'Author' 'tb workspace'
  attr←(⍴dat)⍴⊂lex∆init
  attr[;4]←⊂((lex∆init)lex∆assign (⊂'format'),⊂tb_config lex∆lookup 'accountFormat')lex∆assign 'class' 'number'
  attr[;5 6]←⊂((lex∆init)lex∆assign (⊂'format'),⊂tb_config lex∆lookup 'balanceFormat')lex∆assign 'class' 'number'
  attr[1;]←⊂(lex∆init)lex∆assign 'class' 'colhead'
  attr[1↑⍴attr;5 6]←⊂((lex∆init)lex∆assign 'class' 'grand')lex∆assign (⊂'format'),⊂tb_config lex∆lookup 'balanceFormat'
  wp←wp lex∆assign 'Attributes' attr
  wp←wp lex∆assign 'Footer' ''
∇

∇tb_acct_show acct
  ⍝ Fucntion to display an account and its transactions.
  ⍞←wp∆txt∆assemble tb_acct_workpaper acct
∇

∇attr←tb_attr_create dat;shape;ix;nbr_a
  ⍝ Function creates a workpaper Attribute array. Function is called
  ⍝ when preparing a trial balance or a document.
  attr←(shape←⍴dat)⍴⊂lex∆init
  ix←¯1↓1↓⍳shape[1]
  →(4 9=shape[2])/tb,adj
err:
  utl∆es 'DATA IS NOT GENERATED BY tb_trialbalance'
tb:
  attr[ix;3 4]←nbr_a←⊂((lex∆init)lex∆assign 'class' 'number')lex∆assign (⊂'format'),⊂   tb_config lex∆lookup 'balanceFormat'
  attr[ix;1]←⊂((lex∆init)lex∆assign 'class' 'account') lex∆assign (⊂'format'),⊂    tb_config lex∆lookup 'accountFormat'
  attr[shape[1];3 4]←⊂((lex∆init)lex∆assign 'class' 'grand')lex∆assign (⊂'format'),⊂tb_config lex∆lookup 'balanceFormat'
  attr[1;]←⊂((lex∆init)lex∆assign 'class' 'colhead') lex∆assign 'text-align' 'center'
  →0
adj:
  attr[ix;3 4 6 7 8 9]←nbr_a←⊂((lex∆init)lex∆assign 'class' 'number')lex∆assign (⊂'format'),⊂   tb_config lex∆lookup 'balanceFormat'
  attr[ix;1]←⊂((lex∆init)lex∆assign 'class' 'account') lex∆assign (⊂'format'),⊂    tb_config lex∆lookup 'accountFormat'
  attr[shape[1];3 4 6 7 8 9]←⊂((lex∆init)lex∆assign 'class' 'grand')lex∆assign (⊂'format'),⊂tb_config lex∆lookup 'balanceFormat'
  attr[1;]←⊂((lex∆init)lex∆assign 'class' 'colhead') lex∆assign 'text-align' 'center'
  →0  
∇

∇wp←tb_chart_workpaper;dat
  ⍝ Function assemble a workpaper to display the chart of accounts.
  dat←'Acct_no' 'Title' 'Type' 'Sign',[1]tb_accounts[⍋tb_accounts[;1];]
  attr←(⍴dat)⍴⊂lex∆init
  attr[1;]←⊂(lex∆init)lex∆assign 'class' 'colhead'
  wp←lex∆init
  wp←wp lex∆assign 'Data' dat
  wp←wp lex∆assign (⊂'Entity'),⊂ tb_config lex∆lookup 'name'
  wp←wp lex∆assign (⊂'Title'),⊂ 'Chart of Accounts'
  wp←wp lex∆assign (⊂'Period'),⊂tb_config lex∆lookup 'end'
  wp←wp lex∆assign (⊂'Id'),⊂'tb_chart'
  wp←wp lex∆assign 'Author' 'tb workspace'
  wp←wp lex∆assign 'Attributes' attr
  wp←wp lex∆assign 'Footer' ''
∇
  
∇tb_chart_show
  ⍝ Function to display the chart of accounts
  ⍞←wp∆txt∆assemble tb_chart_workpaper
∇

∇doc← tb_doc_init args;rootNode;flds
  ⍝ Functions creates a document.  args is a vector of four items:
  ⍝ journal, name, date and description.
  utl∆es(4≠⍴args←,args)/'LENGTH ERROR ARGUMENT MUST BE A FOUR ITEM VECTOR OF JOURNAL, NAME, DATE, DESCRIPTION'
  doc←(⊂0, args),⊂0 5⍴0
∇

∇new←doc tb_doc_credit ln
  ⍝ Function to add or replace a line in doc with a debit.
  utl∆es (2≠⍴ln←,ln)/'LENGTH ERROR ARGUMENT MUST BE A TWO ITEM VECTOR'
  utl∆es (~tb_acct_proof ln[1])/(⍕ln[1]),' NOT IN CHART OF ACCOUNTS.'
  ln←0 0, ln[1], 0, ln[2]
  new←doc tb_doc_newLine ln
∇

∇new←doc tb_doc_debit ln
  ⍝ Function to add or replace a line in doc with a debit.
  utl∆es (2≠⍴ln←,ln)/'LENGTH ERROR ARGUMENT MUST BE A TWO ITEM VECTOR'
  utl∆es (~tb_acct_proof ln[1])/(⍕ln[1]),' NOT IN CHART OF ACCOUNTS.'
  ln←0 0, ln, 0
  new←doc tb_doc_newLine ln
∇

∇new←desc tb_doc_describe entry
  ⍝ Function to change or return the description of an entry.
  →(2=⎕nc 'desc')/change
  ⍝ Return an entry's description
  new←(⊃entry[1])[5]
  →0
change:				⍝ an entry's description
  new←entry
  new[1]←⊂(4↑⊃new[1]),⊂desc
  a →0
∇

∇doc←tb_doc_get id;head;body;bv;ix;l;dshape;jshape;nshape;err
  ⍝ Function returns a posted document. Argument is either the line in
  ⍝ tb_Documents or a vector of Journal, Name and Date
  →((utl∆numberp id)∧0=⍴⍴id)/id_supplied
  →(3=⍴id)/lookup
  utl∆es 'DOCUMENT ID MUST BE A NUMBER OR A VECTOR OF JOURNAL, NAME AND DATE'
lookup:
  jshape←⍴⊃tb_Documents[;2]
  nshape←⍴⊃tb_Documents[;3]
  dshape←⍴⊃tb_Documents[;4]
  ⍝ Find matching journals
  bv←(⊃tb_Documents[;2])∧.=jshape[2]↑⊃id[1]
  ⍝ Find matching names
  bv←bv∧(⊃tb_Documents[;3])∧.=nshape[2]↑⊃id[2]
  ⍝ Find matching dates
  bv←bv∧(⊃tb_Documents[;4])∧.=dshape[2]↑⊃id[3]
  →(1≠+/bv)/err_search
  id←''⍴bv/tb_Documents[;1]
  →id_supplied
id_supplied:
  →(0=ix←''⍴(id=tb_Documents[;1])/⍳1↑⍴tb_Documents)/err_search
  doc←(⊂tb_Documents[ix;]),⊂(tb_DocLines[;1]=id)⌿tb_DocLines
  →0
err_search:
  err←(⍕id),' NOT IN DATABASE.'
  utl∆es err
∇

∇list←tb_doc_list
  ⍝ Function returns a list of documents
  list←(2 3 ⍴'   Date   ' ' Jrnl ' ' name ' '==========' ' ==== ' ' ==== '),[1]tb_Documents[;4 2 3]
∇

∇new←name tb_doc_name entry;head
  ⍝ Function to change or return an entry's name
  →(2=⎕nc 'name')/change
  ⍝ Return an entry's name
  new←(1⊃entry)[3]
  →0
change:			⍝ an entry's name
  head←1⊃entry
  head[3]←⊂name
  new←(⊂head),entry[2]
  →0
∇

∇new←doc tb_doc_newLine ln;docLines;ix;ct
  ⍝ Function appends a new line or replaces and old line (based on
  ⍝ account) in a document. Called by tb_doc_debit and tb_doc_credit.
  docLines←⊃doc[2]
  →(0=ct←1↑⍴docLines)/add
  →(ct<ix←docLines[;3]⍳ln[3])/add
replace:
  ln[2]←ix
  docLines[ix;]←ln
  →end
add:
  ln[2]←1+''⍴⍴docLines
  docLines←docLines,[1]ln
  →end
end:
  new←doc[1],⊂docLines
∇

∇tb_doc_post doc;ix;head;body
  ⍝ Function posts a document to the database.
  ix←tb_seq_doc_id
  head←⊃doc[1]
  head[1]←ix
  body←⊃doc[2]
  body[;1]←ix
  utl∆es (≠/+⌿body[;4 5])/'THE DEBITS DO NOT EQUAL THE CREDITS'
  tb_Documents←tb_Documents,[1]head
  tb_DocLines←tb_DocLines,[1]body
∇

∇doc←old tb_doc_delLine acct;lines
  ⍝ Function to delete a line from a document.
  doc←old
  lines←⊃doc[2]
  utl∆es (~utl∆numberp acct←''⍴acct)/'ACCOUNT NUMBER IS NOT A NUMBER'
  utl∆es (0≠≡acct)/'ACCOUNT NUMBER IS NOT A SINGLE NUMBER'
  utl∆es (~acct∊lines[;3])/(⍕acct),' NOT FOUND'
  doc[2]←⊂(lines[;3]≠acct)⌿lines
∇

∇wp←tb_doc_workpaper doc;aix;meta_doc;lines;attr;dat
  ⍝ Function returns a workpaper displaying a document
  meta_doc←⊃doc[1]
  lines←⊃doc[2]
  wp←lex∆init
  wp←wp lex∆assign (⊂'Entity'),⊂ tb_config lex∆lookup 'name'
  wp←wp lex∆assign (⊂'Title'),⊂ ' ' utl∆join (⊂'Journal Entry'),meta_doc[2 3]
  wp←wp lex∆assign (⊂'Period'),meta_doc[4]
  wp←wp lex∆assign (⊂'Id'),meta_doc[3]
  wp←wp lex∆assign 'Author' 'tb workspace'
  dat←tb_accounts[tb_accounts[;1]⍳lines[;3];1 2],lines[;4 5]
  dat←dat,[1](⊂''),(⊂'Total'),+⌿lines[;4 5]
  wp←wp lex∆assign 'Data' dat
  wp←wp lex∆assign 'Stylesheet' wp∆defaultcss
  attr←(⍴dat)⍴⊂lex∆init
  attr[;1]←⊂((lex∆init)lex∆assign (⊂'format'),⊂tb_config lex∆lookup 'accountFormat')lex∆assign 'class' 'number'
  attr[;3 4]←⊂((lex∆init)lex∆assign (⊂'format'),⊂tb_config lex∆lookup 'balanceFormat')lex∆assign 'class' 'number'
  wp←wp lex∆assign 'Attributes' attr
  wp←wp lex∆assign (⊂'Footer'), meta_doc[5]
∇


∇tb_doc_show doc
  ⍝ Function to display an document in general journal form
  ⍞←wp∆txt∆assemble tb_doc_workpaper doc
∇

∇tb_journal_show jrnl;ix
  ⍝ Function to display a journal in general journal form.  jrnl is the key to the tb_journal lexicon
  ix←((⊃tb_Documents[;2])∧.=2↑,jrnl)/tb_Documents[;1]
  ⍞←⎕av[11],¨ wp∆txt∆assemble ¨ tb_doc_workpaper ¨ tb_doc_get ¨ ix
∇

∇flds tb_import_delimited fname;delim;b1;b2;mag;name;ye;re;bv;rdat
  ⍝ Function to import a delimited trial balance. Left argument flds
  ⍝ is a vector of columnar indicies to the trial balance array in fname:
  ⍝ AcctNo AcctTile Dr Cr
  ⍎(2≠⎕nc'flds')/'flds←⍳4'
  ⍝delim←flds[1]
  ⍝flds←1↓flds
  utl∆es (2≠⎕nc'tb_config')/'You must initiate the data base before importing data'
  b1←~∧/(tb_config lex∆haskey 'name'),(tb_config lex∆haskey 'PeriodEnd'),tb_config lex∆haskey 'retainedEarnings'
  utl∆es b1/'company name, PeriodEnd, and retainedEarnings must all be defined in tb_config before importing data'
  name←tb_config lex∆lookup 'name'
  ye←tb_config lex∆lookup 'PeriodEnd'
  re←tb_config lex∆lookup 'retainedEarnings'
  dat←import∆table import∆file fname
  ⍝ Remove descriptive material
  ⍝rdat←⍴dat
  ⍝bv←2≤+/rdat⍴(utl∆numberp¨dat)/dat←,dat
  ⍝dat←bv⌿rdat⍴dat
  ⍝ Build tb_accounts
  tb_accounts←(dat[;flds[1 2]],'b'),'d'		⍝ Account type and sign type
  ⍝ Mark retained earnings
  tb_accounts[(tb_accounts[;1]=re)/⍳1↑⍴tb_accounts;3]←'r'
  ⍝ Mark income accounts
  tb_accounts[(tb_accounts[;1]>re)/⍳1↑⍴tb_accounts;3]←'i'
  ⍝ Build document
  tb_Documents←1 5 ⍴ (tb_seq_doc_id),(⊂'gj'),(⊂'BEGBAL'),(⊂ye),⊂'Begining balances for ',name
  ⍝ Build doc lines
  →(3=⍴flds)/threeCols
fourCols:
  ⍝             Doc_id        line no   AcctNo      Dr Cr
  tb_DocLines←tb_Documents[1;1],(⍳1↑⍴dat),dat[;flds[1 3  4]]
  →rest
threeCols:
  b1←dat[;flds[3]]>0
  b2←dat[;flds[3]]<0
  ⍝              Doc_id         line No    AcctNo        Dr                  Cr
  tb_DocLines←tb_Documents[1;1],(⍳1↑⍴dat),dat[;flds[1]],(b1\b1/dat[;flds[3]]),[1.1]b2\b2/-dat[;flds[3]]
  →rest
rest:
  mag←⌈10⍟⌈/tb_DocLines[;3]	⍝ For the width of a column of acct numbers
  tb_config←tb_config lex∆assign (⊂'accountFormat'),⊂mag⍴'0'
∇

∇tb_init meta
  ⍝ Function to set up the tb database. meta is either a lexicon of company
  ⍝ (name), end (year end date) and retainedEarnings (account number)
  ⍝ or a vactor (in order of name, year end, and retained earnings
  ⍝ 1) Setup dictionaries and data tables:  
  tb_DictAccounts←'Acct No' 'Title' 'Acct Type' 'Sign Type'
  tb_DictDocuments← 'doc_id' 'Journal' 'Name' 'Date' 'Description'
  tb_Documents←(0,⍴tb_DictDocuments)⍴0
  tb_DictDocLines←'doc_id' 'line no' 'Acct No' 'Debit' 'Credit'
  tb_DocLines←(0,⍴tb_DictDocLines)⍴0
  tb_seq_doc_id_next←1
  ⍝ 2) set up tb_config with entity and period data
  →(lex∆is meta)/lexArg
vectorArg:
  utl∆es (1≠⍴⍴meta)/'ARGUMENT NOT A THREE OR FOUR ELEMENT VECTOR'
  utl∆es (~∨/4 3=⍴meta)/'ARGUMENT NOT A THREE OR FOUR ELEMENT VECTOR'
  utl∆es (~utl∆numberp date∆US date∆parse ⊃meta[2])/'YEAR END IS NOT A DATE'
  tb_config←(((lex∆init)lex∆assign (⊂'name'),meta[1])lex∆assign (⊂'YearEnd'),meta[2])lex∆assign (⊂'retainedEarnings'),meta[⍴meta]
  tb_config←tb_config lex∆assign (⊂'PeriodEnd'),meta[2]
  →(4>⍴meta)/completeConfig
  utl∆es (~utl∆numberp date∆US date∆parse ⊃meta[4])/'PERIOD END IS NOT A DATE'
  tb_config←tb_config lex∆assign (⊂'PeriodEnd'), meta[4]
  →completeConfig
lexArg:
  utl∆es (~∧/(meta lex∆haskey 'name'),(meta lex∆haskey 'YearEnd'),meta lex∆haskey 'retainedEarnings')/'ARGUMENT SHOULD BE A LEXICON OF name, end, AND retainedEarnings'
  tb_config←meta
  →(tb_config lex∆haskey 'PeriodEnd')/completeConfig
  tb_config←tb_config lex∆assign (⊂'PeriodEnd'),⊂tb_config lex∆lookup 'YearEnd'
  →completeConfig
  ⍝ Add standard options to tb_config
completeConfig:
  tb_config←tb_config lex∆assign 'accountFormat' '0000'
  tb_config←tb_config lex∆assign 'balanceFormat' '55,555,550.00'
  tb_config←tb_config lex∆assign 'BeginingJE' 'BEGBAL'
  tb_accounts←(1,⍴tb_DictAccounts)⍴ (tb_config lex∆lookup 'retainedEarnings'), (⊂'Retained earnings'), 'r' 'c'
  tb_initStyle
∇

∇ans←chart tb_select args;shape;mag;keys;max;min
  ⍝ Function prepends the item selected from chart to the list of args
  →(utl∆numberp keys←chart[;1])/mm
  keys←⊃⍎¨chart[;1]
mm:
  max←⌈/keys
  min←⌊/keys
  shape←1↑⍴chart
  mag←1 + ⌊ 10⍟shape
  ((('[',mag⍴'0'),']')⍕(shape,1)⍴⍳shape),chart
pt:
  ans←prompt 'Select [item] '
  →(utl∆numberp ans)/keyword
  ans←(~∧\' '=ans)/ans
  ⍎(~utl∆numberis ans)/'''Please enter a number less than '',⍕shape◊→pt'
  ans←⍎ans
  →((ans≤max)∧ans≥min)/key
index:
  ⍎(shape < ans)/'''Please enter a number less than '',⍕shape◊→pt'
  ans←chart[ans;1],args
  →0
key:
  ans←(ans=keys)⌿chart[;1]
  ⍎(1≠⍴ans)/'''Invalid key''◊→pt'
  ans←ans,args
  →0
keyword:
  →(0 ≠ ans)/pt
  →0
∇

∇next←tb_seq_doc_id
  ⍝ Function returns the next item in the doc_id sequence
  next←tb_seq_doc_id_next
  tb_seq_doc_id_next ← 1 + tb_seq_doc_id_next
∇

∇bg←tb_begin_init
  ⍝ Function to initiate a begining balance trial balance. Begining
  ⍝ balances dictionary is acct_no title debit credit.
  bg←0 4⍴0
∇

∇bg←old tb_begin_newline acct;ix
  ⍝ Function to add an account to a begining balance trial balance
  bg←old
  →((1↑⍴bg)<ix←bg[;1]⍳acct[1])/add
replace:
  bg[ix;]←acct
  →0
add:
  bg←bg,[1]acct
  →0
∇

∇b←tb_begin_editCheck acct
  ⍝ Function to test data before adding/inserting into a begining
  ⍝ trial balance
  →(~b←4=⍴acct←,acct)/0		⍝ Must be four items
  →(~b←∧/utl∆numberp ¨ acct[1 3 4])/0
  b←utl∆stringp ⊃acct[2]
∇

∇bg←old tb_begin_debit acct
  ⍝ Function to add or insert an account with a debit balance to a
  ⍝ begining trial balance
  acct←acct,0
  utl∆es (~tb_begin_editCheck acct)/'A Trial balance debit must be an account no, title, and debit'
  bg←old tb_begin_newline acct
∇

∇bg←old tb_begin_credit acct
  ⍝ Function to add or insert an account with a credit balance to a
  ⍝ begining trial balance.
  acct←acct[1 2],0,acct[3]
  utl∆es(~tb_begin_editCheck acct)/'A Trial balance credit must be an account no, title, and credit'
  bg←old tb_begin_newline acct
∇

∇tb_begin_post bg;ix;je;ax;bv;re;if
  ⍝ Function posts a begining trial balance to the database.
  utl∆es (~=/+⌿bg[;3 4])/'DEBITS DO NOT EQUAL CREDITS'
  ix←tb_accounts[;1]⍳bg[;1]
  ax←(bv←ix>1↑⍴tb_accounts)/⍳⍴ix
  re←tb_config lex∆lookup 'retainedEarnings'
  if←'bi'[⎕io+bg[ax;1]>re]
  tb_accounts←tb_accounts,[1](bg[ax;1 2],if),'d'
  je←tb_doc_init 'gj',((⊂tb_config) lex∆lookup ¨ 'BeginingJE' 'end'),''
  je[2]←⊂je[1],(⍳1↑⍴bg),bg[;1 3 4]
  tb_doc_post je
∇

∇b←tb_date_IsYearEnd
   ⍝ Function to test if the current period is the year end.
   →(b←~tb_config lex∆haskey 'PeriodEnd')↑0
 b←tb_date_YearEnd = tb_date_PeriodEnd
∇

∇l←tb_date_YearEnd
   ⍝ Function returns the year end as a lillian date
   l←date∆lillian date∆US date∆parse tb_config lex∆lookup 'YearEnd'
∇

∇l←tb_date_PeriodEnd
   ⍝ Function returns the period end as a lillian date
   l←date∆lillian date∆US date∆parse tb_config lex∆lookup 'PeriodEnd'
∇

∇tb_close newPeriods;bg;re                                                 
  ⍝ Function to close the current period.  Function removes all  
  ⍝ documents and creates a BEGBAL document dated one day after  
  ⍝ tb_config date. Argument newPeriods is a two element vector of the
  ⍝ year end and period end                                           
  →(~tb_date_IsYearEnd)/nye
  utl∆es (~utl∆numberp date∆US date∆parse ⊃newPeriods[1])/newPeriods[1],' NOT A DATE'
  utl∆es (~utl∆numberp date∆US date∆parse ⊃newPeriods[2])/newPeriods[2],' NOT A DATE'
  bg←(tb_accounts[;3]='b')⌿tb_accounts[;1 2],tb_tb_balances    
  re←-/+⌿bg[;3 4]                                              
  →(re<0)/drBal                                                
crBal:bg←bg,[1](2⍴(tb_accounts[;3]='r')⌿tb_accounts[;1 2]),0 re
  →purge                                                       
drBal: bg←bg,[1]                                               
  bg←bg,[1](2⍴(tb_accounts[;3]='r')⌿tb_accounts[;1 2]),-re 0   
  →purge                                                       
nye:                                                           
  bg←tb_accounts[;1 2],tb_tb_balances                          
  →purge                                                       
purge:                                                         
  tb_Documents←(0,⍴tb_DictDocuments)⍴0                           
  tb_DocLines←(0,⍴tb_DictDocLines)⍴0                             
  tb_begin_post bg
  tb_config←tb_config lex∆assign (⊂'YearEnd'),newPeriods[1]
  tb_config←tb_config lex∆assign (⊂'PeriodEnd'),newPeriods[2]
∇

∇sched←tb_sched_init proto
  ⍝ Function returns a new schedule. A Schedule is a report prepared
  ⍝ from the current trial balance. Proto is a vector of id and title.
  utl∆es (~utl∆stringp 1⊃proto)/'SCHEDULE ID MUST BE A CHARACTER STRING.'
  ⎕ex (~utl∆stringp 2⊃proto)/'SCHEDULE TITLE MUST BE A CHJARACTER STRING.'
  sched←lex∆init
  sched←sched lex∆assign (⊂'ID' ),proto[1]
  sched←sched lex∆assign (⊂'title'),proto[2]
  ⍝ A line is name line_no title sign_type line_type subs debit and credit
  sched←sched lex∆assign (⊂'lines'),⊂0 8⍴0
  sched←sched lex∆assign 'fns' 'tb_sched_workpaper'
∇

∇sched←sched tb_sched_addLine line;lines
  ⍝ Function adds or replaces a line.  No edit checks are done
  lines←sched lex∆lookup 'lines'
  lines←lines,[1]line
  sched←sched lex∆assign 'lines' lines
∇

∇rpt←tb_sched_showLines sched;lines
  ⍝ Function returns a report of the name, line number and title of
  ⍝ each line on the schedule.
  lines←sched lex∆lookup 'lines'
  rpt←lines[⍋lines[;2];1 2 3]
∇

∇wp←type tb_sched_workpaper sched;dat;attr;lines
  ⍝ Function prepares a detail schedule. Type is optional and raw
  ⍝ report for debugfging is displayed. Current only type acct is defined.  
  wp←lex∆init
  wp←wp lex∆assign (⊂'Entity'),⊂ tb_config lex∆lookup 'name'
  wp←wp lex∆assign (⊂'Title'),⊂ sched lex∆lookup 'title'
  wp←wp lex∆assign (⊂'Period'),⊂ tb_config lex∆lookup 'end'
  wp←wp lex∆assign (⊂'Id'),⊂'A Schedule'
  wp←wp lex∆assign 'Author' 'tb workspace'
  lines←sched lex∆lookup 'lines'
  ⍝ Asemble basic array of data
  dat←tb_tb_balances tb_sched_workpaper1 lines[⍋lines[;2];]
  wp←wp lex∆assign 'Data' dat
  attr←(⍴dat)⍴⊂lex∆init
  wp←wp lex∆assign 'Attributes' attr
  wp←wp lex∆assign 'Stylesheet' wp∆defaultcss
  →(2≠⎕nc 'type')/0		⍝ show raw data when type has not been provided.
  wp ← tb_sched_wp_acct wp	⍝ Prepare and audit trail
∇

⍝ There are three type of lines on a schedule:
⍝  1) Decoration has no amounts
⍝  2) Account has balances from a trial balance.
⍝  3) Totals has balances that are totals of either accounts or other
⍝  total lines. 

∇dat←bal tb_sched_workpaper1 lines;name;lnNo;title;sign_type;ln_type;subs;dr;cr;ln1;lnTotal;ix
  ⍝ Function recursively compiles the schedule's lines. Helper
  ⍝ function for tb_sched_workpaper.
  →(0<1↑⍴lines)/mkLine
  dat←0 8⍴0
  →0
mkLine:
  dat←bal tb_sched_workpaper1 ¯1 0↓lines
  (name lnNo title sign_type ln_type subs dr cr)←lines[''⍴⍴lines;]
  space←' '
  →(ln_type='atdg')/acctLine totalLine decoration totalLine
acctLine:			⍝ Assemble array of accounts with header and total lines
  subs←subs[⍋subs]
  ix←tb_accounts[;1]⍳subs
  ln1←name space title space 'd' space space space
  lnTotal←name lnNo title sign_type 't' space, +⌿bal←bal[ix;]
  dat←dat,[1]ln1,[1]((⊂name),tb_accounts[ix;1 2],sign_type,'a',space,bal),[1]lnTotal
  →0
totalLine:			⍝ Assemble and calculate a total line
  subs←subs[⍋subs]
  ix←dat[;2]⍳subs
  ln1←name lnNo title sign_type ln_type space, +⌿dat[ix;7 8]
  dat←dat,[1]ln1
  →0
decoration:			⍝ Assemble a decoration
  ln1←space space title space 'd' space space space
  dat←dat,[1]ln1
  →0
∇

∇wp←tb_sched_wp_acct raw;dat;attr;total_lines; account_lines; dec_lines; dr_lines; cr_lines; gr_lines; all_lines
  ⍝ Function prepares an audit trail (from underlying accounts to
  ⍝ report. On entry, raw is a wp with raw Data and Attributes. A
  ⍝ helper function for tb_sched_workpaper.
  dat←raw lex∆lookup 'Data'
  total_lines←(dat[;5]='t')/all_lines←⍳1↑⍴dat
  account_lines←(dat[;5]='a')/all_lines
  gr_lines←(dat[;5]='g')/all_lines
  dec_lines←(dat[;5]='d')/all_lines
  dr_lines←(dat[;4]='d')/all_lines
  cr_lines←(dat[;4]='c')/all_lines
  dat[dr_lines;7]←-/dat[dr_lines;7 8]
  dat[cr_lines;7]←¯1×-/dat[cr_lines;7 8]
  dat[total_lines,gr_lines;2]←' '
  dat←dat[;2 3 7]
  wp←raw lex∆assign 'Data' dat
  attr←(⍴dat)⍴⊂lex∆init
  attr[account_lines;1]←⊂((lex∆init)lex∆assign 'class' 'number')lex∆assign (⊂'format'),⊂tb_config lex∆lookup 'accountFormat'
  attr[account_lines;3]←⊂((lex∆init)lex∆assign 'class' 'number')lex∆assign (⊂'format'),⊂tb_config lex∆lookup 'balanceFormat'
  attr[total_lines;3]←⊂((lex∆init)lex∆assign 'class' 'total')lex∆assign (⊂'format'),⊂tb_config lex∆lookup 'balanceFormat'
  attr[gr_lines;3]←⊂((lex∆init)lex∆assign 'class' 'grand')lex∆assign (⊂'format') ,⊂tb_config lex∆lookup 'balanceFormat'
  wp←wp lex∆assign 'Attributes' attr
∇

∇new←sched tb_line_init proto;subs;lines;name;line_no;title;sign_type;space
  ⍝ Function to initiate a schedule line.  Proto is a vector of name,
  ⍝ line_no, title balance_flag ('d' or 'c'), line_type ('a' 't' 'g'
  ⍝ 'd') and either a list of acct_no or line_no.
  lines←sched lex∆lookup 'lines'
  (name line_no title sign_type line_type)←5↑proto
  subs←5↓proto
  space←' '
  utl∆es (~utl∆stringp name←,name)/'LINE NAME MUST BE A CHARACTER STRING'
  utl∆es (~utl∆numberp 2⊃proto)/'LINE NUMBER MUST BE AN INTEGER'
  utl∆es (~utl∆stringp title←,title)/'TITLE MUST BE A CHARACTER STRING'
  →(line_type='atdg')/account_line total_line decoration total_line
account_line:
  utl∆es(∨/(1↑⍴tb_accounts)<tb_accounts[;1]⍳subs)/(⍕subs),' NOT FOUND IN CHART OF ACCOUNTS'
  utl∆es (~sign_type∊'cd')/'BALANCE FLAG MUST BE EITHER ''c'' or ''d'''
  new←sched lex∆assign (⊂'lines'),⊂lines,[1] name line_no title sign_type 'a' subs 0 0
  →0
total_line:
  utl∆es (∨/(1↑⍴lines)<lines[;2]⍳subs)/(⍕subs),' NOT FOUND IN SCHEDULE.'
  utl∆es (~sign_type∊'cd')/'BALANCE FLAG MUST BE EITHER ''c'' or ''d'''
  new←sched lex∆assign (⊂'lines'),⊂lines,[1] name line_no title sign_type line_type subs 0 0
  →0
decoration:
  new←sched lex∆assign (⊂'lines'),⊂lines,[1] name line_no title space 'd' space space space
  →0
 ∇  

∇dat←tb_tb_balances;shape
  ⍝ trial balance helper function to calculate closing balances
  shape←(1↑⍴tb_accounts),1↑⍴tb_DocLines
  dat←-/tb_DocLines[;4 5]
  dat←+/(shape⍴dat)×tb_accounts[;1]∘.=tb_DocLines[;3]
  dat←¯2 utl∆round (dat×dat>0),[1.1]-dat×dat<0
∇

∇tb_tb_show                          
  ⍝ Function display a trial balance
  ⍞←wp∆txt∆assemble tb_trialbalance 
∇

∇tb_tb_adj_show                                   
  ⍝ Function to display an adjusted trial balance
  ⍞←wp∆txt∆assemble tb_trialbalance_adj          
∇

∇tb←tb_trialbalance;dat
  ⍝ Function returns a trial balance in workpaper format
  dat←tb_accounts[;1 2],tb_tb_balances
  dat←dat[⍋dat[;1];]
  dat←dat,[1]'' 'Total',+⌿dat[;3 4]
  dat← 'AcctNo' 'Title' 'Dr' 'Cr' ,[1] dat
  ⍝ Create a workpaper
  tb←lex∆init
  tb←tb lex∆assign 'Data' dat
  tb←tb lex∆assign (⊂'Id'),⊂'TB_',tb_config lex∆lookup 'end'
  tb←tb lex∆assign (⊂'Entity'),⊂ tb_config lex∆lookup 'name'
  tb←tb lex∆assign 'Title' 'Trial Balance'
  tb←tb lex∆assign (⊂'Period' ),⊂ tb_config lex∆lookup 'PeriodEnd'
  tb←tb lex∆assign 'Author' 'tb workspace'
  tb←tb lex∆assign 'Function' ''
  tb←tb lex∆assign 'Stylesheet' wp∆defaultcss
  tb←tb lex∆assign (⊂'Attributes'),⊂ tb_attr_create dat
∇

∇tb←tb_trialbalance_adj;dat;b1;b2;t1;t2;t3
  ⍝ Function returns a workpaper in the form of an adjusted trial balance.
  ⍝ Assemble the trial balance. dat dictionary is
  ⍝ 1) Account number
  ⍝ 2) Title
  ⍝ 3) Begining Debits
  ⍝ 4) Begining Credits
  ⍝ 5) Posting reference (name)
  ⍝ 6) Adjusting Dr
  ⍝ 7) Adjusting Cr
  dat←(tb_accounts[⍋tb_accounts[;1];1 2],0),0
  t1←(b1←tb_DocLines[;1]=1)⌿tb_DocLines[;3 4 5]
  t2←(~b1)⌿tb_DocLines
  t2←t2,tb_Documents[tb_Documents[;1]⍳t2[;1];3]
  dat[dat[;1]⍳t1[;1];3 4]←t1[;2 3]
  t2←t2[⍋t2[;3];]
  t3←(b2←1,(1↓t2[;3])≠¯1↓t2[;3])⌿t2
  t2←(~b2)⌿t2
  dat←((dat,⊂''),0),0
  dat[dat[;1]⍳t3[;3];1 5 6 7]←t3[;3 6 4 5]
  dat←dat,[1]t2[;3],((⌽3,1↑⍴t2)⍴'' 0 0),t2[;6 4 5]
  dat←dat[⍋dat[;1];]
  b1←1,(¯1↓dat[;1])≠1↓dat[;1]
  dat←dat,b1⍀tb_tb_balances[⍋tb_accounts[;1];]
  dat←dat,[1]('' 'Total'),( +⌿dat[;3 4]), (⊂''), +⌿dat[;6 7 8 9]
  dat←'AcctNo' 'Acct Title' 'Begin Dr' 'Begin Cr' 'Ref' 'Dr' 'Cr' 'Adj Dr' 'Adj Cr',[1] dat
  tb←(lex∆init) lex∆assign 'Data' dat
  tb←tb lex∆assign (⊂'Id'),⊂'TB_',tb_config lex∆lookup 'end'
  tb←tb lex∆assign (⊂'Entity'),⊂ tb_config lex∆lookup 'name'
  tb←tb lex∆assign 'Title' 'Trial Balance'
  tb←tb lex∆assign (⊂'Period' ),⊂ tb_config lex∆lookup 'PeriodEnd'
  tb←tb lex∆assign 'Author' 'tb workspace'
  tb←tb lex∆assign 'Function' ''
  tb←tb lex∆assign 'Stylesheet' wp∆defaultcss
  tb←tb lex∆assign (⊂'Attributes'),⊂ tb_attr_create dat
∇

∇tb_initStyle;css
  ⍝ Function to initiate a trial balance specific cascading style
  ⍝ sheet several functions to prepare workpapers insert references to
  ⍝ classes defined here.
  css←lex∆init
  css←css lex∆assign (⊂'body'),⊂(((lex∆init)lex∆assign 'font' '12pt sans-serif')lex∆assign 'text-align' 'left')lex∆assign 'border' 'none 2pt black'

  css←css lex∆assign (⊂'.colhead'),⊂((lex∆init)lex∆assign 'text-align' 'center')lex∆assign 'font-size' 'small'

  css←css lex∆assign (⊂'.number'),⊂((lex∆init)lex∆assign 'text-align' 'right')lex∆assign 'width' '9em'

  css←css lex∆assign (⊂'.account'),⊂(lex∆init)lex∆assign 'test-align' 'right'

  css←css lex∆assign (⊂'.page-head'),⊂((lex∆init)lex∆assign 'font-size' 'large') lex∆assign 'font-weight' 'bold'
  
  css←css lex∆assign (⊂'.initial-block'),⊂((lex∆init)lex∆assign 'font-size' 'small')lex∆assign 'border' 'solid 1pt black'

  css←css lex∆assign(⊂'.grand'),⊂(((lex∆init)lex∆assign 'border-top' 'solid 1pt black')lex∆assign 'border-bottom' 'double 3pt black')lex∆assign 'text-align' 'right'
  css←css lex∆assign(⊂'.total'),⊂((lex∆init)lex∆assign 'border-top' 'solid 1pt black')lex∆assign 'text-align' 'right'
  wp∆defaultcss←css
∇

∇Z←tb⍙metadata
  Z←0 2⍴⍬
  Z←Z⍪'Author'          'Bill Daly'
  Z←Z⍪'BugEmail'        'bugs@dalywebandedit.com'
  Z←Z⍪'Documentation'   'comments in file'
  Z←Z⍪'Download'        'https://sourceforge.net/projects/apl-library/'
  Z←Z⍪'License'         'GPL v3.0'
  Z←Z⍪'Portability'     'L3'
  Z←Z⍪'Provides'        'Function to create an accountant'' trial balance'
  Z←Z⍪'Requires'        'import wp prompt date'
  Z←Z⍪'Version'                  '0 1 2'
  Z←Z⍪'Last update'         '2019-02-11'
∇



tb_data_vars←'tb_DictAccounts' 'tb_accounts' 'tb_DictDocuments' 'tb_Documents' 'tb_DictDocLines' 'tb_DocLines' 'tb_seq_doc_id' 'tb_config' 'wp∆defaultcss'
