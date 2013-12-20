package hxfw;

import flash.display.IBitmapDrawable;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * ...
 * @author Andreas McDermott
 */
class Entity extends Rectangle
{
	private var drawable:IBitmapDrawable;
	private var angle:Float;
	private var scaleX:Float;
	private var scaleY:Float;
	private var a:Float;
	private var r:Float;
	private var g:Float;
	private var b:Float;
	private var parent:Group;
	private var timer:Timer;
	
	public function new(x:Float, y:Float, w:Float, h:Float) 
	{
		super(x, y, w, h);
		angle = 0.0;
		scaleX = scaleY = 1.0;
		timer = new Timer();
		r = g = b = a = 1.0;
	}
	
	public function assignDrawable(drawable:IBitmapDrawable):Entity
	{
		this.drawable = drawable;
		return this;
	}
	
	public function setColor(color:UInt):Entity
	{
		var rgba = Color.toRGBAFromHex(color);
		r = rgba.r;
		g = rgba.g;
		b = rgba.b;
		a = rgba.a;
		return this;
	}
	
	public function setScale(x:Float, y:Float)
	{
		scaleX = x;
		scaleY = y;
	}
	
	public function setSize(w:Float, h:Float)
	{
		width = w;
		height = h;
	}
	
	public function setPos(x:Float, y:Float)
	{
		this.x = x;
		this.y = y;
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
			s.x *= scaleX;
			s.y *= scaleY;
			return s;
		}
		else return new Point(scaleX, scaleY);
	}
	
	private inline function getPos():Point
	{
		if (parent != null) 
		{
			var p = parent.getPos();
			p.offset(x, y);
			return p;
		}
		else return new Point(x, y);
	}
	
	private inline function getRect():Rectangle
	{
		if (parent != null && parent.forceBounds)
			return parent;
		return this;
	}
	
	private inline function getMatrix():Matrix
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
		Camera.drawToActiveCamera(drawable, getMatrix(), new ColorTransform(r, g, b, a), getRect());
	}
}