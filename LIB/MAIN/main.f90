! ********************************
! WABBIT
! --------------------------------
!
! main program, time loop
!
! name: main.f90
! date: 29.09.2016
! author: msr
! version: 0.2
!
! ********************************

program main

    use module_params
    use module_blocks

    implicit none

    ! time loop variables
    real(kind=rk) 	    :: time
    integer(kind=ik)	:: iteration
    ! cpu time variables
    real(kind=rk)       :: t0, t1
    ! run time error calculation
    real(kind=rk)       :: s0, s1

    ! initialize local variables
    time        = 0.0_rk
    iteration   = 0
    s0          = 0.0_rk
    s1          = 0.0_rk

    ! initializing data
    call init_data()

    ! calculate sum over start field for error calculation
    call matrix_sum(s0, blocks_params%phi, blocks_params%size_domain)
    s0 = s0 * ( params%Lx / ( blocks_params%size_domain - 1 ) )  * ( params%Ly / ( blocks_params%size_domain - 1 ) )

    ! cpu time start
    call cpu_time(t0)

    ! create block tree
    call matrix_to_block_tree()

    ! update neighbor relations
    call update_neighbors()

    ! save start field to disk
    call save_data(iteration, time, 0.0_rk)
!
!    ! main time loop
!    do while ( time < params%time_max )
!
!        iteration = iteration + 1
!
!        ! adapt the mesh
!        if (blocks_params%adapt_mesh) call adapt_mesh()
!
!        ! update the neighbor relations
!        call update_neighbors()
!        call set_boundary_status()
!
!        ! advance in time
!        call time_step_RK4(time)
!        !call time_step_RK2(time)
!        !call time_step_RK1(time)
!
!        ! error calculation
!        call blocks_sum(s1, 1)
!
!        ! write data to disk
!        if (modulo(iteration, params%write_freq) == 0) then
!          call save_data(iteration, time, abs(s0-s1))
!        endif
!
!        ! output on screen
!        write(*, '("iteration=",i5,3x," time=",f10.6,3x," N_active=",i7)') iteration, time, size(blocks_params%active_list, dim=1)
!        write(*, '("error=", es16.8)') abs(s0-s1)
!        write(*,'(80("-"))')
!
!    end do
!
!    ! save end field to disk
!    call save_data(iteration, time, abs(s0-s1))
!
    ! cpu time calculation and writing
    call cpu_time(t1)
    write(*,'(a,f10.6)') "cpu-time = ", t1-t0

end program main
