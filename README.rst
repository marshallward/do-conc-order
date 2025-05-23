========================
Do concurrent loop order
========================

What order does your compiler convert do-concurrent?

The Problem
-----------

``do concurrent`` is a nice construct for communicating to the compiler that an
operation should be independent of order.

But when there is no parallelization method (threads, GPUs, etc), then it still
has to pick some order to follow.

Even if the answer does not change, one choice will still be faster than
another.

So when you write ``do concurrent(i=1:m, j=1:n)``, which one is the innermost
loop?  Outermost?


The test
--------

Take arrays of size MxN (currently 1024 x 4096), indexed as ``a(i,j)``.

1. Run a bunch of dummy loops to push the CPU to its highest frequency

2. We run a vector triad loops with i-j order

.. code:: fortran

   do concurrent (i=1:m, j=1:n)
     d(i,j) = a(i,j) + b(i,j) * c(i,j)
   end do

3. Repeat with j-i order

.. code:: fortran

   do concurrent (j=1:n, i=1:m)
     d(i,j) = a(i,j) + b(i,j) * c(i,j)
   end do

then compare the time.


Results (so far)
----------------

Time in seconds to complete one loop (averaged over many repetitions).  (Lower
is faster)

Unoptimized (``-O0``)

===================  ==================   ==================
Compiler             do concurrent(i,j)   do concurrent(j,i)
===================  ==================   ==================
gfortran 14.0.1      **1.7e-2**           1.7e-1
ifort 2024.2         5.6e-2               **3.7e-2**
ifx 2025.1           1.6e-1               **2.1e-2**
nvfortran 25.1       1.7e-1               **1.8e-2**
===================  ==================   ==================

With optimization (``-O2``)

===================  ==================   ==================
Compiler             do concurrent(i,j)   do concurrent(j,i)
===================  ==================   ==================
gfortran 14.0.1      **3.3e-3**           **3.3e-3**
ifort 2024.2         4.7e-2               **2.6e-3**
ifx 2025.1           2.6e-1               **3.7e-3**
nvfortran 25.1       **3.2e-3**           **3.2e-3**
===================  ==================   ==================

The "winners" in each state are shown in bold.

There is a bit of uncertainty in the second digit, but AFAIK not more than one
or two digits.

Other observations based on ``do concurrent`` vs ``do ; do``.  (I will try to
add the numbers later.)

* ifort 2024.2 at ``-O2`` will reorder a ``do i ; do j`` loop in the "wrong"
  order, but not the (orderless) ``do concurrent`` loop.

* For GNU at ``-O0`` the ``do concurrent(i,j)`` is slightly faster than nested
  ``do j ; do i``.

* GNU ``-O2`` does not loop-reorder ``do i ; do j``.


Conclusion
----------

* GNU seems to prefer inner-to-outer.

* Nvidia and Intel seem to prefer outer-to-inner.

* After light optimization, GNU and Nvidia show now preference.  Intel still
  shows an outer-to-inner preference.

* ifx seems quite slow(?)

Our decision: **Write outer to inner loops**.

There is no answer here, and no reason why a vendor must choose one order or
another.  But there does seem to be a winner.


Platforms
---------

Absolute numbers are not the point, but here is the platform.

CPU: AMD EPYC 7742 64-core
RAM: TODO?
