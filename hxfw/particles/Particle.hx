package hxfw.particles;
import hxfw.Game;
import hxfw.entities.Entity;

/**
 * ...
 * @author Andreas McDermott
 */
class Particle extends Entity
{
	private var rotationSpeed:Float;
	private var velocityX:Float;
	private var velocityY:Float;
	
	public function new(x:Float, y:Float) 
	{
		super(x - 0.5, y - 0.5, 1, 1);
	}
	
	public function setRotationSpeed(speed:Float):Particle
	{
		rotationSpeed = speed;
		return this;
	}
	
	public function setVelocity(velocityX:Float, velocityY:Float):Particle
	{
		this.velocityX = velocityX;
		this.velocityY = velocityY;
		return this;
	}
	
	override private function update()
	{
		super.update();
		
		x += velocityX * Game.Dt;
		y += velocityY * Game.Dt;
		
		angle += rotationSpeed * Game.Dt;
	}
}