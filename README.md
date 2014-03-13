Maros and Meszaros Convex QP Test Problems (MAT Format)
=========================================================









###Notes
***rl = ru*** for most problems. By setting b = rl, we can get
```
  min 0.5 x'Qx + c'x
  s.t. Ax = b 				
       lb <= x <= ub.
```
These problems are consistent with the discrption from I. Maros and Cs. Meszaros.

***BUT we do observe that for some problems, rl ~= ru.***
You will see some problems with rl = -inf and ru = +inf, which implies that 
Ax is free and there is no need to have A. So the problem has the follwoing format
```
  min 0.5 x'Qx + c'x
  s.t. lb <= x <= ub.
```

Curently I have no idea whether it is a bug in coinRead or these problems are
just like this.

 

- - -
Yiming Yan @ The University of Edinburgh

March 12, 2014
