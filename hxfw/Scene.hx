package hxfw;

/**
 * ...
 * @author Andreas McDermott
 */
class Scene extends Group
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
	
	// End static
	
	private var camera:Camera;
	private var ready:Bool;
	
	public function new() 
	{
		super();
	}
	
	private function load()
	{
		camera = new Camera(Game.Width, Game.Height, Game.Scale);
		ready = true;
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