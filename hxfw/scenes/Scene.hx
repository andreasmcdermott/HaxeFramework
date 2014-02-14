package hxfw.scenes;
import hxfw.entities.Entity;

/**
 * ...
 * @author Andreas McDermott
 */
class Scene extends hxfw.entities.Group
{
	// Static 
	
	private static var activeScene:Scene;
	
	public static function doFrame()
	{
		if (activeScene != null)
		{
			activeScene.update();
			activeScene.draw();
		}
	}
	
	public static function goto(newScene:Scene):Scene 
	{
		var previousScene = activeScene;
		
		var f = function () { activeScene = newScene; activeScene.onEnter(); };
		
		if (activeScene != null)
			activeScene.onLeave(f);
		else
			f();
		
		return previousScene;
	}
	
	public static function drawLast(entity:Entity)
	{
		if (activeScene != null)
			activeScene.drawEntityLast(entity);
	}
	
	// End static
	
	private var camera:Camera;
	private var ready:Bool;
	private var entitiesToDrawLast:Array<Entity>;
	
	public function new() 
	{
		super();
		entitiesToDrawLast = new Array<Entity>();
	}
	
	private function drawEntityLast(entity:Entity)
	{
		entitiesToDrawLast.push(entity);
	}
	
	private function load()
	{
		camera = new Camera(Game.Width, Game.Height, Game.Scale);
		ready = true;
	}
	
	override private function update()
	{
		super.update();
		camera.update();
	}
	
	override private function draw()
	{
		super.draw();
		while(entitiesToDrawLast.length > 0)
		{
			var e = entitiesToDrawLast.pop();
			e.draw();
		}
	}
	
	private function onEnter(?onComplete:Void->Void = null)
	{
		if(!ready) load();
		
		if (onComplete != null)
			onComplete();
	}
	
	private function onLeave(?onComplete:Void->Void = null)
	{
		if (onComplete != null)
			onComplete();
	}
}