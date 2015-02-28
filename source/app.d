import std.stdio, std.conv;

import wafom.approximated;
import digitalnet.implementation;

void main(string[] args)
{
	real c = 1;
	if (args.length == 1)
		stderr.writeln("no parameter c specified: use default value 1.");
	else
		c = args[1].to!real;
	foreach (line; stdin.byLine)
		line.toDigitalNet.WAFOM(c).lg.writeln;
}
