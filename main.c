#include <stdio.h>
#include <math.h>
#include "ODEsolver.h"

/* Stress test of EDO solver with stiff equation
A stiff equation is an equation that resemble to:

    y' = a*y, a |R < 0

For exemple we take a = -15:

    y' = -15*y, y(0) = 1

the exact solution is:

    y(t) = exp(-15*t)

*/

#define UNUSED(x) (void)x


double solution_stiff_equation(double t)
{
    return exp(-15.f*t);
}

double stiff_equation_o1(double t, double y)
{
    UNUSED(t);
    return -15.f*y;
}

double stiff_equation(double t, double y, double dy)
{
    UNUSED(t);
    UNUSED(y);
    return -15.f*dy;
}


int main()
{

    double t = 0;
    const double dt = 1.f/10.f;
    double t2 = 0;

    double y_EMe = 1;
    double y_EMs = 1;
    double y_RK4 = 1;
    double y_RK = 1;
    double y_VT = 1;
    double y_DOPRI45 = 1;

    double tmp;

    for (int step = 0; step < (int)1.f/dt; step++) {
	printf("%lf,%lf,%lf,%lf,%lf,%lf,%lf\n", t, solution_stiff_equation(t), y_EMe, y_EMs, y_RK4, y_RK, y_VT);

	if (methode_euler_explicite(dt, t, &tmp, &y_EMe, stiff_equation) < 0)
	     fprintf(stderr, "ERROR: Computes methode_euler_explicite\n");

     	if (methode_euler_simpletique(dt, t, &tmp, &y_EMs, stiff_equation) < 0)
	     fprintf(stderr, "ERROR: Computes methode_euler_simpletique\n");

	if (methode_RK4(dt, t, &tmp, &y_RK4, stiff_equation) < 0)
	     fprintf(stderr, "ERROR: Computes methode_RK4\n");

	if (methode_RK(dt, t, &tmp, &y_RK, stiff_equation) < 0)
	     fprintf(stderr, "ERROR: Computes methode_RK\n");

	if (methode_Verlet(dt, t, &tmp, &y_VT, stiff_equation) < 0)
	     fprintf(stderr, "ERROR: Computes methode_Verlet\n");

	t += dt;
    }

    printf("\nThe Last method is sepered because it change the time\n");

    for (int step = 0; step < (int)1.f/dt; step++) {
	printf("%lf,%lf\n", t2, y_DOPRI45);

	if (methode_DOPRI45(dt, &t2, 0.01, &tmp, &y_DOPRI45, stiff_equation) < 0)
	     fprintf(stderr, "ERROR: Computes methode_DOPRI45\n");

    }
    /*
    file = fopen(".csv", "w");
    fprintf(stderr, "ERROR: Failed to write file\n");

    fprintf(file, "%lf,%.3f,%.3f\n", t, E_TOT_1, E_TOT_2);

    fcolse(file)
    */
    return 0;
}
