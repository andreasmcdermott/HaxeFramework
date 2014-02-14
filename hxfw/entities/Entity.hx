package hxfw.entities;

import flash.display.IBitmapDrawable;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import hxfw.Collider;
import hxfw.Color;
import hxfw.Game;

/**
 * ...
 * @author Andreas McDermott
 */
class Entity extends Rectangle
{
	private var drawable:IBitmapDrawable;
	private var collider:Collider;
	private var angle:Float;
	private var originX:Float;
	private var originY:Float;
	private var scaleX:Float;
	private var scaleY:Float;
	private var a:Float;
	private var r:Float;
	private var g:Float;
	private var b:Float;
	private var inherit:Bool;
	private var parent:Group;
	private var timer:Timer;

	public function new(x:Float, y:Float, w:Float, h:Float) 
	{
		super(x, y, w, h);
		parent = null;
		angle = 0.0;
		scaleX = scaleY = 1.0;
		timer = new Timer();
		r = g = b = a = 1.0;
		originX = originY = 0.5;
		inherit = false;
		collider = Collider.createBoxCollider(0.0, 0.0, Collider.Solid, this);
	}
	
	public function inheritFromParent(inherit:Bool):Entity
	{
		this.inherit = inherit;
		return this;
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
	
	public function setScale(x:Float, y:Float):Entity
	{
		scaleX = x;
		scaleY = y;
		return this;
	}
	
	public function setSize(w:Float, h:Float):Entity
	{
		width = w;
		height = h;
		return this;
	}
	
	public function setPos(x:Float, y:Float):Entity
	{
		this.x = x;
		this.y = y;
		return this;
	}
	
	public function setAngle(angle:Float):Entity
	{
		this.angle = angle;
		return this;
	}
	
	public function rotate(angleDelta:Float):Entity
	{
		this.angle += angleDelta;
		return this;
	}
	
	public function setOrigin(x:Float, y:Float):Entity
	{
		originX = x;
		originY = y;
		return this;
	}
	
	public inline function getColor():UInt
	{
		return Color.toIntFromRGBA( { r: r, g: g, b:b, a:a } );
	}
	
	public inline function getAngle():Float
	{
		var a = 0.0;
		if (parent != null && inherit)
			a = parent.getAngle();
		return a + angle;
	}
	
	public inline function getScale():Point
	{
		if (parent != null && inherit)
		{
			var s = parent.getScale();
			s.x *= scaleX;
			s.y *= scaleY;
			return s;
		}
		else return new Point(scaleX, scaleY);
	}
	
	public inline function getPos():Point
	{
		if (parent != null && inherit) 
		{
			var p = parent.getPos();
			p.offset(x, y);
			return p;
		}
		else return new Point(x, y);
	}
	
	public inline function getSize():Point
	{
		var scale = getScale();
		return new Point(width * scale.x, height * scale.y);
	}
	
	public function getRect():Rectangle
	{		
		if (parent != null && parent.forceBounds)
			return parent.getRect();
		
		var pos = getPos();
		var scale = getScale();
		return new Rectangle(pos.x, pos.y, width * scale.x, height * scale.y);
	}
	
	private inline function getMatrix():Matrix
	{
		var matrix = new Matrix();
		matrix.identity();
		matrix.translate(-width * originX, -height * originY);
		matrix.rotate(getAngle());
		matrix.translate(width * originX, height * originY);
		var s = getScale();
		matrix.scale(s.x, s.y);
		var p = getPos();
		matrix.translate(p.x, p.y);
		return matrix;
	}
	
	public function resolveCollision(other:Entity):Bool
	{
		return Collider.resolveCollision(collider, other.collider);
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