# 1.Solving Eight Queen 

## 1-1.What is 'Eight Queen'?
###   According to Wikipedia, 'Eight Queen' puzzle is defined as follows. *"The eight queens puzzle is the problem of placing eight chess queens on an 8×8 chessboard so that no two queens threaten each other. Thus, a solution requires that no two queens share the same row, column, or diagonal. The eight queens puzzle is an example of the more general n queens problem of placing n non-attacking queens on an n×n chessboard, for which solutions exist for all natural numbers n with the exception of n=2 and n=3."* One of the solution is shown on image below(image has taken from Wikipedia).
![Eight Queen](/images/EightQueenPuzzle.jpg)
## 1-2.How to solve?
### To determine how  to solve this puzzle by SAS programming, let's have a look at the definition by Wiki again. It says, *"a solution requires that no two queens share the same row, column, or diagonal"*. In order to represent the a solution, I would like to use an array consists of eight elements. With this expression, the sample solution on above image can be converted into array of '{6,4,7,1,8,2,5,3}'. It means every element of this array represents the 'horizontal' position in a row of chess board. And to look at the array you will notice easily that there are no duplicate number in a solution array. With noticing this, it can be concluded that it is possible to devide the solving of 'Eight Queen' puzzle process into two stages. They are; stage1) generating the whole permutations with numbers from 1 to 8. stage2)select the permutations which satisfy all the rules. In other words, in stage1, we can list up the entire set of possible solutions hence in stage2, we can list up all the solutions out of the entire set. Let's see how to program these steps in SAS in following sections.    
## 1-3.Generating permutations
### To generate permutations, there would be several ways to do it. In this article, I would like to employ an algorithm called "The insert-into-all-positions solution" which I've found on the website called "Type Ocaml"(url:http://typeocaml.com/2015/05/05/permutation/). The idea of this algorithm is quite simple and easy to apply for SAS programming. In this algorithm, we assume that we have already got the entire set of permutations with length of 'n-1'. And when we would like to get the whole set of permutations with length of 'n', we can insert the number of 'n' into every possible position of existing set of permutations. Let's look at the following image to have clearer understanding;
![Permutation Algorithm](/images/permutation1.jpg)
### In the above image, we already have the set of permutations consist of three numbers and trying to have set with length of four. In this case, there are four positions we can insert number '4' into existing permutations.
![Permutation Algorithm2](/images/permutation2.jpg)
### To apply this manipulation on the entire set of existing permutations, we can get the right set of permutations with length of four. To convert this process into SAS program, it looks like as following.
![SASpgm Permutation](/images/SASpgmPermute.jpg)
### In the program above, we reead SAS dataset 'permute3' as input and output 'permute4'. In the input dataset, there is a variable(in the different language, it is called 'column' or 'item') named 'newSerie' which contains one permutation sequence with length of three. And in the 'Do loop' in the middle insert number '4' in the all possible positions of input permutation.
### But with the sample above, we must copy and paste the code above several times and modify them. It would not be a good programming practice. To avoid this, I introduced 'macro' feature of SAS program and created the code below.  
![SASpgm Permutation2](/images/SASpgmPermute2.jpg)
### All the basic ideas are the same as previous sample, but generalisation by 'macro variable' and 'macro programming' were used in the later one. The last command line "%permute(start=2, stop= 8);" invokes the macro program above and iterates the program seven times with varying macro variable '&num' from 2 to 8. Thus, we can get the entire set of permutations with length of eight. 

## 1-4.Selecting solutions from whole permutations
### The next step for solving 'Eight Queen' is the selection of permutations which stisfy all the rules. All the rules? We already have the candidates of solutions which sutisfy the first two rules ie. *"no two queens share the same row, column"*. The remaining task is only to check whether our potential solutions satisfy *'no two queens share the same diagonal'* only. Checking of sharing diagonal is not so difficult. We must check the horizontal distance and vertical distance of every two queens. If the two distances are same, then the two queens share the same diagonal hence the permutation must be eliminated from theb set of solutions. SAS data set I created for this is shown below;
![SASpgm selection](/images/SASpgmSelection.jpg)
### With executing program above, 92 'solutions' will be got as follows.
![SASdataset1](/images/SASdatasetEightQueen.jpg)
## 1-5.Eliminating 'duplicated' solutions
### So far we have got the 'solutions' of Eight Queen puzzle which satisfy all three rules. Is that all? I don't think so. Because there would be duplicate solutions included in the current dataset if we rotate one solution 90 degrees right or left, there would be the same solutions contained. It is not good for us to leave here under this situation. I would like to have pure 'distinct' solutions only. In order to do this, I created a program shown below;
![SASpgm selection](/images/SASpgmSelection2.jpg)
### In this program, I checked 8 'identical' rotated patterns for every single 'solutions'. They are 1)Original sequence, 2-4)Sequences rotated 90,180,270 degrees, 5)Sequence flipped right side left 6-8) Flipped sequences rotated 90,180,270 degrees. And in order to eliminate 'identical' solutions, I used two sorting procedures built in SAS. First one is on the very last of the code shown above 'call sortc', which is used for sort character values in the array. With the result, we get data set like this and it is easy to find 'duplicated' solutions.
![SASdataset2](/images/SASdatasetEightQueen2.jpg)
### If you look at the image above carefully, you will notice that there are sevral lines which contain identical set of sequences. 
### Another thing we must use is proc sort in the following code;
![SASpgm sorting](/images/SASpgmProcSort.jpg)
### Proc sort can be used for sorting of dataset but it can be used for eliminationg duplicate observations(in the other language it is called 'record')from dataset. It is powerful and quite useful. In this case I used 'nodup' option in order to eliminate duplicated solutions. As the result of this elimination, we finally get 12 'distinct' solutions.
## 1-6.Print solutions
### The final task of this project is to print out the set of solutions. Agin, to do this thing, there are several options including use the external nice drawing programs. But in this case, I would like to use SAS program to print it. In SAS, in order to get nice looking output, there is a built in procedure called proc format. Using this, you can get much flexibility on expressing you have got from SAS. In this program I created a user defined format called "$Queen"('$' sign is required in order to show this format is applicable for character data only) to print the final solutions of eight queen. The coding of proc format is shown below;
![SASpgm foramt](/images/SASpgmProcFormat.jpg)
### And using this format, you can print the final solution with following code;
![SASpgm printing](/images/SASpgmProcPrint.jpg)
![Final result](/images/SASresultProcPrint.jpg)



