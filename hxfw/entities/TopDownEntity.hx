package hxfw.entities;

import flash.geom.Point;

/**
 * ...
 * @author Andreas McDermott
 */
class TopDownEntity extends Entity
{
	private var velocity:Point;
	private var velocityChange:Point;
	private var acceleration = 36.0;
	private var maxSpeed = 100;
	private var friction = 0.85;
	
	public function new(x:Float, y:Float, w:Float, h:Float) 
	{
		super(x, y, w, h);
		velocity = new Point();
		velocityChange = new Point();
	}
	
	public function applyForce(force:Point)
	{
		velocityChange.x += force.x;
		velocityChange.y += force.y;
	}
	
	override private function update()
	{		
		super.update();
		updatePosition();
	}
	
	private function updatePosition()
	{
		velocityChange.normalize(acceleration);
		
		velocity.x += velocityChange.x;
		velocity.y += velocityChange.y;

		velocity.x *= friction;
		velocity.y *= friction;
		
		if (velocity.length > maxSpeed)
			velocity.normalize(maxSpeed);
		
		x += velocity.x * Game.Dt;
		y += velocity.y * Game.Dt;
		
		velocityChange.x = velocityChange.y = 0;
	}	
}