module do_conc_order
contains

subroutine do_conc_ij(a, b, c, d)
  real, intent(in) :: a(:,:), b(:,:), c(:,:)
  real, intent(out) :: d(:,:)

  integer :: m, n

  m = size(a,1)
  n = size(a,2)

  do concurrent (i=1:m, j=1:n)
    d(i,j) = a(i,j) + b(i,j) * c(i,j)
  end do
end subroutine do_conc_ij


subroutine do_ij(a, b, c, d)
  real, intent(in) :: a(:,:), b(:,:), c(:,:)
  real, intent(out) :: d(:,:)

  integer :: m, n

  m = size(a,1)
  n = size(a,2)

  do i=1,m ; do j=1,n
    d(i,j) = a(i,j) + b(i,j) * c(i,j)
  end do ; end do
end subroutine do_ij


subroutine do_conc_ji(a, b, c, d)
  real, intent(in) :: a(:,:), b(:,:), c(:,:)
  real, intent(out) :: d(:,:)

  integer :: m, n

  m = size(a,1)
  n = size(a,2)

  do concurrent (j=1:n, i=1:m)
    d(i,j) = a(i,j) + b(i,j) * c(i,j)
  end do
end subroutine do_conc_ji


subroutine do_ji(a, b, c, d)
  real, intent(in) :: a(:,:), b(:,:), c(:,:)
  real, intent(out) :: d(:,:)

  integer :: m, n

  m = size(a,1)
  n = size(a,2)

  do j=1,n ; do i=1,m
    d(i,j) = a(i,j) + b(i,j) * c(i,j)
  end do ; end do
end subroutine do_ji

end module do_conc_order
