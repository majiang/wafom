import std.stdio, std.conv, std.algorithm, std.array, std.string;

import wafom.precomputation;
import digitalnet.implementation;

void main(string[] args)
{
	real[] c;
	if (args.length == 1)
	{
		stderr.writeln("precomputation-wafom c...");
		return;
	}
	c = args[1..$].map!(to!real).array;
	foreach (line; stdin.byLine)
	{
		line.strip.split(",")[0].write;
		foreach (cvalue; c)
			",%.15f".writef(line.toDigitalNet.WAFOM(cvalue).lg);
		writeln;
	}
}
