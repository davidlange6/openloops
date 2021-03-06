
! Copyright 2014 Fabio Cascioli, Jonas Lindert, Philipp Maierhoefer, Stefano Pozzorini
!
! This file is part of OpenLoops.
!
! OpenLoops is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! OpenLoops is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with OpenLoops.  If not, see <http://www.gnu.org/licenses/>.


module ol_propagators_qp
  implicit none
  contains

! **********************************************************************
subroutine prop_Q_A(J_Q, K, M, mQ, Jout_Q)
! dressing quark current with propagator
! ----------------------------------------------------------------------
! J_Q(4)    = incoming quark current
! K(4)      = incoming momentum (light-cone rep)
! M         = complex mass
! mQ        = 0/1 for massless/massive propagator
! Jout_Q(4) = outgoing dressed quark current without I/(K^2-M^2)
! Jout_Q(i) = [slash(K)+M](i,j) * J_Q(j)
! **********************************************************************
  use kind_types, only: qp, intkind1
  implicit none
  complex(qp), intent(in)  :: J_Q(4), K(4), M
  integer(intkind1), intent(in)  :: mQ
  complex(qp), intent(out) :: Jout_Q(4)
  Jout_Q(1) = - K(2)*J_Q(3) + K(4)*J_Q(4)
  Jout_Q(2) = - K(1)*J_Q(4) + K(3)*J_Q(3)
  Jout_Q(3) = - K(1)*J_Q(1) - K(4)*J_Q(2)
  Jout_Q(4) = - K(2)*J_Q(2) - K(3)*J_Q(1)
  if (mQ /= 0) then
    Jout_Q = Jout_Q + M*J_Q
  end if
end subroutine prop_Q_A


! **********************************************************************
subroutine prop_A_Q(J_A, K, M, mA, Jout_A)
! dressing anti-quark current with propagator
! ----------------------------------------------------------------------
! J_A(4)    = incoming anti-quark current
! K(4)      = incoming momentum (light-cone rep)
! M         = complex mass
! mA        = 0/1 for massless/massive propagator
! Jout_A(4) = outgoing dressed anti-quark current without I/(K^2-M^2)
! Jout_A(i) = J_A(j) * [-slash(K)+M](j,i)
! **********************************************************************
  use kind_types, only: qp, intkind1
  implicit none
  complex(qp), intent(in)  :: J_A(4), K(4), M
  integer(intkind1), intent(in)  :: mA
  complex(qp), intent(out) :: Jout_A(4)
  Jout_A(1) = + K(1)*J_A(3) + K(3)*J_A(4)
  Jout_A(2) = + K(2)*J_A(4) + K(4)*J_A(3)
  Jout_A(3) = + K(2)*J_A(1) - K(3)*J_A(2)
  Jout_A(4) = + K(1)*J_A(2) - K(4)*J_A(1)
  if (mA /= 0) then
    Jout_A = Jout_A + M*J_A
  end if
end subroutine prop_A_Q


! **********************************************************************
subroutine prop_W_W(J_V, K, M, mW, Jout_V)
! Unitary gauge for massive vector bosons
! ----------------------------------------------------------------------
! J_V(4)    = incoming vector boson current (light-cone rep.)
! K(4)      = incoming vector boson momentum (light-cone rep)
! M         = complex mass
! mW        = 0/1 for massless/massive propagator; not used because
!             this subroutine is only defined for massive vector bosons.
! Jout_V(4) = outgoing dressed vector boson current (light-cone rep.)
! Jout_V(i) = J_V(i) - (J_V.K) * K(i)
! **********************************************************************
  use kind_types, only: qp, intkind1
  use ol_contractions_qp, only: cont_VV
  implicit none
  complex(qp), intent(in)  :: J_V(4), K(4), M
  integer(intkind1), intent(in)  :: mW
  complex(qp), intent(out) :: Jout_V(4)
  Jout_V = J_V - (cont_VV(J_V, K) / (M*M)) * K
end subroutine prop_W_W

end module ol_propagators_qp



