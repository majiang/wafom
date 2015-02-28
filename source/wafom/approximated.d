module wafom.approximated;

import digitalnet.implementation, digitalnet.integration;
public import std.math : lg = log2;
import std.algorithm;


real WAFOM(U, Size)(DigitalNet!(U, Size) P, real c)
{
	import std.math;
	immutable xcoeff = - (2 ^^ c);
	immutable I1dim = expm1(xcoeff) / xcoeff;
	immutable I = I1dim ^^ P.dimensionR;
	return P.integral!(Centering.no)((real[] x) =>
		(x.reduce!((a, b) => a + b) * xcoeff).exp - I
	) / I;
}
