Maros and Meszaros Convex QP Test Problems (MAT Format)
=========================================================

### Problem format:
```
  min   0.5 x'Qx + c'x 
  s.t.  rl <= Ax <= ru,
        lb <=  x <= ub.
```

### Notes
* ***rl = ru for most problems***. By setting b = rl, we can get
```
    min  0.5 x'Qx + c'x
    s.t. Ax = b 				
         lb <= x <= ub.
```
These problems are consistent with the discrption from Maros and Meszaros.

* ***BUT we do observe that for some problems, rl ~= ru.***
  * If some elements of rl are not -inf or some elements of ru are not +inf, we may remove some rows in A where -inf <= A(i,:)x <= +inf. According to the discription of Maros and Meszaros, this is not supposed to happen. Curently I have no idea whether it is a bug in coinRead or these problems are just like this.
  * If all elements of rl is -inf and all elements of ru is +inf, there is no need to have A. So the problem has the follwoing format
```
      min  0.5 x'Qx + c'x
      s.t. lb <= x <= ub.
```


### Credits





- - -
Yiming Yan @ The University of Edinburgh

March 12, 2014
