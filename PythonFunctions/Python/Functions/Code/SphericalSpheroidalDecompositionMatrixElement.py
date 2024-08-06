import qnm

def SphericalSpheroidalDecompositionMatrixElement(
    SpinWeight: int,
    Oblateness: complex,
    MagneticQuantumNumber: int,
    AngularQuantumNumber: int,
    PrimedQuantumNumber: int,
) -> complex:
    return qnm.angular.M_matrix_elem(SpinWeight, Oblateness, MagneticQuantumNumber, AngularQuantumNumber, PrimedQuantumNumber)