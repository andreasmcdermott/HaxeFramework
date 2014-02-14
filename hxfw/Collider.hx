package hxfw;
import flash.geom.Point;
import flash.geom.Rectangle;
import hxfw.Collider.ColliderType;
import hxfw.entities.Entity;

/**
 * ...
 * @author Andreas McDermott
 */

 enum ColliderType
 {
	 Box;
	 Circle;
 }
 
class Collider
{	
	// Static
	
	public static var Solid:Int = 0;
	
	public static function resolveCollision(c1:Collider, c2:Collider)
	{
		var overlap:Point = new Point();
		
		/*if (c1.type == ColliderType.Box && c2.type == ColliderType.Box)
			overlap = getCollisionBetweenBoxes(c1, c2);
		else */if (c1.type == ColliderType.Circle && c2.type == ColliderType.Circle)
			overlap = getCollisionBetweenCircles(c1, c2);
		else if (c1.type == ColliderType.Circle && c2.type == ColliderType.Box) 
			overlap = getCollisionBetweenCircleAndBox(c1, c2);
		else if (c1.type == ColliderType.Box && c2.type == ColliderType.Circle)
			overlap = getCollisionBetweenCircleAndBox(c2, c1);
			
		if (overlap.length > 0)
		{
			if (c1.priority < c2.priority)
				c2.owner.offset(-overlap.x, -overlap.y);
			else if (c2.priority < c1.priority)
				c1.owner.offset(overlap.x, overlap.y);
			else
			{
				c1.owner.offset( -overlap.x / 2, -overlap.y / 2);
				c2.owner.offset(overlap.x / 2, overlap.y / 2);
			}
			
			return true;
		}
		
		return false;
	}
	
	public static function isColliding(c1:Collider, c2:Collider):Bool
	{
		var overlap:Point = new Point();
		
		if (c1.type == ColliderType.Circle && c2.type == ColliderType.Circle)
			overlap = getCollisionBetweenCircles(c1, c2);
		else if (c1.type == ColliderType.Circle && c2.type == ColliderType.Box) 
			overlap = getCollisionBetweenCircleAndBox(c1, c2);
		else if (c1.type == ColliderType.Box && c2.type == ColliderType.Circle)
			overlap = getCollisionBetweenCircleAndBox(c2, c1);
		
		return overlap.length != 0.0;
	}
	
	/*private static function getCollisionBetweenBoxes(c1:Collider, c2:Collider):Point
	{
		var overlap:Point = new Point();
		
		var c1Rect = getCollisionBox(c1);
		var c2Rect = getCollisionBox(c2);
		
		if (c1Rect.intersects(c2Rect))
		{
			var intersectionArea = c1Rect.intersection(c2Rect);
			
		}
		
		return overlap;
	}*/
	
	private static function getCollisionBetweenCircles(c1:Collider, c2:Collider):Point
	{
		var overlap:Point = new Point();
		
		var c1Pos = c1.owner.getPos();
		var c2Pos = c2.owner.getPos();
		var dist = Point.distance(c1Pos, c2Pos);
		
		if (dist < c1.radius + c2.radius)
		{
			overlap = new Point(c1Pos.x - c2Pos.x, c1Pos.y - c2Pos.y);
			overlap.normalize(dist);
		}
		
		return overlap;
	}
	
	private static function getCollisionBetweenCircleAndBox(circle:Collider, box:Collider):Point
	{
		var overlap:Point = new Point();
		
		var rect = getCollisionBox(box);
		
		var circlePos = circle.owner.getPos();
		circlePos.offset(circle.owner.width / 2, circle.owner.height / 2);
	
		if (rect.containsPoint(new Point(circlePos.x + circle.radius, circlePos.y)))
			overlap.setTo(-circle.radius - (circlePos.x - rect.left), 0);
		else if (rect.containsPoint(new Point(circlePos.x - circle.radius, circlePos.y)))
			overlap.setTo(circle.radius - (circlePos.x - rect.right), 0);
		else if (rect.containsPoint(new Point(circlePos.x, circlePos.y + circle.radius)))
			overlap.setTo(0, -circle.radius - (circlePos.y - rect.top));
		else if (rect.containsPoint(new Point(circlePos.x, circlePos.y - circle.radius)))
			overlap.setTo(0, circle.radius - (circlePos.y - rect.bottom));
			
		return overlap;
	}
	
	private static function getCollisionBox(box:Collider):Rectangle
	{
		if (box.type != ColliderType.Box)
			return null;
			
		var rect = box.owner.getRect();
		rect.left += box.xOffset;
		rect.right -= box.xOffset;
		rect.top += box.yOffset;
		rect.bottom -= box.yOffset;
		return rect;
	}
	
	public static function createBoxCollider(xOffset:Float, yOffset:Float, priority:Int, e:Entity):Collider
	{
		var collider = new Collider(ColliderType.Box, priority, e);
		collider.xOffset = xOffset;
		collider.yOffset = yOffset;
		return collider;
	}
	
	public static function createCircleCollider(radius:Float, priority:Int, e:Entity):Collider
	{
		var collider = new Collider(ColliderType.Circle, priority, e);
		collider.radius = radius;
		return collider;
	}
	
	// Instance
	private var type:ColliderType;
	private var priority:Int;
	private var owner:Entity;
	private var xOffset:Float;
	private var yOffset:Float;
	private var radius:Float;
	
	private function new(type:ColliderType, priority:Int, owner:Entity) 
	{
		this.type = type;
		this.owner = owner;
		this.priority = priority;
	}
}