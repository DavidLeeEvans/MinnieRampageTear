package dex.lib.astar;

@:enum
abstract Result(Int) {
	var Solved = 0;
	var NoSolution = 1;
	var StartEndSame = 2;
}
