libname cat "D:\NHANES\sas";


/*2008년도*/
proc sort data=cat.HN08_all;
by id;
run;
proc sort data=cat.HN08_eye;
by id;
run;

data cat.HN08;/*공통적으로 id 가 있는 사람만 뽑음*/
merge cat.HN08_all (in=a) cat.HN08_eye(in=b);
by id;
if a=1 and b=1;
drop E_Q_FAM1  E_Q_EXC1  E_PEO_1;
run;
/*2009년도*/
proc sort data=cat.HN09_all;
by  id;
run;
proc sort data=cat.HN09_eye;
by id;
run;
data cat.HN09;
merge cat.HN09_all(in=a) cat.HN09_eye(in=b);
by id;
if a=1 and b=1;
drop E_Q_FAM1  E_Q_EXC1  E_PEO_1;
run;
/*2008과 2009를 합친것*/
data cat.HN0809;
set cat.HN08 cat.HN09;
run;

/*2010*/
proc sort data=cat.HN10_all;
by id;
run;
proc sort data=cat.HN10_eye;
by id;
run;
data cat.HN10;/*공통적으로 id 가 있는 사람만 뽑음*/
merge cat.HN10_all (in=a)  cat.HN10_eye(in=b);
by id;
if a=1 and b=1;
drop E_Q_FAM1 E_Q_EXC1 E_PEO_1;
run;

/*2011*/
proc sort data=cat.HN11_all;
by id;
run;
proc sort data=cat.HN11_eye;
by id;
run;
data cat.HN11;/*공통적으로 id 가 있는 사람만 뽑음*/
merge cat.HN11_all (in=a)  cat.HN11_eye(in=b);
by id;
if a=1 and b=1;
drop E_Q_FAM1 E_Q_EXC1 E_PEO_1;
run;

/*2012*/
proc sort data=cat.HN12_all;
by id;
run;
proc sort data=cat.HN12_eye;
by id;
run;
data cat.HN12;/*공통적으로 id 가 있는 사람만 뽑음*/
merge cat.HN12_all (in=a)  cat.HN12_eye(in=b);
by id;
if a=1 and b=1;
drop E_Q_FAM1 E_Q_EXC1 E_PEO_1;
run;
data cat.HN101112;
set  cat.HN10  cat.HN11 cat.HN12;
run;

/*5개년도 data 를 set*/
data cat.HN5yr;
set cat.HN0809  cat.HN101112;run;
 
data cat.HN5yr_W;
set cat.HN5yr;
if year=2008 then wt_itvex_pool=wt_ex1*1/9;
if year=2008 then wt_hm_pool=wt_ex1hm*1/9;
if year=2009 then wt_itvex_pool= wt_itvex*2/9;
if year=2009 then wt_hm_pool= wt_hm*2/9;
if year=2010 then wt_itvex_pool=wt_itvex*2/9;
if year=2010 then wt_hm_pool=wt_hm*2/9;
if year=2011 then wt_itvex_pool= wt_itvex*2/9;
if year=2011 then wt_hm_pool= wt_hm*2/9;
if year=2012 then wt_itvex_pool= wt_itvex*2/9;
if year=2012 then wt_hm_pool= wt_hm*2/9;
run;
/*5개년도 40 이상dataset*/
data cat.HN5yr_age40;
set  cat.HN5yr_W;
where  age>=40;
run;


/*백내장변수 만들기*/
data cat.cat_20140210;
set cat.HN5yr_age40;
/*********************************************독립변수처리*

*****************************************************************************************************************************/
if  40<=age<=49 then age_G1=1;
else if 50<= age<=59 then age_G1=2;
else if 60<= age<=69 then age_G1=3;
else if 70<= age then age_G1=4;

if edu=.  then edu_G1=.;
else if  edu in (1,2) then edu_G1=1;
else if  edu in (3,4) then edu_G1=2;

if ho_incm=. then ho_incm_G1=.;
else if ho_incm in (1,2) then ho_incm_G1=1;/*≤50%*/
else if ho_incm in (3,4) then ho_incm_G1=2;/*>50%*/

