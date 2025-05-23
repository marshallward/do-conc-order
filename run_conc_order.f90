use, intrinsic :: iso_fortran_env, only : int64

use do_conc_order

interface
  subroutine do_loop_test(a,b,c,d)
    real, intent(in) :: a(:,:), b(:,:), c(:,:)
    real, intent(out) :: d(:,:)
  end subroutine
end interface

! 1024 x 4096 arrays
integer, parameter :: m = 2**10, n = 2**12
real :: a(m,n), b(m,n), c(m,n), d(m,n)

integer(int64) :: c_start, c_end, c_rate, c_max
real, parameter :: t_max = 1.
real :: t

integer :: r
integer :: n_reps

procedure(do_loop_test), pointer :: test => null()
integer :: p

a(:,:) = 1.1
b(:,:) = 2.2
c(:,:) = 3.3

! Clock setup
call system_clock(count_rate=c_rate, count_max=c_max)

! Force the CPU into the highest frequency step

n_reps = 1
t = 0.

do while (t < t_max)
  call system_clock(c_start)
  do r = 1, n_reps
    call do_conc_ij(a,b,c,d)
  end do
  call system_clock(c_end)

  t = real(c_end - c_start) / real(c_rate)
  if (t < t_max) n_reps = n_reps * 2
end do

! Run tests
do p=1,4
  if (p == 1) test => do_conc_ij
  if (p == 2) test => do_ij
  if (p == 3) test => do_conc_ji
  if (p == 4) test => do_ji

  n_reps = 1
  t = 0.
  do while (t < t_max)
    call system_clock(c_start)
    do r = 1, n_reps
      call test(a,b,c,d)
    end do
    call system_clock(c_end)

    t = real(c_end - c_start) / real(c_rate)
    if (t < t_max) n_reps = n_reps * 2
  end do

  if (p == 1) print '("do concurrent(i=, j=) ", es24.16)', t / n_reps
  if (p == 2) print '("do i ; do j ", es24.16)', t / n_reps
  if (p == 3) print '("do concurrent (j=, i=) ", es24.16)', t / n_reps
  if (p == 4) print '("do j ; do i ", es24.16)', t / n_reps
end do

end
