package hxfw.entities;

import flash.geom.ColorTransform;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;
import hxfw.Camera;
import hxfw.entities.TextDisplay.Shadow;
import openfl.Assets;


typedef TextLine = 
{
	text:String,
	delay:Float,
	behavior:String
};

typedef Shadow = 
{
	offsetX:Float,
	offsetY:Float,
	color:UInt
}

/**
 * ...
 * @author Andreas McDermott
 */
class TextDisplay extends Entity
{
	private var textField:TextField;
	private var onTypingCompleted:Void->Void;
	private var drawInScreenSpace:Bool;
	private var shadow:Shadow;
	
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
		drawInScreenSpace = false;
		shadow = null;
	}
	
	public function setShadow(offsetX:Float = 1, offsetY:Float = 1, color:UInt = 0xff000000):TextDisplay
	{
		shadow = { offsetX:offsetX, offsetY:offsetY, color:color };
		return this;
	}
	
	public function removeShadow():TextDisplay
	{
		shadow = null;
		return this;
	}
	
	override private function draw()
	{
		Camera.drawActiveCameraInScreeSpace(drawInScreenSpace);
		drawShadow();
		super.draw();
		Camera.drawActiveCameraInScreeSpace(!drawInScreenSpace);
	}
	
	private function drawShadow()
	{
		if (shadow == null) return;
		
		var origColor = getColor();
		setColor(shadow.color);
		x += shadow.offsetX;
		y += shadow.offsetY;
		super.draw();
		setColor(origColor);
		x -= shadow.offsetX;
		y -= shadow.offsetY;
	}
	
	public function drawTextInScreenSpace(d:Bool):TextDisplay
	{
		drawInScreenSpace = d;
		return this;
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