if( year in (2008,2009)  and BS3_1=1 ) or (year in(2010,2011,2012) and BS3_1 in (1,2)) then BS_G1=3;/*현재*/
else if( year in (2008,2009)  and BS3_1=2 ) or (year in(2010,2011,2012) and BS3_1=3) then BS_G1=2;/*과거*/
else if (year in (2008,2009)  and BS1_1=3) or (year in(2010,2011,2012) and BS1_1=3) then BS_G1=1;/*비흡연*/

if occp=. then occp_g1=.;
else if occp in (1,2,3)  then occp_g1=1; /* White collar*/
else if occp in (4,5,6)  then occp_g1=2; /*  Blue collar*/ 
else if occp=7   then occp_g1=3; /*  Inoccupation*/ 

if town_t=. then town_t_g1=.;
else if town_t=1 then town_t_g1=1; /*Urban*/
else if town_t=2 then town_t_g1=2;/* Rural*/

if (year in (2008,2009) &  E_Q_OUT1=1 ) or (year in (2010,2011,2012) & E_Q_SUN in (1,2)) then sun_exp_g1=1;
else if (year in (2008,2009) &  E_Q_OUT1=2) or ( year in (2010,2011,2012)&  E_Q_SUN=3 ) then  sun_exp_g1=2;
else if (year in (2008,2009) &  E_Q_OUT1 in (8,9)) or ( year in (2010,2011,2012) & E_Q_SUN in(8,9) ) then  sun_exp_g1=.;
else if (year in (2008,2009) &  E_Q_OUT1=.) or (year in (2010,2011,2012) & E_Q_SUN=. ) then  sun_exp_g1=.;


/*검진자료*/
if HE_BMI=. then HR_BMI_G1=.;
else if HE_BMI<25 then HE_BMI_G1=1; /*25이하*/
else if 25<=HE_BMI then HR_BMI_G1=2;/*25이상*/

if (sex=1 and 90<=HE_wc)  or ( sex=2 and 80<=HE_wc) then HE_wc_g1=1;
else if (sex=1 and HE_wc<90) or (sex=2 and HE_wc<80) then HE_wc_g1=0;

if he_anem=. then he_anem_g1=.;
else if he_anem=0 then he_anem_g1=0;
else if he_anem=1 then he_anem_g1=1;

if HE_hepaB=. then HE_hepaB_g1=.;
else if HE_hepaB=0  then HE_hepaB_g1=0;
else if HE_hepaB=1  then HE_hepaB_g1=1;


/*Medical History*/

/*Hypertension_고혈압*/
if DI1_lt=. then Dl1_lt_g1=.;
else if  DI1_lt=1 then Dl1_lt_g1=1;
else if  DI1_lt=0 then Dl1_lt_g1=0;
else if  DI1_lt=9 then Dl1_lt_g1=.;

/*DM_당뇨병*/
if DE1_lt=. then DE1_lt_g1=.;
else if  DE1_lt=1 then DE1_lt_g1=1;
else if  DE1_lt=0 then DE1_lt_g1=0;
else if  DE1_lt=9  then DE1_lt_g1=.;

/*Dyslipidemia_이상지형증(2009는 고지혈증)*/
if DI2_lt=. then Dl2_lt_g1=.;
else if  DI2_lt=1 then Dl2_lt_g1=1;
else if  DI2_lt=0 then Dl2_lt_g1=0;
else if Dl2_lt=9  then Dl2_lt_g1=.;

/*Stroke_뇌졸중*/
if DI3_lt=. then Dl3_lt_g1=.;
else if  DI3_lt=1 then Dl3_lt_g1=1;
else if  DI3_lt=0 then Dl3_lt_g1=0;
else if Dl3_lt=9  then Dl3_lt_g1=.;

/*MI or IHD_심근경색 또는 협심증*/
if DI4_lt=. then Dl4_lt_g1=.;
else if  DI4_lt=1 then Dl4_lt_g1=1;
else if  DI4_lt=0 then Dl4_lt_g1=0;
else if  Dl4_lt=9  then Dl4_lt_g1=.;

