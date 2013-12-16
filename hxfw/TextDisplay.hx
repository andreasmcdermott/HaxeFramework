package hxfw;

import flash.text.TextField;

/**
 * ...
 * @author Andreas McDermott
 */
class TextDisplay extends Entity
{
	private var textField:TextField;
	
	public function new(str:String, x:Float, y:Float, w:Float, h:Float) 
	{
		super(x, y, w, h);
		
		textField = new TextField();
		textField.text = str;
		textField.width = w;
		textField.height = h;
		textField.multiline = textField.wordWrap = true;
		textField.textColor = 0xffffffff;
		textField.defaultTextFormat = Game.DefaultFont;
		textField.embedFonts = true;
		textField.setTextFormat(Game.DefaultFont);
		drawable = textField;
	}
	
	public function text(str:String)
	{
		textField.text = str;
	}
	
	public function append(str:String)
	{
		textField.text += str;
	}
}