! **********************************************************************
module ol_s_propagators_qp
! Routines to dressing a wave function with a propagator
! - prop_Q_A: fermion
! - prop_A_Q: anti-fermion
! - prop_W_W: massive vector boson in unitary gauge
! **********************************************************************
  implicit none
  contains

! **********************************************************************
subroutine prop_Q_A(Q, K, M, mQ, Q_out)
! dressing quark current with propagator
! ----------------------------------------------------------------------
! Q         = quark wfun
! ----------------------------------------------------------------------
! Q%j(4)    = (0, 0, 0, 0)  (0, 0, J3,J4)  (J1,J2, 0, 0)  (J1,J2,J3,J4)
! Q%h       =     B"00"         B"01"          B"10"          B"11"
! ----------------------------------------------------------------------
! K(4)      = incoming momentum (light-cone rep)
! M         = complex mass
! mQ        = 0/1 for massless/massive propagator
! Q_out     = outgoing dressed quark current without I/(K^2-M^2)
! Q_out%j(i)= [slash(K)+M](i,j) * Q%j(j)
! **********************************************************************
  use kind_types, only: qp, intkind1
  use ol_data_types_qp, only: wfun
  implicit none
  type(wfun),        intent(in)  :: Q
  complex(qp), intent(in)  :: K(4), M
  integer(intkind1), intent(in)  :: mQ
  type(wfun),        intent(out) :: Q_out

  select case (Q%h)

  case (B"01")
    Q_out%j(1) = - K(2)*Q%j(3) + K(4)*Q%j(4)
    Q_out%j(2) = - K(1)*Q%j(4) + K(3)*Q%j(3)
    if (mQ == 0) then
      Q_out%j(3:4) = 0
      Q_out%h      = B"10"
    else
      Q_out%j(3:4) = M*Q%j(3:4)
      Q_out%h      = B"11"
    end if

  case (B"10")
    Q_out%j(3) = - K(1)*Q%j(1) - K(4)*Q%j(2)
    Q_out%j(4) = - K(2)*Q%j(2) - K(3)*Q%j(1)
    if (mQ == 0) then
      Q_out%j(1:2) = 0
      Q_out%h      = B"01"
    else
      Q_out%j(1:2) = M*Q%j(1:2)
      Q_out%h      = B"11"
    end if

  case (B"00")
    Q_out%j = 0
    Q_out%h = B"00"

  case default
    if (mQ == 0) then
      Q_out%j(1) = - K(2)*Q%j(3) + K(4)*Q%j(4)
      Q_out%j(2) = - K(1)*Q%j(4) + K(3)*Q%j(3)
      Q_out%j(3) = - K(1)*Q%j(1) - K(4)*Q%j(2)
      Q_out%j(4) = - K(2)*Q%j(2) - K(3)*Q%j(1)
    else
      Q_out%j(1) = - K(2)*Q%j(3) + K(4)*Q%j(4) + M*Q%j(1)
      Q_out%j(2) = - K(1)*Q%j(4) + K(3)*Q%j(3) + M*Q%j(2)
      Q_out%j(3) = - K(1)*Q%j(1) - K(4)*Q%j(2) + M*Q%j(3)
      Q_out%j(4) = - K(2)*Q%j(2) - K(3)*Q%j(1) + M*Q%j(4)
    end if
    Q_out%h    =   B"11"

  end select

end subroutine prop_Q_A


