   options source source2 mprint mlogic symbolgen;  


ODS Listing;

%MACRO findEnrich(posiSample, negSample, mydat);
data &posiSample; set &mydat;
    keep gene &posiSample &negSample;
	where &posiSample > -20 | &negSample > -20;
run;




proc robustreg data=&posiSample method=mm ; 
      model &posiSample = &negSample / diagnostics leverage;; 
      output out=mm_robout r=resid sr=stdres;
      ods output diagnostics=mm_diagnostics;
run;
PROC EXPORT DATA= WORK.mm_robout
               OUTFILE= "S:\Bioinformatics\analysis\LinhengLi\aparna_venkatraman\hsc_rnaseq\hul_analysis\pairwise_update\&posiSample._&negSample._robustReg\mm_robustReg_outliers.txt"
               DBMS=TAB REPLACE;
      PUTNAMES=YES;
RUN;
  PROC EXPORT DATA= WORK.mm_diagnostics
              OUTFILE= "S:\Bioinformatics\analysis\LinhengLi\aparna_venkatraman\hsc_rnaseq\hul_analysis\pairwise_update\&posiSample._&negSample._robustReg\mm_diagnostics.txt"
              DBMS=TAB REPLACE;
       PUTNAMES=YES;
  RUN;

data mm_outlier; set  mm_robout;
	where abs(stdres) > 3;
 run;

  PROC EXPORT DATA= WORK.mm_outlier
              OUTFILE= "S:\Bioinformatics\analysis\LinhengLi\aparna_venkatraman\hsc_rnaseq\hul_analysis\pairwise_update\&posiSample._&negSample._robustReg\mm_outlier.txt"
              DBMS=TAB REPLACE;
       PUTNAMES=YES;
  RUN;
   ods listing close;  
ods html   file='robustreg.htm'
                path="S:\Bioinformatics\analysis\LinhengLi\aparna_venkatraman\hsc_rnaseq\hul_analysis\pairwise_update\&posiSample._&negSample._robustReg" (url=none) ;
     ods graphics on;

proc robustreg data=&posiSample method=mm
    plots=(rdplot ddplot reshistogram resqqplot);
    model &posiSample = &negSample;
run;
ods graphics off;
 ods html close;

 %MEND;


