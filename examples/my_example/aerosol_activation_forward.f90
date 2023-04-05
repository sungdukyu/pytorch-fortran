! Author: Sungduk Yu
! Base code: https://github.com/alexeedm/pytorch-fortran/blob/v0.2/examples/resnet_forward/resnet_forward.f90
! Purpose: Test pytorch fortran binding with a custom pt model.

program resnet_forward
    use torch_ftn
    use iso_fortran_env

    implicit none

    integer :: n
    type(torch_module) :: torch_mod
    type(torch_tensor_wrap) :: input_tensors
    type(torch_tensor) :: out_tensor

    real(real32),allocatable :: input(:)
    real(real32), pointer :: output(:)

    character(:), allocatable :: filename
    integer :: arglen, stat

    if (command_argument_count() /= 1) then
        print *, "Need to pass a single argument: Pytorch model file name"
        stop
    end if

    call get_command_argument(number=1, length=arglen)
    allocate(character(arglen) :: filename)
    call get_command_argument(number=1, value=filename, status=stat)

    input = (/-1.29858573933202,       0.671420780063860,       -6.02146842871899,&
              2.41154098747602,      -0.633798985210547,      -0.425410224695577,&
              -0.588098957640829,      -0.140852225237818,        5.84399799133588,&
              -1.20698370555316,        1.89441168684480,      -0.946535841927729,&
              -0.364699905860845,        1.41391275784218,       0.847237534487054,&
              58.9113126937843&
            /)
    call input_tensors%create
    call input_tensors%add_array(input)
    call torch_mod%load(filename)
    call torch_mod%forward(input_tensors, out_tensor)
    call out_tensor%to_array(output)

    print *, output

end program
