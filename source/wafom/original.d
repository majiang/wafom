module wafom.original;

import digitalnet.implementation;
import std.algorithm, std.math, std.functional;
public import std.math : lg = log2;

real WAFOM(U, Size)(DigitalNet!(U, Size) P, real c = 1, real exponent = 1)
{
	return (P + new U[P.dimensionR]).WAFOMimpl(getWAFOMMultiplicand(P.precision, c, exponent));
}

real RMSWAFOM(U, Size)(DigitalNet!(U, Size) P, real c = 1)
{
	return (P + new U[P.dimensionR]).WAFOMimpl(getWAFOMMultiplicand(P.precision, c, 2));
}

private class WAFOMMultiplicand
{
	real[2][] t;
	this (size_t n, real c, real exponent)
	{
		t = new real[2][n];
		foreach (j, ref u; t)
		{
			immutable eps = exp2(exponent * (c - 1 - (n - j)));
			u[0] = 1 + eps;
			u[1] = 1 - eps;
		}
	}
}

auto _getWAFOMMultiplicand(size_t n, real c, real exponent)
{
	return new WAFOMMultiplicand(n, c, exponent);
}

alias getWAFOMMultiplicand = memoize!_getWAFOMMultiplicand;

private real WAFOMimpl(U, Size)(ShiftedDigitalNet!(U, Size) P, WAFOMMultiplicand wafomMultiplicand)
{
	if (P.bisectable)
	{
		auto Q = P.bisect;
		return (Q[0].WAFOMimpl(wafomMultiplicand) + Q[1].WAFOMimpl(wafomMultiplicand)) / 2;
	}
	real ret = 0;
	foreach (X; P)
	{
		real current = 1;
		foreach (x; X)
			foreach (j, u; wafomMultiplicand.t)
				current *= u[x >> j & 1];
		ret += current - 1;
	}
	return ret * exp2(-cast(ptrdiff_t)P.dimensionF2);
}
