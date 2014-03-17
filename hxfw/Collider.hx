package hxfw;
import flash.geom.Point;
import flash.geom.Rectangle;
import hxfw.entities.Entity;

/**
 * ...
 * @author Andreas McDermott
 */
 
class Collider
{	
	// Static
	
	public static var Ignore:Int = -1;
	public static var Solid:Int = 0;
	private static var colliders:Array<Collider>;
	
	private static function addCollider(c:Collider):Collider
	{
		if (colliders == null)
			colliders = new Array<Collider>();
			
		colliders.push(c);
		
		return c;
	}
	
	private static function removeCollider(c:Collider)
	{
		colliders.remove(c);
	}
	
	public static function resolveCollisions():Void
	{		
		for(c1 in colliders)
		{
			for(c2 in colliders)
			{				
				if (c1 == c2) continue;
				if (!isColliding(c1, c2)) continue;
				
				if (c1.priority > Ignore && c2.priority > Ignore)
					resolveCollision(c1, c2);
					
				c1.owner.onCollision(c2.owner);
				c2.owner.onCollision(c1.owner);
			}
		}
	}
	
	private static function resolveCollision(c1:Collider, c2:Collider)
	{	
		if (c1.priority <= c2.priority)
		{
			c2.seperateFrom(c1);
		}
		else
		{
			c1.seperateFrom(c2);
		}
	}
	
	public static function isColliding(c1:Collider, c2:Collider):Bool
	{
		c1.updateCollisionBox();
		c2.updateCollisionBox();
		return c1.collisionBox.intersects(c2.collisionBox);
	}
	
	// Instance
	private var priority:Int;
	private var owner:Entity;
	private var xOffset:Float;
	private var yOffset:Float;
	private var collisionBox:Rectangle;
	
	public function new(owner:Entity, prio:Int = 0) 
	{
		this.owner = owner;
		priority = prio;
		xOffset = yOffset = 0;
		collisionBox = new Rectangle();
		addCollider(this);
	}
	
	public function setPriority(p:Int):Collider
	{
		priority = p;
		return this;
	}
	
	public function setOffset(x:Float, y:Float):Collider
	{
		xOffset = x;
		yOffset = y;
		return this;
	}
	
	public function seperateFrom(other:Collider)
	{	
		var box = collisionBox;
		var otherBox = other.collisionBox;
		
		if (otherBox.contains(box.right, box.top + box.height / 2))
			owner.setPos(otherBox.left - box.width, owner.y);
		else if(otherBox.contains(box.left, box.top + box.height / 2))
			owner.setPos(otherBox.right, owner.y);
		else if (otherBox.contains(box.left + box.width / 2, box.bottom))
			owner.setPos(owner.x, otherBox.top - box.height);
		else if (otherBox.contains(box.left + box.width / 2, box.top))
			owner.setPos(owner.x, otherBox.bottom);
	}
	
	private function updateCollisionBox():Void
	{		
		collisionBox.copyFrom(owner.getRect());
		collisionBox.left += xOffset;
		collisionBox.top += yOffset;
		collisionBox.right -= xOffset;
		collisionBox.bottom -= yOffset;
	}
	
	public function delete():Void
	{
		removeCollider(this);
	}
}