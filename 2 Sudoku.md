# 2.Solving Sudoku 

## 1-1.What is 'Sudoku'?
###   According to Wikipedia, 'Sudoku' puzzle is defined as follows. *"Sudoku (数独 sūdoku, digit-single), originally called Number Place is a logic-based, combinatorial number-placement puzzle. The objective is to fill a 9×9 grid with digits so that each column, each row, and each of the nine 3×3 subgrids that compose the grid (also called "boxes", "blocks", or "regions") contains all of the digits from 1 to 9. The puzzle setter provides a partially completed grid, which for a well-posed puzzle has a single solution."* One sample problem is shown on image below(image has taken from Wikipedia).
![Sudoku](/images/SudokuPuzzle.jpg)
## 1-2.How to solve?
### To determine how to solve this puzzle by SAS programming, let's have a look at the image above. By looking at the solution, you will notice it is about finding set of permutations which satisfy the initial setting of problem as well as three rules ie. each column, each row and each box must contain all 9 numbers. So just like the eight queen, I would like to use an array but this time consists of nine elements not eight. In the case of Eight Queen, the solution was only one array, but for Sudoku, solution(s) consist of nine arrays. In the case of sample, solution can be expressed as set arrays of '{5,3,4,6,7,8,9,1,2},{6,7,2,1,9,5,3,4,8},,,,{3,4,5,2,8,6,1,7,9}'. With these considerations, it can be concluded that it is possible to devide the solving of 'Sudoku' puzzle process into four stages. They are; stage1) reading a problem stage 2)generating the whole permutations with numbers from 1 to 8. stage3)select single permutation which satisfy the rules 4)combine nine permutations and find out final solution(s). 
## 1-3.Reading a problem
### Let's start solving Sudoku with step1. For statring this step, you must prepare a problem of Sudoku. Also you must convert the problem into data. Sudoku problem contains numbers and blanks. In SAS, blank is not appropriate, so I use '.'(period) in this article instead of blank. The code I created is shown below. You can replace the section below 'cards' statement with your own problem.
![SASpgm ProblemReading](/images/SASpgmProblem.jpg)
### With the code above, we can store problem into memory area called macro variables(with 'symput' statement) as well as SAS dataset.  
 
## 1-4.Generating permutations(this section is same as Eight Queen)
### To generate permutations, there would be several ways to do it. In this article, I would like to employ an algorithm called "The insert-into-all-positions solution" which I've found on the website called "Type Ocaml"(url:http://typeocaml.com/2015/05/05/permutation/). The idea of this algorithm is quite simple and easy to apply for SAS programming. In this algorithm, we assume that we have already got the entire set of permutations with length of 'n-1'. And when we would like to get the whole set of permutations with length of 'n', we can insert the number of 'n' into every possible position of existing set of permutations. Let's look at the following image to have clearer understanding;
![Permutation Algorithm](/images/permutation1.jpg)
### In the above image, we already have the set of permutations consist of three numbers and trying to have set with length of four. In this case, there are four positions we can insert number '4' into existing permutations.
![Permutation Algorithm2](/images/permutation2.jpg)
### To apply this manipulation on the entire set of existing permutations, we can get the right set of permutations with length of four. To convert this process into SAS program, it looks like as following.
![SASpgm Permutation](/images/SASpgmPermute.jpg)
### In the program above, we reead SAS dataset 'permute3' as input and output 'permute4'. In the input dataset, there is a variable(in the different language, it is called 'column' or 'item') named 'newSerie' which contains one permutation sequence with length of three. And in the 'Do loop' in the middle insert number '4' in the all possible positions of input permutation.
### But with the sample above, we must copy and paste the code above several times and modify them. It would not be a good programming practice. To avoid this, I introduced 'macro' feature of SAS program and created the code below.  
![SASpgm Permutation2](/images/SASpgmPermute3.jpg)
### All the basic ideas are the same as previous sample, but generalisation by 'macro variable' and 'macro programming' were used in the later one. The last command line "%permute(start=2, stop= 9);" invokes the macro program above and iterates the program eight times with varying macro variable '&num' from 2 to 9. Thus, we can get the entire set of permutations with length of nine. 

## 1-5.Selecting solutions from whole permutations
### After generating permutations, the next step for solving 'Sudoku' is the selection of permutations which comply to the initial setting of problem and stisfy all the rules. But in this stage we cannot get the final solution(s) because in this stage we only do the checking of single lines only. In order to get final solution(s), we must combine nine candidate solutions as a set and do the checking. But we must do it on the seperate step on the next section. SAS program I created for this section is shown below;
![SASpgm selection](/images/SASpgmSelection31.jpg)
![SASpgm selection](/images/SASpgmSelection32.jpg)
### Executing this program, you will get datasets named 'Select1' to 'Select9' which numbers indicate each row of the problem. The datasets contain 'candidate' permutations for each row. Several sample images of datasets are shown below; 
![SASdataset1](/images/SASdatasetSudoku1.jpg)
## 1-6.Combinating and checking all the rows
### So far we have got the 'candidates' of solutions for each row, the next step should be combine all these candidates and check the 'fitness' of combined lines. If the combination fail to satisfy the rule(s), it must be eliminated. In order to do this, I created a program shown below;
![SASpgm selection](/images/SASpgmSelection41.jpg)
![SASpgm selection](/images/SASpgmSelection42.jpg)
### In the program above, all the 'candidates' of solutions are checked one by one from row 1 through row 9. Below I showed the images of datasets created in the first to fourth iteration of this program. Seeing these images, you can easily find how this program works.
![SASdataset2](/images/SASdatasetSudoku2.jpg)
### When you finish this program, you will see the final answer of this 'Sudoku' problem.
![SASdataset2](/images/SASdatasetSudoku3.jpg)
### In this problem, there are two answers found as shown above.
## 1-7.Print solutions
### The final task of this project is to print out the set of solutions. To do this, we must transpose the 'Answer' dataset. As you can see from the above image, 'Answer' dataset contains the solutions in the form of concatenated multiple lines. So this is hard to read. To transform the concatenated one to 'single line' form, I created the data step below;
![SASpgm foramt](/images/SASpgmTransformData.jpg)
### And using this output dataset, you can print the final solution with following code;
![SASpgm printing](/images/SASpgmProcPrint2.jpg)
### in this code, I used 'noobs' option in order to get print result without observsation(=record) number.
![Final result](/images/SASresultProcPrint2.jpg)



