Maros and Meszaros Convex QP Test Problems (MAT Format)
=========================================================

### Problem format:
```
  min   0.5 x'Qx + c'x 
  s.t.  rl <= Ax <= ru,
        lb <=  x <= ub.
```

### Notes
* If **rl = ru**, by setting b = rl, we can get
```
    min  0.5 x'Qx + c'x
    s.t. Ax = b 				
         lb <= x <= ub.
```
These problems are consistent with the discrption from Maros and Meszaros.

* In he discription about these test problems from Maros and Meszaros, they assume rl=ru. **BUT we do observe that for quite a few problems, rl ~= ru. For details of extracted problems, see log.txt**.


### Credits
Function coinRead from OPTI Toolbox serves as the core of this project. It makes use of the MPS input function in CoinUtils from COIN-OR project.

***Copyright declaration***:

* Maros and Meszaros Convex QP Test Problems: http://www.doc.ic.ac.uk/~im/
* OPTI Toolbox: http://www.i2c2.aut.ac.nz/Wiki/OPTI/
* CoinUtils   : https://projects.coin-or.org/CoinUtils




- - -
Yiming Yan @ The University of Edinburgh

March 12, 2014
