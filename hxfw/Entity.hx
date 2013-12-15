package com.andreasmcdermott.hxfw;
import flash.display.IBitmapDrawable;
import flash.geom.Rectangle;

/**
 * ...
 * @author Andreas McDermott
 */
class Entity extends Rectangle
{
	private var drawable:IBitmapDrawable;
	
	public function new(x:Float, y:Float, w:Float, h:Float) 
	{
		super(x, y, w, h);
	}
	
	public function assignDrawable(drawable:IBitmapDrawable):Entity
	{
		this.drawable = drawable;
		return this;
	}
}