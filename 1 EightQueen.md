# 1.Solving Eight Queen 

## 1-1.What is 'Eight Queen'?
###   According to Wikipedia, 'Eight Queen' puzzle is defined as follows. *"The eight queens puzzle is the problem of placing eight chess queens on an 8×8 chessboard so that no two queens threaten each other. Thus, a solution requires that no two queens share the same row, column, or diagonal. The eight queens puzzle is an example of the more general n queens problem of placing n non-attacking queens on an n×n chessboard, for which solutions exist for all natural numbers n with the exception of n=2 and n=3."* One of the solution is shown on image below(image has taken from Wikipedia).
![Eight Queen](/images/EightQueenPuzzle.jpg)
## 1-2.How to solve?
### To determine how  to solve this puzzle by SAS programming, let's have a llok at the definition by Wiki again. It says, *"a solution requires that no two queens share the same row, column, or diagonal"*. In order to representthe a solution, I would like to use an array consists of eight elements. With this expression, the sample solution on above image can be converted into array of '{6,4,7,1,8,2,5,3}'. It means every element of this array represents the 'horizontal' position in a row of chess board. And to look at the array you will notice easily that there are no duplicate number in a solution array. With noticing this, it can be concluded that it is possible to devide the solving of 'Eight Queen' puzzle process into two stages. They are; stage1) generating the whole permutations with numbers from 1 to 8. stage2)select the permutations which satisfy all the rules. In other words, in stage1, we can list up the entire set of possible solutions hence in stage2, we can list up all the solutions out of the entire set. Let's see how to program these steps in SAS in following sections.    
## 1-3.Generating permutations
### To generate permutations, there would be several ways to do it. In this article, I would like to employ an algorithm called "The insert-into-all-positions solution" which I've found on the website called "Type Ocaml"(url:http://typeocaml.com/2015/05/05/permutation/). The idea of this algorithm is quite simple and easy to apply for SAS programming. The idea is that in this algorithm, we assume that we have already got the entire set of permutations with length of n-1. And when we would like to get the whole set of permutations with length of n, we can insert the number of 'n' into every possible position of existing set of permutations. Let's look at the following image;
![Permutation Algorithm](/images/permutation1.jpg)
### In the above image, we already have the set of permutations consist of three numbers and trying to have set with length of four. In this case, there are four positions we can insert number '4' into existing permutations.
![Permutation Algorithm2](/images/permutation2.jpg)
### To apply this manipulation on the entire set of existing permutations, we can get the right set of permutations with length of four. To convert this process into SAS program, it looks like as following.
![SASpgm Permutation](/images/SASpgmPermute.jpg)


## 1-4.Selecting solutions from whole permutations
## 1-5.Eliminating 'duplicate' solutions
## 1-6.Print solutions

