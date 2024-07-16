%let pgm=utl-update-master-table-using-a-transaction-table-using-sql-in-sas-r-and-python;

Update master table using a transaction table using sql in sas r and python

SQL arrays can be used if there are many family and person variables to update

  Three Solutions

       1 sas sql
       2 r sql
       3 python sql

 Related repos on end

github
https://tinyurl.com/ybhkpkcs
https://github.com/rogerjdeangelis/utl-update-master-using-transaction-data-using-sql-in-sas-r-and-python

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/


/**************************************************************************************************************************/
/*                                                                                                                        */
/* For documentation purposes only,                                                                                       */
/* I removed columns PERSONVAR1 and PERSONVAR2 because they are not changed and                                           */
/* have no missing values. The solution is very general because it is trivila to add all person variable.                 */
/*                                                                                                                        */
/*------------------------------------------------------------------------------------------------------------------------*/
/*                                                          |                                                             */
/*                        INPUT                             |                       OUTPUT                                */
/*                        =====                             |                       ======                                */
/*                                                          |                                                             */
/*  MASTER TABBLE                                           |                                                             */
/*  =============                                           |                                                             */
/*                                                          |                                                             */
/*   PERSON_                                                |    PERSON_                                                  */
/*      ID      FAM_ID    YEAR    FAMILYVAR1    FAMILYVAR2  |       ID      FAM_ID    YEAR   FAMILYVAR1    FAMILYVAR2     */
/*                                                          |                                                             */
/*      1         50      2012       1000        stringW    |       1         50      2012      1000        stringW       */
/*      2         50      2012       1000        stringW    |       2         50      2012      1000        stringW       */
/*      3         60      2012        150        stringX    |       3         60      2012       150        stringX       */
/*      4         70      2012        200        stringY    |       4         70      2012       200        stringY       */
/*      5         70      2012        200        stringY    |       5         70      2012       200        stringY       */
/*                                                          |                                    **UPDATED**              */
/*      1         50      2013      *update*     *update*   |       1         50      2013       400        stringW       */
/*      2         50      2013      *update*     *update*   |       2         50      2013       400        stringW       */
/*      3         60      2013      *update*     *update*   |       3         60      2013       700        stringY       */
/*                                                          |                                                             */
/*      1         50      2014          .                   |       1         50      2014         .                      */
/*      2         50      2014          .                   |       2         50      2014         .                      */
/*      3         60      2014          .                   |       3         60      2014         .                      */
/*                                                          |                                                             */
/*                                                          |                                                             */
/*                                                          |                                                             */
/*  TRANSACTION TABLE                                       |                                                             */
/*  =================                                       |                                                             */
/*                                                          |                                                             */
/*     PRIMARY KEY                                          |                                                             */
/*    ==============                                        |                                                             */
/*    FAM_ID    YEAR    FAMILYVAR1    FAMILYVAR2            |                                                             */
/*                                                          |                                                             */
/*      50      2013        400        stringW              |                                                             */
/*      60      2013        700        stringY              |                                                             */
/*      70      2013       1000        stringZ              |                                                             */
/*                                                          |                                                             */
/**************************************************************************************************************************/

/*                   _      __                    _ _
(_)_ __  _ __  _   _| |_   / _| ___  _ __    __ _| | |
| | `_ \| `_ \| | | | __| | |_ / _ \| `__|  / _` | | |
| | | | | |_) | |_| | |_  |  _| (_) | |    | (_| | | |
|_|_| |_| .__/ \__,_|\__| |_|  \___/|_|     \__,_|_|_|
        |_|
*/


libname sd1 "d:/sd1";
options validvarname=upcase;

* MASTER TABLE;

data sd1.a;
informat
PERSON_ID 3.
FAM_ID 3.
YEAR 4.
PERSONVAR1 4.
PERSONVAR2 $7.
FAMILYVAR1 4.
FAMILYVAR2 $7.
;input
PERSON_ID FAM_ID YEAR PERSONVAR1 PERSONVAR2 FAMILYVAR1 FAMILYVAR2;
cards4;
1 50 2012 500 stringA 1000 stringW
2 50 2012 550 stringB 1000 stringW
3 60 2012 710 stringC 150 stringX
4 70 2012 800 stringC 200 stringY
5 70 2012 0 stringJ 200 stringY
1 50 2013 120 stringJ .  .
2 50 2013 370 stringK . .
3 60 2013 80 stringL . .
1 50 2014 100 stringM . .
2 50 2014 500 stringM . .
3 60 2014 300 stringO . .
;;;;
run;quit;