/*OA or RA_관절염 또는 류마티스*/
if DM1_lt=. then DM1_lt_g1=.;
else if DM1_lt=1 then DM1_lt_g1=1;
else if DM1_lt=0 then DM1_lt_g1=0;
else if DM1_lt=9  then DM1_lt_g1=.;

/*Pulmonary Tb_폐결핵*/
if DJ2_lt=. then DJ2_lt_g1=.;
else if DJ2_lt=1 then DJ2_lt_g1=1;
else if DJ2_lt=0 then DJ2_lt_g1=0;
else if DJ2_lt=9  then DJ2_lt_g1=.;


/*Asthma:천식*/
if DJ4_lt=. then DJ4_lt_g1=.;
else if DJ4_lt=1 then DJ4_lt_g1=1;
else if DJ4_lt=0 then DJ4_lt_g1=0;
else if DJ4_lt=9  then DJ4_lt_g1=.;


/*Thyroid disease: 갑산샘*/

if DE2_lt=. then DE2_lt_g1=.;
else if DE2_lt=1 then DE2_lt_g1=1;
else if DE2_lt=0 then DE2_lt_g1=0;
else if DE2_lt=9  then DE2_lt_g1=.;
run;

data cat.cat_20140210;
set cat.cat_20140210;

/*******************************************************************************종속변수*
*********************************************************************************************************8888/
/*우안*/
if E_Tr_y=. then CatSx_R1=.; /*백내장_백내장유무_우안*/
else if E_Tr_y in (1,2) then CatSx_R1=0;/*수술 안한눈*/
else if E_Tr_y in (3,4) then CatSx_R1=1; /*수술한눈*/
else if E_Tr_y =8 then CatSx_R1=2; /*비해당19세 이하*/
else if E_Tr_y =9 then CatSx_R1=3; /*미검진*/

if E_Tr_y=. then CatSx_R2=.; /*백내장_백내장유무_우안*/
else if E_Tr_y in (1,2) then CatSx_R2=0;/*수술 안한눈*/
else if E_Tr_y in (3,4) then CatSx_R2=1; /*수술한눈*/
else if E_Tr_y =8 then CatSx_R2=.;/*비해당19세 이하*/
else if E_Tr_y =9 then CatSx_R2=3;/*미검진*/


if E_Tr_y=. then CatSx_R3 =.; /*백내장_백내장유무_우안*/
else if E_Tr_y in (1,2) then CatSx_R3=0;/*수술 안한눈*/
else if E_Tr_y=3 then CatSx_R3=2; /*백내장 수술을 받은 인공수정체군*/
else if E_Tr_y=4 then CatSx_R3=3; /*백내장 수술을 받은 무수정체군*/
else if E_Tr_y in (8,9) then CatSx_R3=.;


/*좌안*/
if E_Tl_y=. then CatSx_L1=.;/*백내장_백내장유무_좌안*/
else if E_Tl_y in (1,2) then CatSx_L1=0;/*수술 안한눈*/
else if E_Tl_y in (3,4) then CatSx_L1=1; /*수술한눈*/
else if E_Tl_y=8  then CatSx_L1=2;/*비해당19세 이하*/
else if E_Tl_y=9  then CatSx_L1=3;/*미검진*/

if E_Tl_y=. then CatSx_L2=.;/*백내장_백내장유무_좌안*/
else if E_Tl_y in (1,2) then CatSx_L2=0;/*수술 안한눈*/
else if E_Tl_y in (3,4) then CatSx_L2=1; /*수술한눈*/
else if E_Tl_y=8  then CatSx_L2=.;/*비해당19세 이하*/
else if E_Tl_y=9  then CatSx_L2=3;/*미검진*/

if E_Tl_y=. then CatSx_L3 =.; /*백내장_백내장유무_우안*/
else if E_Tl_y in (1,2) then CatSx_L3 =0;/*수술 안한눈*/
else if E_Tl_y=3 then CatSx_L3 =2; /*백내장 수술을 받은 인공수정체군*/
else if E_Tl_y=4 then CatSx_L3 =3; /*백내장 수술을 받은 무수정체군*/
else if E_Tl_y in (8,9) then CatSx_L3 =.;


