module wafom.precomputation;

import digitalnet.implementation;
import std.algorithm, std.math, std.functional;
public import std.math : lg = log2;

real WAFOM(U, Size)(DigitalNet!(U, Size) P, real c = 1, real exponent = 1)
{
	return (P + new U[P.dimensionR]).WAFOMimpl(getWAFOMCalculator!U(P.precision, c, exponent));
}

real RMSWAFOM(U, Size)(DigitalNet!(U, Size) P, real c = 1)
{
	return (P + new U[P.dimensionR]).WAFOMimpl(getWAFOMCalculator!U(P.precision, c, 2));
}

private real WAFOMimpl(U, Size, size_t chunkSize)(ShiftedDigitalNet!(U, Size) P, WAFOMCalculator!(U, chunkSize) wafomCalculator)
{
	if (P.bisectable)
	{
		auto Q = P.bisect;
		return (Q[0].WAFOMimpl(wafomCalculator) + Q[1].WAFOMimpl(wafomCalculator)) / 2;
	}
	real ret = 0;
	foreach (X; P)
		ret += wafomCalculator.WAFOMIntegrand(X);
	return ret * exp2(-cast(ptrdiff_t)P.dimensionF2);
}

alias getWAFOMCalculator(U, size_t chunkSize = 8) = memoize!(_getWAFOMCalculator!(U, chunkSize));

auto _getWAFOMCalculator(U, size_t chunkSize)(size_t n, real c, real exponent)
{
	return new WAFOMCalculator!(U, chunkSize)(n, c, exponent);
}

private class WAFOMCalculator(U, size_t chunkSize)
{
	this (in size_t n, real c, real exponent)
	{
		auto t = new real[2][n];
		foreach (j, ref u; t)
		{
			immutable eps = exp2(exponent * (c - 1 - (n - j)));
			u[0] = 1 + eps;
			u[1] = 1 - eps;
		}
		real[1 << chunkSize][] memo;
		while (t.length)
		{
			memo.length += 1;
			foreach (i, ref x; memo[$ - 1])
			{
				x = 1;
				foreach (j, u; t[0..min($, chunkSize)])
					x *= u[i >> j & 1];
			}
			t = t[min($, chunkSize)..$];
		}
		this.m = memo.idup;
	}
	real WAFOMIntegrand(U[] X)
	{
		real ret = 1;
		foreach (x; X)
			ret *= WAFOMIntegrand(x);
		return ret - 1;
	}
private:
	real WAFOMIntegrand(U x)
	{
		real ret = 1;
		foreach (row; m)
		{
			ret *= row[x & mask];
			x >>= chunkSize;
		}
		return ret;
	}
	enum mask = U.max >> ((U.sizeof << 3) - chunkSize);
	immutable real[1 << chunkSize][] m;
}
