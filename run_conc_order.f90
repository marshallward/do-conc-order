use, intrinsic :: iso_fortran_env, only : int64

use do_conc_order

integer, parameter :: m = 2**10, n = 2**12
real :: a(m,n), b(m,n), c(m,n), d(m,n)

integer(int64) :: c_start, c_end, c_rate, c_max
real :: t
real, parameter :: t_max = 1.

integer :: r
integer :: n_reps

! Clock setup
call system_clock(count_rate=c_rate, count_max=c_max)

a(:,:) = 1.1
b(:,:) = 2.2
c(:,:) = 3.3

! Force the CPU into the highest frequency step
! TODO: function pointers would help out here

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

! Generate do concurrent (i=, j=) timings

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
print '("do concurrent(i=, j=) ", es24.16)', &
    real(c_end - c_start) / real(c_rate) / n_reps

! Generate do (i=, j=) timings

n_reps = 1
t = 0.
do while (t < t_max)
  call system_clock(c_start)
  do r = 1, n_reps
    call do_ij(a,b,c,d)
  end do
  call system_clock(c_end)

  t = real(c_end - c_start) / real(c_rate)
  if (t < t_max) n_reps = n_reps * 2
end do
print '("do (i=, j=) ", es24.16)', &
    real(c_end - c_start) / real(c_rate) / n_reps

! Generate do concurrent (j=, i=) timings

n_reps = 1
t = 0.
do while (t < t_max)
  call system_clock(c_start)
  do r = 1, n_reps
    call do_conc_ji(a,b,c,d)
  end do
  call system_clock(c_end)

  t = real(c_end - c_start) / real(c_rate)
  if (t < t_max) n_reps = n_reps * 2
end do

print '("do concurrent(j=, i=) ", es24.16)', &
    real(c_end - c_start) / real(c_rate) / n_reps

! Generate do (j=, i=) timings

n_reps = 1
t = 0.
do while (t < t_max)
  call system_clock(c_start)
  do r = 1, n_reps
    call do_ji(a,b,c,d)
  end do
  call system_clock(c_end)

  t = real(c_end - c_start) / real(c_rate)
  if (t < t_max) n_reps = n_reps * 2
end do

print '("do (j=, i=) ", es24.16)', &
    real(c_end - c_start) / real(c_rate) / n_reps

end