! **********************************************************************
subroutine prop_A_Q(A, K, M, mA, A_out)
! dressing anti-quark current with propagator
! ----------------------------------------------------------------------
! A         = anti-quark wfun
! ----------------------------------------------------------------------
! A%j(4)    = (0, 0, 0, 0)  (0, 0, J3,J4)  (J1,J2, 0, 0)  (J1,J2,J3,J4)
! A%h       =    B"00"          B"01"         B"10"          B"11"
! ----------------------------------------------------------------------
! K(4)      = incoming momentum (light-cone rep)
! M         = complex mass
! mA        = 0/1 for massless/massive propagator
! A_out     = outgoing dressed anti-quark current without I/(K^2-M^2)
! A_out%j(i)= A%j(j) * [-slash(K)+M](j,i)
! **********************************************************************

  use kind_types, only: qp, intkind1
  use ol_data_types_qp, only: wfun
  implicit none
  type(wfun),        intent(in)  :: A
  complex(qp), intent(in)  :: K(4), M
  integer(intkind1), intent(in)  :: mA
  type(wfun),        intent(out) :: A_out

  select case (A%h)

  case (B"01")
    A_out%j(1) = + K(1)*A%j(3) + K(3)*A%j(4)
    A_out%j(2) = + K(2)*A%j(4) + K(4)*A%j(3)
    if (mA == 0) then
      A_out%j(3:4) = 0
      A_out%h      = B"10"
    else
      A_out%j(3:4) = M*A%j(3:4)
      A_out%h      = B"11"
    end if

  case (B"10")
    A_out%j(3) = + K(2)*A%j(1) - K(3)*A%j(2)
    A_out%j(4) = + K(1)*A%j(2) - K(4)*A%j(1)
    if (mA == 0) then
      A_out%j(1:2) = 0
      A_out%h      = B"01"
    else
      A_out%j(1:2) = M*A%j(1:2)
      A_out%h      = B"11"
    end if

  case (B"00")
    A_out%j = 0
    A_out%h = B"00"

  case default
    if (mA == 0) then
      A_out%j(1) = + K(1)*A%j(3) + K(3)*A%j(4)
      A_out%j(2) = + K(2)*A%j(4) + K(4)*A%j(3)
      A_out%j(3) = + K(2)*A%j(1) - K(3)*A%j(2)
      A_out%j(4) = + K(1)*A%j(2) - K(4)*A%j(1)
    else
      A_out%j(1) = + K(1)*A%j(3) + K(3)*A%j(4) + M*A%j(1)
      A_out%j(2) = + K(2)*A%j(4) + K(4)*A%j(3) + M*A%j(2)
      A_out%j(3) = + K(2)*A%j(1) - K(3)*A%j(2) + M*A%j(3)
      A_out%j(4) = + K(1)*A%j(2) - K(4)*A%j(1) + M*A%j(4)
    end if
    A_out%h    =   B"11"

  end select

end subroutine prop_A_Q


! **********************************************************************
subroutine prop_W_W(V, K, M, mW, V_out)
! Unitary gauge for massive vector bosons
! ----------------------------------------------------------------------
! V         = incoming vector boson wfun (light-cone rep.)
! K(4)      = incoming vector boson momentum (light-cone rep)
! M         = complex mass
! mW        = 0/1 for massless/massive propagator; not used because
!             this subroutine is only defined for massive vector bosons.
! V_out     = outgoing dressed vector boson wfun (light-cone rep.)
! V_out%j(i)= V%j(i) - (V%j.K) * K(i)
! **********************************************************************
  use kind_types, only: qp, intkind1
  use ol_s_contractions_qp, only: cont_PP
  use ol_data_types_qp, only: wfun
  implicit none
  type(wfun),        intent(in)  :: V
  complex(qp), intent(in)  :: K(4), M
  integer(intkind1), intent(in)  :: mW
  type(wfun),        intent(out) :: V_out
  V_out%j = V%j - (cont_PP(V%j, K) / (M*M)) * K
end subroutine prop_W_W

end module ol_s_propagators_qp



! **********************************************************************
module ol_h_propagators_qp
! Routines to dressing a wave function with a propagator
! - prop_Q_A: fermion
! - prop_A_Q: anti-fermion
! - prop_W_W: massive vector boson in unitary gauge
! **********************************************************************
  implicit none
  contains

