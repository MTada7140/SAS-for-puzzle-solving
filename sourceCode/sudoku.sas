/*////////////////////////////////////////////
//////////////////////////////////////////////
/// SAS program                            ///
///                                        ///
///            "Sudoku Solver"             ///
///                                        ///
///                            M.Tada 2017 ///
//////////////////////////////////////////////
////////////////////////////////////////////*/

/*///////////////////////////////// 
/  Reading a problem into memory  /
/  neme of variable ; l_tot       /
/////////////////////////////////*/
data SudokuProblem;
length line $9. totLine $100.;
retain totLine '';
infile cards;
input line;
totLine=cats(totLine,line);
if _n_ = 9 then call symput('l_tot',totLine);
cards;
..6....4.
79.3...5.
....72..1
..37.8.9.
..9...5..
.2.5.61..
9..28....
.6...4.15
.8....7..
;

/* Generating Permutations */
data permute1;
length NewSerie $20.;
NewSerie = '1';
run;

%macro permute(start,stop);
%do  num   = &start %to &stop;
%let num1  = %eval(&num-1);
	data permute&num;
	set  permute&num1;
	NewChar       = put(&num,$1.);
	OriginalSerie = newSerie;
	Do i = 1 to length(OriginalSerie)+1;
    	if i = 1 
    		then NewSerie = NewChar||OriginalSerie;
    		else if i = length(OriginalSerie)+1 then NewSerie = trim(OriginalSerie)||NewChar;
    			 else NewSerie = substr(OriginalSerie,1,i-1)||NewChar||substr(OriginalSerie,i,length(OriginalSerie)-i+1);
    	drop NewChar i;
    	output;
	end;    
run;
%end;
%mend permute;

%permute(start=2, stop= 9);

/*//////////////////////////////////////////
/      Selection using problem data        /
/ (eliminating inappropriate permutations) /
/  name of output datasets                 / 
/          ; select1 - select9             /
//////////////////////////////////////////*/
%macro selection(start,stop);
%do  num   = &start %to &stop;
data select&num(keep=result);
length result $9.;
set permute9;
array line {9} $9.; 
array problem {9,9} $1.; 
var1="&l_tot";
do i = 1 to 9;
    line{i} = substr(var1,(i-1)*9+1,9);
    do j = 1 to 9;
    	problem{i,j} = substr(line{i},j,1);
    end;
end;
deletePermute = 0; 
do i = 1 to 9;
    do j = 1 to 9; 
        if i = &num then do;
            if       problem{i,j}         ne '.' 
                and  substr(newSerie,j,1) ne problem{i,j}
                then deletePermute        =  1;
        end;
        else do;
            if       problem{i,j}         ne '.' 
                and  substr(newSerie,j,1) =  problem{i,j}      
                then deletePermute        = 1;
        end;
    end;
    if deletePermute        = 0 then do;
        if mod(&num, 3) = 1 then do; i1=&num+1; i2=&num+2; end;
        else if mod(&num, 3) = 2 then do; i1=&num-1; i2=&num+1; end;
        else  do; i1=&num-2; i2=&num-1; end;
    	do j = 1 to 3;
        	do k = 1 to 3;
            	do l = 1 to 3;
                	if  substr(newSerie,(j-1)*3+k,1) = problem{i1,(j-1)*3+l} 
                 	or substr(newSerie,(j-1)*3+k,1) = problem{i2,(j-1)*3+l}
                 	then deletePermute        = 2;
            	end;
        	end;
    	end;
    end;
end;
result           =        newserie; 
if deletePermute ne 0 then delete;
run;
%end;
%mend selection;

%selection(start=1, stop= 9);

/*////////////////////////////////////////////////////
/  Find answer of this problem and put into dataset  /
/  data set name of final answer                     / 
/          ; Answer9                                 /
////////////////////////////////////////////////////*/
data answer1(keep=tempAns);
length tempAns $100.;
set select1;
tempAns=result;
run;

%macro answer(start,stop);
%do  num = &start %to &stop;
%let num1  = %eval(&num-1);
data _null_;
set select&num end = last;
length line $9. totLine $10000. var0 $1.;
retain totLine '';
totLine=cats(totLine,result);
var0="&num";
call symput('lines'||trim(var0),totLine);
var=symget('lines'||trim(var0));
run;
data answer&num(keep=tempAns tempChk chkFlg);
length var $10000. var0 $1.;
var0 = "&num";
var=symget('lines'||trim(var0));
vlen=length(var);
set answer&num1;
reserveValue = tempAns;
lenAns = length(tempAns);   
do j = 1 to vlen by 9;
    tempChk = substr(var,j,9);
    chkFlg  = 0;
    do l = 1 to lenAns by 9;
    	tempTempAns = substr(tempAns,l,9); 
    	do m = 1 to 9;
        	if substr(tempTempAns,m,1) = substr(tempChk,m,1) then  chkFlg  = 1;
    	end;
    end;	
    if chkFlg = 0 then do;
        tempAns = cats(tempAns,tempChk);
        output ;
        tempAns = reserveValue; 
    end;
end;
run;
%end;
%mend answer;

%answer(start=2, stop= 9);

/*/////////////////////////////////////
/  Transpose final answer data set    /
/  into single line format.           /
/  output data set name : finalAnswer /
/////////////////////////////////////*/
data finalAnswer(keep=ansNum ansLine);
set answer9;
retain ansNum 1;
do i = 1 to 9;
    ansLine = substr(tempAns,(i-1)*9+1,9);
    output;
end;
ansNum + 1;
run;
    
proc print data=finalanswer noobs;
by ansNum;
run;