/*백내장 유병여부*/
if E_vs_ty=. then E_vs_ty_cat=.;
else if E_vs_ty=0 then E_vs_ty_cat=0;/*없음*/
else if E_vs_ty=1 then E_vs_ty_cat=1;/*있음*/


/*양쪽눈을 모두 합한것*/

/*변수명 “Cat_Include” = 1 (하나라도 [1,2,3,4]), 9 (둘 다 [9])*/
if (E_Tr_y=. and  E_Tl_y=.)  then  Cat_Inc=.; 
else if E_Tr_y in (1,2,3,4) or E_Tl_y in (1,2,3,4)  then Cat_Inc=1;
else if (E_Tr_y=9 and  E_Tl_y=9)  then  Cat_Inc=0;

/*B.	우안/좌안 각각에서 (1,2,3,4) 인 수와 (9) 인 수도 확인*/
if  E_Tr_y=. then  Cat_Inc_R=.; 
else if E_Tr_y in (1,2,3,4)  then Cat_Inc_R=1;
else if E_Tr_y=9  then  Cat_Inc_R=0;

if  E_Tl_y=. then  Cat_Inc_L=.; 
else if E_Tl_y in (1,2,3,4)  then Cat_Inc_L=1;
else if E_Tl_y=9  then  Cat_Inc_L=0;

if CatSx_R1=0  and  CatSx_L1= 0 then CatSx_Prev=0; /*양눈백내장 수술 안한군*/
else if  CatSx_R1=1 and CatSx_L1=1 then CatSx_Prev=1; /*양눈다 수술한군*/
else if  CatSx_R1=1 and CatSx_L1=0 then CatSx_Prev=2; /*오른눈만 수술*/
else if  CatSx_R1=0 and CatSx_L1=1 then CatSx_Prev=3; /*왼쪽만 수술*/
else if  CatSx_R1=1 or CatSx_L1=1  then CatSx_Prev=4; /*둘 중 한쪽만 수술*/


if CatSx_R1=0  and  CatSx_L1= 0 then CatSx_Prev1=0; /*양눈백내장 수술 안한군*/
else if  CatSx_R1=1 or CatSx_L1=1  then CatSx_Prev1=1; /*둘 중 한쪽만 수술*/
run;


/*분석 시작*/
ods pdf file='Included Participants vs	Excluded Participants(수술여부아는 사람과 미검진.pdf';
proc surveyfreq data= cat.cat_20140210 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
tables Cat_Inc*age_g1/row cl chisq;
tables Cat_Inc*sex/row cl chisq;
tables Cat_Inc*BS_g1/row cl chisq;
tables Cat_Inc*ho_incm_G1/row cl chisq;
tables Cat_Inc*edu_G1/row cl chisq;
tables Cat_Inc*occp_g1/row cl chisq;
tables Cat_Inc*town_t_g1/row cl chisq;
tables Cat_Inc*sun_exp_g1/row cl chisq;
tables Cat_Inc*Dl1_lt_g1/row cl chisq;
tables Cat_Inc*DE1_lt_g1/row cl chisq;
tables Cat_Inc*Dl2_lt_g1/row cl chisq;
tables Cat_Inc*Dl3_lt_g1/row cl chisq;
tables Cat_Inc*Dl4_lt_g1/row cl chisq;
tables Cat_Inc*DM1_lt_g1/row cl chisq;
tables Cat_Inc*DJ2_lt_g1/row cl chisq;
tables Cat_Inc*DJ4_lt_g1/row cl chisq;
tables Cat_Inc*DE2_lt_g1/row cl chisq;
tables Cat_Inc*HE_BMI_G1/row cl chisq;
tables Cat_Inc*HE_wc_g1/row cl chisq;
tables Cat_Inc*HE_anem_g1/row cl chisq;
tables Cat_Inc*HE_hepaB_g1/row cl chisq;
run;
ods pdf close;



