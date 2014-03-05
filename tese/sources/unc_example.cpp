#include "dci.h"

using namespace DCI;

void UFN (Int * n, Real * x, Real * f) {
  Real xi = 0, xi2 = 0;
  *f = 0;
  for (Int i = 0; i < *n; i++) {
    xi = x[i] - 1;
    xi2 = xi*xi;
    *f += xi2*xi2;
  }
}

void UOFG (Int * n, Real * x, Real * f, Real * g, Bool * grad) {
  Real xi = 0, xi2 = 0;
  *f = 0;
  for (Int i = 0; i < *n; i++) {
    xi = x[i] - 1;
    xi2 = xi*xi;
    *f += xi2*xi2;
    if (*grad == dciTrue)
      g[i] = 4*xi*xi2;
  }
}

void UPROD (Int * n, Bool *, Real * x, Real * p, Real * q) {
  Real xi = 0;
  for (Int i = 0; i < *n; i++) {
    xi = x[i] - 1;
    q[i] = 12*xi*xi*p[i];
  }
}

int main () {
  Int n = 5;
  DCI::Interface dci;
  Real x[n], bl[n], bu[n];

  dci.set_uofg (UOFG);
  dci.set_uprod (UPROD);
  dci.set_ufn (UFN);

  for (Int i = 0; i < n; i++) {
    x[i] = -1;
    bl[i] = -dciInf;
    bu[i] = dciInf;
  }
  
  dci.set_x (n, x);
  dci.set_bl (n, bl);
  dci.set_bu (n, bu);

  dci.start ();
  dci.solve ();
  dci.show();

}
