Maros and Meszaros Convex QP Test Problems (MAT Format)
=========================================================

### Problem format:
```
  min   0.5 x'Qx + c'x 
  s.t.  rl <= Ax <= ru,
        lb <=  x <= ub.
```

### Notes
* If **rl = ru**, setting b = rl, we can get
```
    min  0.5 x'Qx + c'x
    s.t. Ax = b 				
         lb <= x <= ub.
```
These problems are consistent with the discrption from Maros and Meszaros.

* In the discription about these test problems from Maros and Meszaros, they assume rl=ru. **BUT we do observe that for quite a few problems, rl ~= ru. For details of extracted problems, see log.txt**.

* To regenerate the mat files, run *setup* first and then *qps2mat*. **The function coinRead only runs on Windows system!!**

### Credits
Function coinRead from OPTI Toolbox is the core of this project. It ultilizes the MPS input function in CoinUtils from COIN-OR project.

***Copyright declaration***:

* Maros and Meszaros Convex QP Test Problems: http://www.doc.ic.ac.uk/~im/
* OPTI Toolbox: http://www.i2c2.aut.ac.nz/Wiki/OPTI/
* CoinUtils   : https://projects.coin-or.org/CoinUtils




- - -
Yiming Yan @ The University of Edinburgh

March 12, 2014
