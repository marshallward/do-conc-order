use, intrinsic :: iso_fortran_env, only : int64

use do_conc_order, only : do_conc_ij, do_conc_ji

integer, parameter :: m = 2**10, n = 2**12
real :: a(m,n), b(m,n), c(m,n), d(m,n)

integer(int64) :: c_start, c_end, c_rate, c_max
integer :: t

! Clock setup
call system_clock(count_rate=c_rate, count_max=c_max)

a(:,:) = 1.1
b(:,:) = 2.2
c(:,:) = 3.3

! TODO: Prime the CPU into turbo mode
do t = 1, 100
  call do_conc_ij(a,b,c,d)
end do

call system_clock(c_start)
do t = 1, 100
  call do_conc_ij(a,b,c,d)
end do
call system_clock(c_end)

print '("do concurrent(i=, j=) ", f24.16)', real(c_end - c_start) / real(c_rate)

call system_clock(c_start)
do t = 1, 100
call do_conc_ji(a,b,c,d)
end do
call system_clock(c_end)

print '("do concurrent(j=, i=) ", f24.16)', real(c_end - c_start) / real(c_rate)

end
