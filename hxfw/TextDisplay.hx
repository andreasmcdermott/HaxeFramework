package hxfw;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;
import haxe.Json;
import openfl.Assets;


typedef TextLine = 
{
	text:String,
	delay:Float,
	behavior:String
};

/**
 * ...
 * @author Andreas McDermott
 */
class TextDisplay extends Entity
{
	
	private var textField:TextField;
	private var onTypingCompleted:Void->Void;
	
	public function new(x:Float, y:Float, w:Float, h:Float, str:String = "") 
	{
		super(x, y, w, h);
		
		drawable = textField = new TextField();
		textField.text = str;
		textField.width = w;
		textField.height = h;
		textField.multiline = textField.wordWrap = true;
		textField.textColor = 0xffffffff;
		textField.defaultTextFormat = Game.DefaultFont;
		textField.embedFonts = true;
		textField.setTextFormat(Game.DefaultFont);
	}
	
	public function setFont(font:TextFormat):TextDisplay
	{
		textField.setTextFormat(font);
		textField.defaultTextFormat = font;
		return this;
	}
	
	public function setOnTypingCompleted(func:Void->Void):TextDisplay
	{
		onTypingCompleted = func;
		return this;
	}
	
	public function setText(str:String):TextDisplay
	{
		textField.text = StringTools.replace(str, "\\n", "\n");
		return this;
	}
	
	public function appendText(str:String):TextDisplay
	{
		textField.text += StringTools.replace(str, "\\n", "\n");
		return this;
	}
	
	public function typeText(lines:List<TextLine>, typingSpeed:Float, ?onTypingCompleted:Void->Void = null):TextDisplay
	{
		var txt = "";
		var index = 0;
		var counter = 0;
		
		if (onTypingCompleted == null) onTypingCompleted = this.onTypingCompleted;
		
		timer.delay(function () 
		{
			var line = lines.pop();
			if (line.behavior == "replace")
			{
				txt = line.text;
				index = 0;
			}
			else txt += line.text;
			
			if(!lines.isEmpty()) timer.again(lines.first().delay);
			else if (onTypingCompleted != null) onTypingCompleted();
		}, lines.first().delay);
		
		timer.repeat(function ()
		{
			if (index < txt.length) index++;
			setText(txt.substr(0, index) + (++counter % 8 < 4 ? "_" : ""));
		}, typingSpeed);
		
		return this;
	}
	
	public function loadFromXml(id:String):TextDisplay
	{
		var xml = Xml.parse(Assets.getText(id));
		var root = xml.firstElement();
		
		if (root.firstElement() == null)
			setText(root.firstChild().nodeValue);
		else
		{
			var typingSpeed:Float = root.get("typingSpeed") != null ? Std.parseFloat(root.get("typingSpeed")) : 0.1;
			
			var lines:List<TextLine> = new List<TextLine>();
			for (line in root.elementsNamed("line"))
			{
				lines.add({ 
					text: (line.firstChild() != null) ? StringTools.replace(line.firstChild().nodeValue, "\\n", "\n") : "", 
					delay: Std.parseFloat(line.get("delay")), 
					behavior: line.get("behavior") 
				});
			}
			
			typeText(lines, typingSpeed);
		}
		
		return this;
	}
}