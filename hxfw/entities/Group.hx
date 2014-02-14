package hxfw.entities;
import hxfw.entities.Entity;

/**
 * ...
 * @author Andreas McDermott
 */
class Group extends Entity
{
	public var forceBounds(default, null):Bool;
	private var children:Array<Entity>;
	
	public function new(x:Float = 0, y:Float = 0, w:Int = 0, h:Int = 0) 
	{
		super(x, y, w, h);
		forceBounds = false;
		children = new Array<Entity>();
	}
	
	public function addChild(child:Entity):Entity
	{
		children.push(child);
		child.parent = this;
		return child;
	}
	
	public function removeChild(child:Entity)
	{
		child.parent = null;
		children.remove(child);
	}
	
	public function removeChildren()
	{
		for (child in children)
			child.parent = null;
		children = new Array<Entity>();
	}
	
	public function iterator():Iterator<Entity>
	{
		return children.iterator();
	}
	
	override public function resolveCollision(other:Entity):Bool
	{
		var collision:Bool = super.resolveCollision(other);
		for (child in children)
		{
			if (child.resolveCollision(other))
				collision = true;
		}
		
		return collision;
	}
	
	override private function update()
	{
		super.update();
		for (child in children)
			child.update();
	}
	
	override private function draw()
	{
		super.draw();
		for (child in children)
			child.draw();
	}
}