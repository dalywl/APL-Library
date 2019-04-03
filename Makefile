#********************************************************************
# $desc: Makefile for apl-library, primarily for tar balls $
#********************************************************************

apl_files=assert.apl cl.apl convert2utl.apl date.apl dom.apl \
    export.apl finance.apl html.apl lex1.apl lex.apl lpr.apl \
    prompt.apl seq.apl stat.apl tb.apl  utf8.apl util.apl utl.apl \
    wp.apl xml.apl

test_files=cl_test.apl date_test.apl exampleSession.apl \
    exim_test.apl html_test.apl finance-test.apl html_test.apl \
    lex1_test.apl lex_test01.apl seq_test.apl stat_test.apl \
    tb_errors.apl test_suite.apl util_test.apl utl_test.apl xml_test.apl

doc_files=doc/assert.texi doc/cfg_file.texi doc/cl.texi \
    doc/date.texi doc/dom.texi doc/finance.texi doc/html.texi \
    doc/import.texi doc/lex1.texi doc/lex.texi doc/lpr.texi \
    doc/stat.texi doc/utl.texi doc/wp.texi \
    doc/wp.texi doc/xml.texi doc/apl-library.texi

data_files=wp-data/apl_comp.sql wp-data/dow.txt

VERSION=`cat Version.txt|sed -es/Version\ /-/g`

tgz: $(apl_files) $(doc_files) $(data_files) $(HOME)/Uploads doc/apl-library.info
	tar czf $(HOME)/Uploads/wslib1$(VERSION).tgz --exclude=*\~  \
            --exclude=README.muse --exclude=\#* --exclude=Uploads \
                --exclude=backups *


$(HOME)/Uploads:
	mkdir $(HOME)/Uploads

doc/apl-library.info: $(doc_files)
	makeinfo doc/apl-library.texi
        