/*미검진을 제외한 최종20010명으로 분석시작*/
data cat.cat_20140210_20010;
set  cat.cat_20140210;
where Cat_Inc=1;
run;

/*연령에 따른 그림*/
ods pdf file='연령에 따른 그림(E_vs_ty_cat ).pdf';
proc surveyfreq data= cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
tables E_vs_ty_cat*age_g1* sex/row cl chisq;
run;
proc surveyfreq data= cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
tables age_g1*E_vs_ty_cat* sex/row cl chisq;
run;
proc surveyfreq data= cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
tables sex*age_g1*E_vs_ty_cat/row cl chisq;
run;
ods pdf close;

ods pdf file='연령에 따른 그림(CatSx_Prev1).pdf';
proc surveyfreq data= cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
tables CatSx_Prev1*age_g1* sex/row cl chisq;
run;
proc surveyfreq data= cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
tables age_g1*CatSx_Prev1* sex/row cl chisq;
run;
proc surveyfreq data= cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
tables sex*age_g1*CatSx_Prev1/row cl chisq;
run;
ods pdf close;



ods pdf file='table2(E_vs_ty_cat ).pdf';
proc surveymeans data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
domain E_vs_ty_cat;
var age_g1;
run;
proc surveyfreq data= cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
tables age_g1* E_vs_ty_cat/row cl chisq;
run;
ods pdf close;


ods pdf file='table2(CatSx_Pre1수술한 군과 안한군).pdf';
proc surveymeans data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
domain CatSx_Prev1;
var age_g1;
run;
proc surveyfreq data= cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
tables age_g1* CatSx_Prev1/row cl chisq;
run;
ods pdf close;





/*백내장유병에 영향을 주는 risk*/
ods pdf file='  CatSx_Prev1 ((백내장 수술여부).pdf';
proc surveyfreq data= cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
tables  CatSx_Prev1*age_g1/row cl chisq;
tables  CatSx_Prev1*sex/row cl chisq;
tables  CatSx_Prev1*BS_g1/row cl chisq;
tables  CatSx_Prev1*ho_incm_G1/row cl chisq;
tables  CatSx_Prev1*edu_G1/row cl chisq;
tables  CatSx_Prev1*occp_g1/row cl chisq;
tables  CatSx_Prev1*town_t_g1/row cl chisq;
tables  CatSx_Prev1*sun_exp_g1/row cl chisq;
tables  CatSx_Prev1*Dl1_lt_g1/row cl chisq;
tables  CatSx_Prev1*DE1_lt_g1/row cl chisq;
tables  CatSx_Prev1*Dl2_lt_g1/row cl chisq;
tables  CatSx_Prev1*Dl3_lt_g1/row cl chisq;
tables  CatSx_Prev1*Dl4_lt_g1/row cl chisq;
tables  CatSx_Prev1*DM1_lt_g1/row cl chisq;
tables  CatSx_Prev1*DJ2_lt_g1/row cl chisq;
tables  CatSx_Prev1*DJ4_lt_g1/row cl chisq;
tables  CatSx_Prev1*DE2_lt_g1/row cl chisq;
tables  CatSx_Prev1*HE_BMI_G1/row cl chisq;
tables  CatSx_Prev1*HE_wc_g1/row cl chisq;
tables  CatSx_Prev1*HE_anem_g1/row cl chisq;
tables  CatSx_Prev1*HE_hepaB_g1/row cl chisq;
run;
ods pdf close;