* TRANSACTION TABLE;

data sd1.b;
informat
FAM_ID 3.
YEAR 4.
FAMILYVAR1 4.
FAMILYVAR2 $7.
;input
FAM_ID YEAR FAMILYVAR1 FAMILYVAR2;
cards4;
50 2013 400 stringW
60 2013 700 stringY
70 2013 1000 stringZ
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* SD1.A total obs=11                                                                                                     */
/*                                                                                                                        */
/*  PERSON_                                                                                                               */
/*     ID      FAM_ID    YEAR    PERSONVAR1    PERSONVAR2    FAMILYVAR1    FAMILYVAR2                                     */
/*                                                                                                                        */
/*     1         50      2012        500        stringA         1000        stringW                                       */
/*     2         50      2012        550        stringB         1000        stringW                                       */
/*     3         60      2012        710        stringC          150        stringX                                       */
/*     4         70      2012        800        stringC          200        stringY                                       */
/*     5         70      2012          0        stringJ          200        stringY                                       */
/*     1         50      2013        120        stringJ            .                                                      */
/*     2         50      2013        370        stringK            .                                                      */
/*     3         60      2013         80        stringL            .                                                      */
/*     1         50      2014        100        stringM            .                                                      */
/*     2         50      2014        500        stringM            .                                                      */
/*     3         60      2014        300        stringO            .                                                      */
/*                                                                                                                        */
/* SD1.B total obs=3                                                                                                      */
/*                                                                                                                        */
/*  FAM_ID    YEAR    FAMILYVAR1    FAMILYVAR2                                                                            */
/*                                                                                                                        */
/*    50      2013        400        stringW                                                                              */
/*    60      2013        700        stringY                                                                              */
/*    70      2013       1000        stringZ                                                                              */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                             _
/ |  ___  __ _ ___   ___  __ _| |
| | / __|/ _` / __| / __|/ _` | |
| | \__ \ (_| \__ \ \__ \ (_| | |
|_| |___/\__,_|___/ |___/\__, |_|
                            |_|
*/


proc sql;
 create
    table want as
 select
    l.person_id
   ,l.fam_id
   ,l.year
   ,l.personvar1
   ,l.personvar2
   ,coalesce(l.familyvar1,r.familyvar1) as familyvar1
   ,coalesce(l.familyvar2,r.familyvar2) as familyvar2
 from
   sd1.a as l left join sd1.b as r
 on
         l.fam_id    = r.fam_id
   and   l.year      = r.year
 order
   by l.year, l.person_id
;quit;


/**************************************************************************************************************************/
/*                                                                                                                        */
/* WORK.WANT total obs=11 1                                                                                               */
/*                                                                                                                        */
/*  PERSON_                                                                                                               */
/*     ID      FAM_ID    YEAR    PERSONVAR1    PERSONVAR2    FAMILYVAR1    FAMILYVAR2                                     */
/*                                                                                                                        */
/*     1         50      2012        500        stringA         1000        stringW                                       */
/*     2         50      2012        550        stringB         1000        stringW                                       */
/*     3         60      2012        710        stringC          150        stringX                                       */
/*     4         70      2012        800        stringC          200        stringY                                       */
/*     5         70      2012          0        stringJ          200        stringY                                       */
/*                                                                                                                        */
/*     1         50      2013        120        stringJ          400        stringW                                       */
/*     2         50      2013        370        stringK          400        stringW                                       */
/*     3         60      2013         80        stringL          700        stringY                                       */
/*                                                                                                                        */
/*     1         50      2014        100        stringM            .                                                      */
/*     2         50      2014        500        stringM            .                                                      */
/*     3         60      2014        300        stringO            .                                                      */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                     _
|___ \   _ __   ___  __ _| |
  __) | | `__| / __|/ _` | |
 / __/  | |    \__ \ (_| | |
|_____| |_|    |___/\__, |_|
                       |_|
*/

proc datasets lib=sd1 nodetails nolist;
 delete want;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
 source("c:/oto/fn_tosas9x.R")
a<-read_sas("d:/sd1/a.sas7bdat")
b<-read_sas("d:/sd1/b.sas7bdat")
want<- sqldf("
 select
    l.person_id
   ,l.fam_id
   ,l.year
   ,l.personvar1
   ,l.personvar2
   ,coalesce(l.familyvar1,r.familyvar1) as familyvar1
   ,coalesce(l.familyvar2,r.familyvar2) as familyvar2
 from
   a as l left join b as r
 on
         l.fam_id    = r.fam_id
   and   l.year      = r.year
 order
   by l.year, l.person_id
");
want;
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     );
;;;;
%utl_rendx;

libname sd1 "d:/sd1";
proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* R                                                                                                                      */
/* =                                                                                                                      */
/*                                                                                                                        */
/* > want;                                                                                                                */
/*    PERSON_ID FAM_ID YEAR PERSONVAR1 PERSONVAR2 familyvar1 familyvar2                                                   */
/* 1          1     50 2012        500    stringA       1000    stringW                                                   */
/* 2          2     50 2012        550    stringB       1000    stringW                                                   */
/* 3          3     60 2012        710    stringC        150    stringX                                                   */
/* 4          4     70 2012        800    stringC        200    stringY                                                   */
/* 5          5     70 2012          0    stringJ        200    stringY                                                   */
/* 6          1     50 2013        120    stringJ        400                                                              */
/* 7          2     50 2013        370    stringK        400                                                              */
/* 8          3     60 2013         80    stringL        700                                                              */
/* 9          1     50 2014        100    stringM         NA                                                              */
/* 10         2     50 2014        500    stringM         NA                                                              */
/* 11         3     60 2014        300    stringO         NA                                                              */
/*                                                                                                                        */
/*                                                                                                                        */
/* SAS                                                                                                                    */
/* ===                                                                                                                    */
/*                                                                                                                        */
/*    PERSON_                                                                                                             */
/*       ID      FAM_ID    YEAR    PERSONVAR1    PERSONVAR2    FAMILYVAR1    FAMILYVAR2                                   */
/*                                                                                                                        */
/*       1         50      2012        500        stringA         1000        stringW                                     */
/*       2         50      2012        550        stringB         1000        stringW                                     */
/*       3         60      2012        710        stringC          150        stringX                                     */
/*       4         70      2012        800        stringC          200        stringY                                     */
/*       5         70      2012          0        stringJ          200        stringY                                     */
/*                                                                                       **Updated                        */
/*       1         50      2013        120        stringJ          400                   **Updated                        */
/*       2         50      2013        370        stringK          400                   **Updated                        */
/*       3         60      2013         80        stringL          700                                                    */
/*                                                                                                                        */
/*       1         50      2014        100        stringM            .                                                    */
/*       2         50      2014        500        stringM            .                                                    */
/*       3         60      2014        300        stringO            .                                                    */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____               _   _                             _
|___ /   _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
  |_ \  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
 ___) | | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
|____/  | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
        |_|    |___/                                |_|
*/

%utl_pybeginx;
parmcards4;
import pyperclip
from os import path
import pandas as pd
import pyreadstat
import numpy as np
import pandas as pd
from pandasql import sqldf
mysql = lambda q: sqldf(q, globals())
from pandasql import PandaSQL
pdsql = PandaSQL(persist=True)
sqlite3conn = next(pdsql.conn.gen).connection.connection
sqlite3conn.enable_load_extension(True)
sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll')
mysql = lambda q: sqldf(q, globals())
import pyperclip
import os
from os import path
import sys
import subprocess
import time
import pandas as pd
import pyreadstat as ps
import numpy as np
import pandas as pd
from pandasql import sqldf
mysql = lambda q: sqldf(q, globals())
from pandasql import PandaSQL
pdsql = PandaSQL(persist=True)
sqlite3conn = next(pdsql.conn.gen).connection.connection
sqlite3conn.enable_load_extension(True)
sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll')
mysql = lambda q: sqldf(q, globals())
exec(open('c:/temp/fn_tosas9.py').read())
a, meta = pyreadstat.read_sas7bdat("d:/sd1/a.sas7bdat")
b, meta = pyreadstat.read_sas7bdat("d:/sd1/b.sas7bdat")
want = pdsql("""
 select
    l.person_id
   ,l.fam_id
   ,l.year
   ,l.personvar1
   ,l.personvar2
   ,coalesce(l.familyvar1,r.familyvar1) as familyvar1
   ,coalesce(l.familyvar2,r.familyvar2) as familyvar2
 from
   a as l left join b as r
 on
         l.fam_id    = r.fam_id
   and   l.year      = r.year
 order
   by l.year, l.person_id
""")
print(want)
fn_tosas9(
   want
   ,dfstr="want"
   ,timeest=3
   )
;;;;
%utl_pyendx;

libname tmp "c:/temp";
proc print data=tmp.want;
run;quit;

 /**************************************************************************************************************************/
 /*                                                                                                                        */
 /*  PYTHON                                                                                                                */
 /*  ======                                                                                                                */
 /*                                                                                                                        */
 /*      PERSON_ID  FAM_ID    YEAR  PERSONVAR1 PERSONVAR2  familyvar1 familyvar2                                           */
 /*  0         1.0    50.0  2012.0       500.0    stringA      1000.0    stringW                                           */
 /*  1         2.0    50.0  2012.0       550.0    stringB      1000.0    stringW                                           */
 /*  2         3.0    60.0  2012.0       710.0    stringC       150.0    stringX                                           */
 /*  3         4.0    70.0  2012.0       800.0    stringC       200.0    stringY                                           */
 /*  4         5.0    70.0  2012.0         0.0    stringJ       200.0    stringY                                           */
 /*  5         1.0    50.0  2013.0       120.0    stringJ       400.0                                                      */
 /*  6         2.0    50.0  2013.0       370.0    stringK       400.0                                                      */
 /*  7         3.0    60.0  2013.0        80.0    stringL       700.0                                                      */
 /*  8         1.0    50.0  2014.0       100.0    stringM         NaN                                                      */
 /*  9         2.0    50.0  2014.0       500.0    stringM         NaN                                                      */
 /*  10        3.0    60.0  2014.0       300.0    stringO         NaN                                                      */
 /*                                                                                                                        */
 /*                                                                                                                        */
 /*  SAS                                                                                                                   */
 /*  ===                                                                                                                   */
 /*                                                                                                                        */
 /*  PERSON_                                                                                                               */
 /*     ID      FAM_ID    YEAR    PERSONVAR1    PERSONVAR2    FAMILYVAR1    FAMILYVAR2                                     */
 /*                                                                                                                        */
 /*     1         50      2012        500        stringA         1000        stringW                                       */
 /*     2         50      2012        550        stringB         1000        stringW                                       */
 /*     3         60      2012        710        stringC          150        stringX                                       */
 /*     4         70      2012        800        stringC          200        stringY                                       */
 /*     5         70      2012          0        stringJ          200        stringY                                       */
 /*     1         50      2013        120        stringJ          400                                                      */
 /*     2         50      2013        370        stringK          400                                                      */
 /*     3         60      2013         80        stringL          700                                                      */
 /*     1         50      2014        100        stringM            .                                                      */
 /*     2         50      2014        500        stringM            .                                                      */
 /*     3         60      2014        300        stringO            .                                                      */
 /*                                                                                                                        */
 /**************************************************************************************************************************/

/*        _       _           _
 _ __ ___| | __ _| |_ ___  __| |  _ __ ___ _ __   ___  ___
| `__/ _ \ |/ _` | __/ _ \/ _` | | `__/ _ \ `_ \ / _ \/ __|
| | |  __/ | (_| | ||  __/ (_| | | | |  __/ |_) | (_) \__ \
|_|  \___|_|\__,_|\__\___|\__,_| |_|  \___| .__/ \___/|___/
                                          |_|
*/

https://github.com/rogerjdeangelis/utl_using_a_transaction_table_to_update__master_table_very_simple_code
https://github.com/rogerjdeangelis/utl_update_150mm_using_20_dimension_tables
https://github.com/rogerjdeangelis/utl-using-sentinels-to-restrict-update-to-common-columns-in-master-table-and-transaction-table
https://github.com/rogerjdeangelis/utl-update-first-row-with-total-sales
https://github.com/rogerjdeangelis/utl-update-master-table-using-multiple-transaction-tables
https://github.com/rogerjdeangelis/utl-update-missing-data-in-table-a-using-repeated-partial-data-from-table-b
https://github.com/rogerjdeangelis/utl-update-a-table-when-a-variable-has-been-defined-as-both-character-and-numeric
https://github.com/rogerjdeangelis/utl-Combime-flags-across-and-within-groups-datastep-sql-update
https://github.com/rogerjdeangelis/utl-given-yesterdays-and-todays-tables-flag-updates-inserts-and-deletes
https://github.com/rogerjdeangelis/utl-in-palce-updates-to-an-existing-shared-excel-workbook
https://github.com/rogerjdeangelis/utl-keeping-a-ring-of-last-four-daily-table-updates
https://github.com/rogerjdeangelis/utl-nine-ways-to-update-master-dataset-using-a-transaction-dataset-by-id-sas-python-and-r

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
