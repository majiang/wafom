module wafom.original;

import digitalnet.implementation;
import std.algorithm, std.math;
public import std.math : lg = log2;

real WAFOM(U, Size)(DigitalNet!(U, Size) P, real c = 1)
{
	return (P + new U[P.dimensionR]).WAFOMimpl(c);
}

private real WAFOMimpl(U, Size)(ShiftedDigitalNet!(U, Size) P, real c)
{
	immutable n = P.precision;
	if (P.bisectable)
	{
		auto Q = P.bisect;
		return (Q[0].WAFOMimpl(c) + Q[1].WAFOMimpl(c)) / 2;
	}
	real ret = 0;
	auto t = new real[2][n];
	foreach (j, ref u; t)
	{
		u[0] = 1 + exp2(c-1-(n - j));
		u[1] = 1 - exp2(c-1-(n - j));
	}
	foreach (X; P)
	{
		real current = 1;
		foreach (x; X)
			foreach (j; 0..n)
				current *= t[j][x >> j & 1];
		ret += current - 1;
	}
	return ret * exp2(-cast(ptrdiff_t)P.dimensionF2);
}
