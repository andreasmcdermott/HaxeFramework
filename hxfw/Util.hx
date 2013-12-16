package hxfw;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;

/**
 * ...
 * @author Andreas McDermott
 */
class Util
{
	public static function createRenderTarget(w:Int, h:Int, scale:Int):Bitmap
	{
		var pixels = new BitmapData(w, h, false, Color.Black);
		var renderTarget = new Bitmap(pixels, PixelSnapping.NEVER);
		renderTarget.scaleX = renderTarget.scaleY = scale;
		return renderTarget;
	}
	
	public static function createBitmap(w:Int, h:Int, color:UInt = 0xffffffff):Bitmap
	{
		return new Bitmap(new BitmapData(w, h, false, color), PixelSnapping.NEVER);
	}
}