! **********************************************************************
subroutine prop_Q_A(ntry, Q, K, M, mQ, Q_out, n)
! dressing quark current with propagator
! ----------------------------------------------------------------------
! Q(1:n)       = quark wfun
! K(4)         = incoming momentum (light-cone rep)
! M            = complex mass
! mQ           = 0/1 for massless/massive propagator
! Q_out(1:n)   = outgoing dressed quark current without I/(K^2-M^2)
! Q_out(h)%j(i)= [slash(K)+M](i,j) * Q%j(j)
! **********************************************************************
  use kind_types, only: qp, intkind1, intkind2
  use ol_data_types_qp, only: wfun
  use ol_helicity_bookkeeping_qp, only: helbookkeeping_prop
  implicit none
  integer(intkind1), intent(in)    :: ntry
  integer(intkind2), intent(inout) :: n
  type(wfun),        intent(in)    :: Q(n)
  complex(qp), intent(in)    :: K(4), M
  integer(intkind1), intent(in)    :: mQ
  type(wfun),        intent(out)   :: Q_out(n)
  integer :: h

  do h = 1, n

    select case (Q(h)%h)

    case (B"01")
      Q_out(h)%j(1) = - K(2)*Q(h)%j(3) + K(4)*Q(h)%j(4)
      Q_out(h)%j(2) = - K(1)*Q(h)%j(4) + K(3)*Q(h)%j(3)
      if (mQ == 0) then
        Q_out(h)%j(3:4) = 0
        Q_out(h)%h      = B"10"
      else
        Q_out(h)%j(3:4) = M*Q(h)%j(3:4)
        Q_out(h)%h      = B"11"
      end if

    case (B"10")
      Q_out(h)%j(3) = - K(1)*Q(h)%j(1) - K(4)*Q(h)%j(2)
      Q_out(h)%j(4) = - K(2)*Q(h)%j(2) - K(3)*Q(h)%j(1)
      if (mQ == 0) then
        Q_out(h)%j(1:2) = 0
        Q_out(h)%h      = B"01"
      else
        Q_out(h)%j(1:2) = M*Q(h)%j(1:2)
        Q_out(h)%h      = B"11"
      end if

    case (B"00")
      Q_out(h)%j = 0 ! needed to detect vanishing helicity configurations
      Q_out(h)%h = B"00"

    case default
      if (mQ == 0) then
        Q_out(h)%j(1) = - K(2)*Q(h)%j(3) + K(4)*Q(h)%j(4)
        Q_out(h)%j(2) = - K(1)*Q(h)%j(4) + K(3)*Q(h)%j(3)
        Q_out(h)%j(3) = - K(1)*Q(h)%j(1) - K(4)*Q(h)%j(2)
        Q_out(h)%j(4) = - K(2)*Q(h)%j(2) - K(3)*Q(h)%j(1)
      else
        Q_out(h)%j(1) = - K(2)*Q(h)%j(3) + K(4)*Q(h)%j(4) + M*Q(h)%j(1)
        Q_out(h)%j(2) = - K(1)*Q(h)%j(4) + K(3)*Q(h)%j(3) + M*Q(h)%j(2)
        Q_out(h)%j(3) = - K(1)*Q(h)%j(1) - K(4)*Q(h)%j(2) + M*Q(h)%j(3)
        Q_out(h)%j(4) = - K(2)*Q(h)%j(2) - K(3)*Q(h)%j(1) + M*Q(h)%j(4)
      end if
      Q_out(h)%h      = B"11"

    end select

  end do

  if (ntry == 1) call helbookkeeping_prop(ntry, Q, Q_out, n)

end subroutine prop_Q_A


