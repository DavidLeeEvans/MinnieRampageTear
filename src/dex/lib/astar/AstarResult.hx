package dex.lib.astar;

@:multiReturn
extern class AstarResult {
	var result:Result;

	var size:Int;

	var totalCost:Float;

	var path:Array<PathPoint>;
}
