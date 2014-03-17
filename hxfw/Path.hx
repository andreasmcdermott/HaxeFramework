package hxfw;
import flash.display.Bitmap;
import flash.display.IBitmapDrawable;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.ds.IntMap.IntMap;
import hxfw.entities.Group;

/**
 * ...
 * @author Andreas McDermott
 */
class Path
{
	private static var grid:IntMap<Array<Array<Bool>>>;
	public static var debugBitmap:Bitmap;
	
	public static function setCurrentLevel(w:Int, h:Int, gridSizes:Array<Int>, obstacles:Group)
	{
		grid = new IntMap<Array<Array<Bool>>>();
		for (gridSize in gridSizes)
		{
			var map = new Array<Array<Bool>>();
		
			var cols:Int = Std.int(w / gridSize);
			var rows:Int = Std.int(h / gridSize);
				
			for (i in 0...rows)
			{
				var rowMap = new Array<Bool>();
				for (j in 0...cols)
				{
					var blocked:Bool = false;
					for (obstacle in obstacles)
					{
						var rect:Rectangle = obstacle.getRect();
						if (rect.contains(j * gridSize + gridSize * 0.5, i * gridSize + gridSize * 0.5))
						{
							blocked = true;
							break;
						}
					}
					
					rowMap.push(blocked);
				}
				map.push(rowMap);
			}
			
			grid.set(gridSize, map);
		}
	}
	
	public static function drawDebug(gridSize:Int = 16):Void
	{
		if (grid == null)
			return;
		if (!grid.exists(gridSize))
			gridSize = grid.keys().next();
		var map = grid.get(gridSize);
		
		for (r in 0...map.length)
		{
			for (c in 0...map[r].length)
			{
				if (map[r][c])
				{
					var mtx = new Matrix();
					mtx.scale(gridSize, gridSize);
					mtx.translate(c * gridSize, r * gridSize);
					Camera.drawToActiveCamera(debugBitmap, mtx, new ColorTransform(1, 0, 0, 0.5));
				}
			}
		}
	}
	
	public static function getPath(from:Point, to:Point):Path 
	{
		return new Path();
	}
	
	private function new()
	{
		
	}
}