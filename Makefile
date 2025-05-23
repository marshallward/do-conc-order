MAKEFLAGS := -r

ifeq ($(origin FC), default)
  FC := gfortran
endif
ifeq ($(origin LD), default)
  LD = $(FC)
endif

FCFLAGS ?= -g -O2

all: run

run: run_conc_order.o do_conc_order.o
	$(LD) $(LDFLAGS) -o $@ $^

run_conc_order.o: run_conc_order.f90 do_conc_order.mod
	$(FC) $(FCFLAGS) -c $<

do_conc_order.mod: do_conc_order.o

do_conc_order.o: do_conc_order.f90
	$(FC) $(FCFLAGS) -c $<

clean:
	rm -f run *.o *.mod