ods pdf file=' E_vs_ty_cat (백내장 유병여부).pdf';
proc surveyfreq data= cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
tables  E_vs_ty_cat*age_g1/row cl chisq;
tables  E_vs_ty_cat*sex/row cl chisq;
tables  E_vs_ty_cat*BS_g1/row cl chisq;
tables  E_vs_ty_cat*ho_incm_G1/row cl chisq;
tables  E_vs_ty_cat*edu_G1/row cl chisq;
tables  E_vs_ty_cat*occp_g1/row cl chisq;
tables  E_vs_ty_cat*town_t_g1/row cl chisq;
tables  E_vs_ty_cat*sun_exp_g1/row cl chisq;
tables  E_vs_ty_cat*Dl1_lt_g1/row cl chisq;
tables  E_vs_ty_cat*DE1_lt_g1/row cl chisq;
tables  E_vs_ty_cat*Dl2_lt_g1/row cl chisq;
tables  E_vs_ty_cat*Dl3_lt_g1/row cl chisq;
tables  E_vs_ty_cat*Dl4_lt_g1/row cl chisq;
tables  E_vs_ty_cat*DM1_lt_g1/row cl chisq;
tables  E_vs_ty_cat*DJ2_lt_g1/row cl chisq;
tables  E_vs_ty_cat*DJ4_lt_g1/row cl chisq;
tables  E_vs_ty_cat*DE2_lt_g1/row cl chisq;
tables  E_vs_ty_cat*HE_BMI_G1/row cl chisq;
tables  E_vs_ty_cat*HE_wc_g1/row cl chisq;
tables  E_vs_ty_cat*HE_anem_g1/row cl chisq;
tables  E_vs_ty_cat*HE_hepaB_g1/row cl chisq;
run;
ods pdf close;


ods pdf file='simple logi( E_vs_ty_cat)_1.pdf';
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class age_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=age_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class sex(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=sex/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class ho_incm_G1(ref='2')/param=ref;
model E_vs_ty_cat(event='1')=ho_incm_G1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class edu_G1(ref='2')/param=ref;
model E_vs_ty_cat(event='1')=edu_G1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class occp_g1(ref='2')/param=ref;
model E_vs_ty_cat(event='1')=occp_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  town_t_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')= town_t_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  sun_exp_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')= sun_exp_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  HE_BMI_G1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')= HE_BMI_G1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  HE_wc_g1(ref='0')/param=ref;
model E_vs_ty_cat(event='1')=HE_wc_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  Dl1_lt_g1(ref='0')/param=ref;
model E_vs_ty_cat(event='1')=Dl1_lt_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DE1_lt_g1(ref='0')/param=ref;
model E_vs_ty_cat(event='1')=DE1_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class Dl2_lt_g1(ref='0')/param=ref;
model E_vs_ty_cat(event='1')=Dl2_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class Dl3_lt_g1(ref='0')/param=ref;
model E_vs_ty_cat(event='1')=Dl3_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class Dl4_lt_g1(ref='0')/param=ref;
model E_vs_ty_cat(event='1')=Dl4_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DM1_lt_g1(ref='0')/param=ref;
model E_vs_ty_cat(event='1')=DM1_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DJ2_lt_g1(ref='0')/param=ref;
model E_vs_ty_cat(event='1')=DJ2_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DJ4_lt_g1(ref='0')/param=ref;
model E_vs_ty_cat(event='1')=DJ4_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DE2_lt_g1(ref='0')/param=ref;
model E_vs_ty_cat(event='1')=DE2_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class HE_anem_g1(ref='0')/param=ref;
model E_vs_ty_cat(event='1')=HE_anem_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class HE_hepaB_g1(ref='0')/param=ref;
model E_vs_ty_cat(event='1')=HE_hepaB_g1/vadjust=none;
run;
ods pdf close;



ods pdf file='adjusted logi( E_vs_ty_cat)_2.pdf';
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=age_g1 sex BS_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class ho_incm_G1(ref='2')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=ho_incm_G1 age_g1 sex BS_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class edu_G1(ref='2')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=edu_G1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class occp_g1(ref='2')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=occp_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  town_t_g1(ref='1')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')= town_t_g1 age_g1 sex BS_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  sun_exp_g1(ref='1')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')= sun_exp_g1 age_g1 sex BS_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  HE_BMI_G1(ref='1')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')= HE_BMI_G1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  HE_wc_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=HE_wc_g1 age_g1 sex BS_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  Dl1_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=Dl1_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DE1_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=DE1_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class Dl2_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=Dl2_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class Dl3_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=Dl3_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class Dl4_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=Dl4_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DM1_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=DM1_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DJ2_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=DJ2_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DJ4_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=DJ4_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DE2_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=DE2_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class HE_anem_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=HE_anem_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class HE_hepaB_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model E_vs_ty_cat(event='1')=HE_hepaB_g1 age_g1 sex BS_g1/vadjust=none;
run;
ods pdf close;





