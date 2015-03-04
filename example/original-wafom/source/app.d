import std.stdio, std.conv, std.algorithm, std.array, std.string;

import wafom.original;
import digitalnet.implementation;

void main(string[] args)
{
	real[] c;
	if (args.length == 1)
	{
		stderr.writeln("approximated-wafom c...");
		stderr.writeln("using default value c = [1]");
		c = [1];
	}
	else
		c = args[1..$].map!(to!real).array;
	foreach (line; stdin.byLine)
	{
		line.strip.split(",")[0].write;
		foreach (cvalue; c)
			",%.15f".writef(line.toDigitalNet.WAFOM(cvalue).lg);
		writeln;
	}
}
