import std.stdio, std.conv, std.algorithm, std.array, std.string;

import wafom.original;
import digitalnet.implementation;

void main(string[] args)
{
	const c =
	(){
		if (1 < args.length)
			return args[1..$].map!(to!real).array;
		stderr.writeln("original-wafom c...");
		stderr.writeln("using default value c = [1]");
		return [real(1)];
	}();
	foreach (line; stdin.byLine)
	{
		line.strip.split(",")[0].write;
		foreach (cvalue; c)
			",%.15f".writef(line.toDigitalNet.WAFOM(cvalue).lg);
		writeln;
	}
}
