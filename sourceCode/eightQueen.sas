/*//////////////////////////////////////////
//SAS PROGRAM                             //
//                                        //  
//           Solving Eight Queen          //
//                                        //
//                            M.Tada 2017 //
//////////////////////////////////////////*/
option spool;

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

%permute(start=2, stop= 8);

/* Selecting Solutions */
data EightQueen;
set permute8;
array panel{*} q1-q8;
do i = 1 to 8;
    panel{i} = input(substr(NewSerie,i,1),1.);
end;
failQ = 0;
do i = 1 to 8;
    do j = i+1 to 8;
        distCol = abs(panel{i}-panel{j});
        distRow = j-i;
        if distCol = distRow then failQ = 1;
    end;
end;
keep q1-q8;
if failQ = 1 then delete;  
run;

/* Checking the 'identical' solutions */
data checkIdenticalQueen(keep=combQueen1);
set eightqueen;
array Queen{8} q1-q8;
array flipQueen{8} $1.;
array combQueen{8} $8.;
array temp{8}      $1.;
array ftemp{8}     $1.;
/* concatenating the single position data into sequence data */
combQueen{1} = cats(of Queen{*});
/* flipping the sequence right side left */
do i = 1 to 8;
    flipQueen{i} = 9 - Queen{i};
end;
combQueen{5} = cats(of flipQueen{*});
/* rotating the sequence by 90degree at one iteration */
do rotation = 2 to 4;
    do i = 1 to 8;
        temp{9 - Queen{i}}      = i; 
        ftemp{9 - flipQueen{i}} = i;
    end;
    do i = 1 to 8; 
        Queen{i}                = temp{i}; 
        flipQueen{i}            = ftemp{i};
    end;
combQueen{rotation}   = cats(of Queen{*});
combQueen{rotation+4} = cats(of flipQueen{*});
end;
/* sort the output array horizontally */
call sortc(of combQueen{*});
run;

/* use proc sort for eliminating duplicate data from the solution dataset */
proc sort data=checkIdenticalQueen nodup;
by combQueen1;
run;

/* Printing Solutions */
data QueenForPrint(keep=SolveNo Position);
set checkIdenticalQueen;
retain SolveNo 1;
do i = 1 to 8;
    Position = substr(combQueen1,i,1); 
    output;
end;
SolveNo + 1;
run;

proc format;
value $Queen
    '1'='|Ｑ|．|．|．|．|．|．|．|'
    '2'='|．|Ｑ|．|．|．|．|．|．|'
    '3'='|．|．|Ｑ|．|．|．|．|．|'
    '4'='|．|．|．|Ｑ|．|．|．|．|'
    '5'='|．|．|．|．|Ｑ|．|．|．|'
    '6'='|．|．|．|．|．|Ｑ|．|．|'
    '7'='|．|．|．|．|．|．|Ｑ|．|'
    '8'='|．|．|．|．|．|．|．|Ｑ|';
run;

proc print data=QueenForPrint noobs;
by SolveNo;
format Position $Queen.;
run;

