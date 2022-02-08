
/* ======================================================
 * Program: Stata连享会_CHFS数据处理
 * Data:	CHFS 2015 2017 
 * Aim:   	Have fun with Stata 
 * Revised: 06/03/2021
 ======================================================== */

clear
global root= "D:\study\环院\高级计量经济学\复刻论文\数据处理"       //在 E 盘自动创建 CHFS 研究题目，并在其下创建 9 个子文件夹，可以直接修改路径创建研究话题
global dofiles= "$root\Dofiles"
global rawdata= "$root\Rawdata"
global workingdata= "$root\Workingdata"
global process="$root\process"
*******************************************自动生成文件夹
cap mkdir "$rawdata"
cap mkdir "$workingdata"
cap mkdir "$dofiles"
cap mkdir "$process"
*******************************************设置stata环境
*******************************************global dofiles= "$root/Dofiles"
*global logfiles= "$root/Logfiles"           
*global raw_data= "$root/Raw_data"
*global working_data= "$root/Working_data"
*global temp_data= "$root/Temp_data"
*global tables= "$root/Tables"
*global figures= "$root/Figures"
*cap !mkdir "$raw_data"              
*cap mkdir "$temp_data"                //自动创建文件夹
*cap mkdir "$working_data"
*cap mkdir "$tables"                   // `cap` 命令可让错误的代码继续运行
*cap mkdir "$figures"
*cap mkdir "$dofiles"                  //如果已经创建了这些文件夹，也可以运行
*cap mkdir "$logfiles"
*cap mkdir "$root/Paper"
*cap mkdir "$root/References"
*cap mkdir "$raw_data"
*cap mkdir  "$working_data"
*cap mkdir "$figures"                     //以上命令在每次打开 do 文件都可运行

/* log,记录结果窗口 */
cap log close
log using $logfiles/CHFS数据清洗.log, replace

/* use,导入原始数据 */ 
set matsize 5000
set more off
use "$root\Rawdata\chfs2013_hh_20191120_version14.dta",clear


drop if (asset < 0) | (total_income < 0)
gen risk_dummy (d3101 == 1)|(d4100a == 1)|(d5102 == 1)|(d6102 == 1)|(d7102 == 1)|(d7107 == 1)|(d8100a == 1)|(d9100a == 1)
gen stock_dummy = 1 if (d3101 == 1)
replace stock_dummy = 0 if (d3101 == 2)
gen risk_like = 1 if (a4003 == 1)|(a4003 == 2)
replace risk_like = 0 if (a4003 == 4)|(a4003 == 5)|(a4003 == 3)
gen risk_averse = 1 if (a4003 == 4)|(a4003 == 5)
replace risk_averse = 1 if (a4003 == 1)|(a4003 == 2)|(a4003 == 3)
gen self_business = 1 if (b2001 == 1)
replace self_business = 0 if (b2001 == 2)
gen house = 1 if (c1001 == 1)
replace house = 0 if (c1001 == 2)
gen family_size = a2000
gen in_income = log(total_income)
gen in_wealth = log(asset)
// gen debt_ratio = (d3116b + d4110b + d5108b + d6115b + d7111b + d8105b + e1006 + e1022 + e1022it + e2015 + f3004c + f3004cit)/asset

/* 对各种区间变量进行处理 */ 

foreach i in d3109it d3116it d4103it_1 d4103it_2 d4103it_3 d4103it_4 d4103it_5 d5107it d6106ait d6110it d6115it d7106ait d7110it d8104it_1 d8104it_2 d8104it_3 d8104it_4 d8104it_5 d8104it_6 d8104it_7 d8104it_8 d9103it k1101it d3103it d1105it d2104it{
	
	replace `i' = 2500 if (`i' == 1) 
	replace `i' = 12500 if (`i' == 2) 
	replace `i' = 35000 if (`i' == 3) 
	replace `i' = 75000 if (`i' == 4) 
	replace `i' = 150000 if (`i' == 5) 
	replace `i' = 350000 if (`i' == 6) 
	replace `i' = 750000 if (`i' == 7)
	replace `i' = 1500000 if (`i' == 8) 
	replace `i' = 3500000 if (`i' == 9) 
	replace `i' = 7500000 if (`i' == 10) 
	replace `i' = 10000000 if (`i' == 11) 
}
foreach i in e1022it e3004cit{
	
	replace `i' = 5000 if (`i' == 1) 
	replace `i' = 15000 if (`i' == 2) 
	replace `i' = 35000 if (`i' == 3) 
	replace `i' = 75000 if (`i' == 4) 
	replace `i' = 150000 if (`i' == 5) 
	replace `i' = 350000 if (`i' == 6) 
	replace `i' = 750000 if (`i' == 7)
	replace `i' = 1500000 if (`i' == 8) 
	replace `i' = 3500000 if (`i' == 9) 
	replace `i' = 7500000 if (`i' == 10) 
	replace `i' = 10000000 if (`i' == 11) 
}

foreach i in k1101it{
	
	replace `i' = 1000 if (`i' == 1) 
	replace `i' = 3500 if (`i' == 2) 
	replace `i' = 7500 if (`i' == 3) 
	replace `i' = 15000 if (`i' == 4) 
	replace `i' = 25000 if (`i' == 5) 
	replace `i' = 40000 if (`i' == 6) 
	replace `i' = 75000 if (`i' == 7)
	replace `i' = 150000 if (`i' == 8) 
	replace `i' = 350000 if (`i' == 9) 
	replace `i' = 500000 if (`i' == 10) 
}
gen gpsz=d3109+d3109it+d3116+d3116it
gen zqsz=d4103_1+d4103_2+d4103_3+d4103_4+d4103_5 +d4103it_1+d4103it_2+d4103it_3+d4103it_4+d4103it_5
gen jjsz=d5107+d5107it
gen yspsz=d6106a+d6106ait+d6110+d6110it+d6115+d6115it
gen jrlccpsz=d7106a+d7106ait+d7110+d7110it
gen frmbzcsz=d8104_1+d8104_2+d8104_3+d8104_4+d8104_5+d8104_6+d8104_7+d8104_8+d8104it_1+d8104it_2+d8104it_3+d8104it_4+d8104it_5+d8104it_6+d8104it_7+d8104it_8
gen hjsz=d9103+d9103it
gen scxz=k1101+k1101it
gen gpzhye=d3103+d3103it
gen hqck=d1105+d1105it
gen dqck=d2104+d2104it
gen risk_asset=gpsz+zqsz+jjsz+yspsz+jrlccps+frmbzcsz+hjsz
gen riskfree_asset=scxz+gpzhye+hqck+dqck
gen risk_ratio=risk_asset/(risk_asset+riskfree_asset)
gen stock_ratio=gpsz/(risk_asset+riskfree_asset)
gen total_debt=d3116b+d4110b+d5108b+d6115b+d7111b+d8105b+e1006*10000+e1022+e1022it+e2015_1+e2015_2+e3004c+e3004cit
gen debt_ratio=total_debt/asset













