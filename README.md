# msim

## Simulates the mafia party game supporting Multi-Threading(SBCL only)
To use this thing:
 - Install SBCL.
 - Run SBCL and load the program like this:

 `(load "msim-far.lisp")`
 - Now you can use `sim` or `sim-mt` functions to start the simulation:

 `sim rounds citizens`

 `sim-mt nthreads citizens nrounds`

 An example with `sim-mt` which supports multithreading:

 `sim-mt 2 '(m r r r) 10`

 Or to add fool:

 `sim-mt 2 '(m m f r r r r r) 10`

 - The result is a list containing number of wins for fool, mafia and townies.
 - Have fun and good luck :)