ods pdf file='simple logi( CatSx_Prev1)_1.pdf';
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class age_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=age_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class sex(ref='1')/param=ref;
model CatSx_Prev1(event='1')=sex/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class ho_incm_G1(ref='2')/param=ref;
model CatSx_Prev1(event='1')=ho_incm_G1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class edu_G1(ref='2')/param=ref;
model CatSx_Prev1(event='1')=edu_G1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class occp_g1(ref='2')/param=ref;
model CatSx_Prev1(event='1')=occp_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  town_t_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')= town_t_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  sun_exp_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')= sun_exp_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  HE_BMI_G1(ref='1')/param=ref;
model CatSx_Prev1(event='1')= HE_BMI_G1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  HE_wc_g1(ref='0')/param=ref;
model CatSx_Prev1(event='1')=HE_wc_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  Dl1_lt_g1(ref='0')/param=ref;
model CatSx_Prev1(event='1')=Dl1_lt_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DE1_lt_g1(ref='0')/param=ref;
model CatSx_Prev1(event='1')=DE1_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class Dl2_lt_g1(ref='0')/param=ref;
model CatSx_Prev1(event='1')=Dl2_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class Dl3_lt_g1(ref='0')/param=ref;
model CatSx_Prev1(event='1')=Dl3_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class Dl4_lt_g1(ref='0')/param=ref;
model CatSx_Prev1(event='1')=Dl4_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DM1_lt_g1(ref='0')/param=ref;
model CatSx_Prev1(event='1')=DM1_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DJ2_lt_g1(ref='0')/param=ref;
model CatSx_Prev1(event='1')=DJ2_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DJ4_lt_g1(ref='0')/param=ref;
model CatSx_Prev1(event='1')=DJ4_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DE2_lt_g1(ref='0')/param=ref;
model CatSx_Prev1(event='1')=DE2_lt_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class HE_anem_g1(ref='0')/param=ref;
model CatSx_Prev1(event='1')=HE_anem_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class HE_hepaB_g1(ref='0')/param=ref;
model CatSx_Prev1(event='1')=HE_hepaB_g1/vadjust=none;
run;
ods pdf close;



ods pdf file='adjusted logi( CatSx_Prev1)_2.pdf';
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=age_g1 sex BS_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class ho_incm_G1(ref='2')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=ho_incm_G1 age_g1 sex BS_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class edu_G1(ref='2')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=edu_G1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class occp_g1(ref='2')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=occp_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  town_t_g1(ref='1')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')= town_t_g1 age_g1 sex BS_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  sun_exp_g1(ref='1')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')= sun_exp_g1 age_g1 sex BS_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  HE_BMI_G1(ref='1')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')= HE_BMI_G1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  HE_wc_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=HE_wc_g1 age_g1 sex BS_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class  Dl1_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=Dl1_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;

proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DE1_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=DE1_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class Dl2_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=Dl2_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class Dl3_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=Dl3_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class Dl4_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=Dl4_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DM1_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=DM1_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DJ2_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=DJ2_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DJ4_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=DJ4_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class DE2_lt_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=DE2_lt_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class HE_anem_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=HE_anem_g1 age_g1 sex BS_g1/vadjust=none;
run;
proc surveylogistic  data=cat.cat_20140210_20010 nomcar;
strata kstrata;
cluster PSU;
weight wt_itvex_pool;
class HE_hepaB_g1(ref='0')  age_g1(ref='1') sex(ref='1') BS_g1(ref='1')/param=ref;
model CatSx_Prev1(event='1')=HE_hepaB_g1 age_g1 sex BS_g1/vadjust=none;
run;
ods pdf close;
