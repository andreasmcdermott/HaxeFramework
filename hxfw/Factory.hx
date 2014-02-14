package hxfw;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.PixelSnapping;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * ...
 * @author Andreas McDermott
 */
class Factory
{
	public static function createRenderTarget(w:Int, h:Int, scale:Int):Bitmap
	{
		var pixels = new BitmapData(w, h, false, Color.Black);
		var renderTarget = new Bitmap(pixels, PixelSnapping.NEVER);
		renderTarget.scaleX = renderTarget.scaleY = scale;
		return renderTarget;
	}
	
	public static function createSquare(w:Int, h:Int, color:UInt = 0xffffffff):Bitmap
	{
		return new Bitmap(new BitmapData(w, h, true, color), PixelSnapping.NEVER);
	}
	
	public static function createCircle(r:Int, lineWidth:Float = 1, color:UInt = 0xffffffff):Bitmap
	{
		var data = new BitmapData(r * 2, r * 2, true, 0x00000000);
		var shape = new Shape();
		var rgba = Color.toRGBAFromHex(color);
		shape.graphics.beginFill(Color.toIntFromRGB( { r: rgba.r, g: rgba.g, b: rgba.b } ), rgba.a);
		shape.graphics.drawCircle(r, r, r);
		shape.graphics.endFill();
		data.draw(shape);
		return new Bitmap(data, PixelSnapping.NEVER);
	}
	
	public static function getTile(tileset:BitmapData, tx:Int, ty:Int, w:Int, h:Int):Bitmap
	{
		var tileData = new BitmapData(w, h, false, Color.Black);
		tileData.copyPixels(tileset, new Rectangle(tx * w, ty * w, w, h), new Point(0, 0));
		return new Bitmap(tileData, PixelSnapping.NEVER);
	}
}