package hxfw;

import flash.display.IBitmapDrawable;
import flash.geom.Matrix;
import flash.geom.Point;

/**
 * ...
 * @author Andreas McDermott
 */
class Entity
{
	private var drawable:IBitmapDrawable;
	private var cpos:Point;
	private var rpos:Point;
	private var pos:Point;
	private var size:Point;
	private var angle:Float;
	private var scale:Point;
	private var parent:Group;
	private var timer:Timer;
	
	public function new(x:Float, y:Float, w:Int, h:Int) 
	{
		cpos = new Point();
		rpos = new Point();
		pos = new Point();
		angle = 0.0;
		scale = new Point(1, 1);
		setPos(x, y);
		size = new Point(w, h);
		timer = new Timer();
	}
	
	public function assignDrawable(drawable:IBitmapDrawable):Entity
	{
		this.drawable = drawable;
		return this;
	}
	
	public function setScale(x:Float, y:Float)
	{
		scale.setTo(x, y);
	}
	
	public function setSize(w:Int, h:Int)
	{
		size.setTo(w, h);
	}
	
	public function setPos(x:Float, y:Float)
	{
		pos.setTo(x, y);
		cpos.setTo(Std.int(x / 16), Std.int(y / 16));
		rpos.setTo((x - cpos.x * 16) / 16, (y - cpos.y * 16) / 16);
	}
	
	private inline function getAngle():Float
	{
		var a = 0.0;
		if (parent != null)
			a = parent.getAngle();
		return a + angle;
	}
	
	private inline function getScale():Point
	{
		if (parent != null)
		{
			var s = parent.getScale();
			s.x *= scale.x;
			s.y *= scale.y;
			return s;
		}
		else return new Point(scale.x, scale.y);
	}
	
	private inline function getPos():Point
	{
		if (parent != null) 
		{
			var p = parent.getPos();
			p.offset(pos.x, pos.y);
			return p;
		}
		else return new Point(pos.x, pos.y);
	}
	
	private inline function getMatrix()
	{
		var matrix = new Matrix();
		matrix.identity();
		matrix.rotate(getAngle());
		var s = getScale();
		matrix.scale(s.x, s.y);
		var p = getPos();
		matrix.translate(p.x, p.y);
		return matrix;
	}
	
	private function update()
	{
		timer.update();
	}
	
	private function draw()
	{
		if (drawable == null) return;
		
		Camera.drawToActiveCamera(drawable, getMatrix());
	}
}