! **********************************************************************
subroutine prop_A_Q(ntry, A, K, M, mA, A_out, n)
! dressing anti-quark current with propagator
! ----------------------------------------------------------------------
! A(1:n)    = anti-quark wfun
! K(4)      = incoming momentum (light-cone rep)
! M         = complex mass
! mA        = 0/1 for massless/massive propagator
! A_out(1:n = outgoing dressed anti-quark current without I/(K^2-M^2)
! A_out(h)%j(i)= A(h)%j(j) * [-slash(K)+M](j,i)
! **********************************************************************
  use kind_types, only: qp, intkind1, intkind2
  use ol_data_types_qp, only: wfun
  use ol_helicity_bookkeeping_qp, only: helbookkeeping_prop
  implicit none
  integer(intkind1), intent(in)    :: ntry
  integer(intkind2), intent(inout) :: n
  type(wfun),        intent(in)    :: A(n)
  complex(qp), intent(in)    :: K(4), M
  integer(intkind1), intent(in)    :: mA
  type(wfun),        intent(out)   :: A_out(n)
  integer :: h

  do h = 1, n

    select case (A(h)%h)

    case (B"01")
      A_out(h)%j(1) = + K(1)*A(h)%j(3) + K(3)*A(h)%j(4)
      A_out(h)%j(2) = + K(2)*A(h)%j(4) + K(4)*A(h)%j(3)
      if (mA == 0) then
        A_out(h)%j(3:4) = 0
        A_out(h)%h      = B"10"
      else
        A_out(h)%j(3:4) = M*A(h)%j(3:4)
        A_out(h)%h      = B"11"
      end if

    case (B"10")
      A_out(h)%j(3) = + K(2)*A(h)%j(1) - K(3)*A(h)%j(2)
      A_out(h)%j(4) = + K(1)*A(h)%j(2) - K(4)*A(h)%j(1)
      if (mA == 0) then
        A_out(h)%j(1:2) = 0
        A_out(h)%h      = B"01"
      else
        A_out(h)%j(1:2) = M*A(h)%j(1:2)
        A_out(h)%h      = B"11"
      end if

    case (B"00")
      A_out(h)%j = 0  ! needed to detect vanishing helicity configurations
      A_out(h)%h = B"00"

    case default
      if (mA == 0) then
        A_out(h)%j(1) = + K(1)*A(h)%j(3) + K(3)*A(h)%j(4)
        A_out(h)%j(2) = + K(2)*A(h)%j(4) + K(4)*A(h)%j(3)
        A_out(h)%j(3) = + K(2)*A(h)%j(1) - K(3)*A(h)%j(2)
        A_out(h)%j(4) = + K(1)*A(h)%j(2) - K(4)*A(h)%j(1)
      else
        A_out(h)%j(1) = + K(1)*A(h)%j(3) + K(3)*A(h)%j(4) + M*A(h)%j(1)
        A_out(h)%j(2) = + K(2)*A(h)%j(4) + K(4)*A(h)%j(3) + M*A(h)%j(2)
        A_out(h)%j(3) = + K(2)*A(h)%j(1) - K(3)*A(h)%j(2) + M*A(h)%j(3)
        A_out(h)%j(4) = + K(1)*A(h)%j(2) - K(4)*A(h)%j(1) + M*A(h)%j(4)
      end if
      A_out(h)%h = B"11"

    end select

  end do

  if (ntry == 1) call helbookkeeping_prop(ntry, A, A_out, n)

end subroutine prop_A_Q


! **********************************************************************
subroutine prop_W_W(ntry, V, K, M, mW, V_out, n)
! Unitary-gauge propagator for massive vector bosons
! ----------------------------------------------------------------------
! ntry          = 1 (2) for 1st (subsequent) PS points
! V(:)          = incoming vector boson wavefunctions (light-cone representation),
!                 one for each helicity configuration
! K(4)          = incoming vector boson momentum (light-cone rep)
! M             = complex mass
! mW            = 0/1 for massless/massive propagator; not used because
!                 this subroutine is only defined for massive vector bosons.
! V_out(:)      = outgoing dressed vector boson wavefunctions (light-cone representation)
! V_out(h)%j(i) = V(h)%j(i) - (V(h)%j.K) * K(i)
! **********************************************************************
  use kind_types, only: qp, intkind1, intkind2
  use ol_s_contractions_qp, only: cont_PP
  use ol_data_types_qp, only: wfun
  use ol_helicity_bookkeeping_qp, only: helbookkeeping_prop
  implicit none
  integer(intkind1), intent(in)    :: ntry
  integer(intkind2), intent(inout) :: n
  type(wfun),        intent(in)    :: V(1:n)
  complex(qp), intent(in)    :: K(4), M
  integer(intkind1), intent(in)    :: mW
  type(wfun),        intent(out)   :: V_out(1:n)
  complex(qp)                :: M2
  integer                          :: h

  M2 = M * M
  do h = 1, n
    V_out(h)%j = V(h)%j - (cont_PP(V(h)%j, K) / M2) * K
  end do

  if(ntry ==1 ) call helbookkeeping_prop(ntry, V, V_out, n)

end subroutine prop_W_W

end module ol_h_propagators_qp

