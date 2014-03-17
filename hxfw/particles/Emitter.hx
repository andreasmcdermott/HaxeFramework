package hxfw.particles;
import flash.display.Bitmap;
import flash.geom.Point;
import hxfw.Color;
import hxfw.Factory;
import hxfw.particles.Emitter.EmitterState;
import hxfw.Random;
import hxfw.entities.Group;

using hxfw.Tween;

/**
 * ...
 * @author Andreas McDermott
 */

enum EmitterState {
	Inactive;
	Once;
	ContinousActive;
	ContinousPaused;
}
 
class Emitter extends Group
{
	// Static
	private static var particleBitmap:Bitmap;
	
	public static function setBitmap(bitmap:Bitmap)
	{
		particleBitmap = bitmap;
	}
	
	// Instance
	
	private var lifeMin:Float = 1;
	private var lifeMax:Float = 1;
	private var particleCountMin:Int = 4;
	private var particleCountMax:Int = 4;
	private var delayMin:Float = 0;
	private var delayMax:Float = 0;
	private var colorFrom:UInt = 0xffffffff;
	private var colorTo:UInt = 0x00ffffff;
	private var scaleFrom:Float = 1;
	private var scaleTo:Float = 1;
	private var rotationSpeedFrom:Float = 0;
	private var rotationSpeedTo:Float = 0;
	private var velocityFromMin:Point;
	private var velocityFromMax:Point;
	private var velocityToMin:Point;
	private var velocityToMax:Point;
	private var easing:EaseType;
	private var state:EmitterState;
	private var onDeath:Emitter->Void;
	
	public function new(x:Float=0, y:Float=0, w:Int=1, h:Int=1) 
	{
		super(x, y, w, h);		
		state = EmitterState.Inactive;
		easing = EaseType.Linear;
		velocityFromMin = new Point();
		velocityFromMax = new Point();
		velocityToMin = new Point();
		velocityToMax = new Point();
	}
	
	public function setEaseType(type:EaseType):Emitter
	{
		easing = type;
		return this;
	}

	public function setLifeSpan(min:Float, max:Float):Emitter
	{
		lifeMin = min;
		lifeMax = max;
		return this;
	}
	
	public function setParticleCount(min:Int, max:Int):Emitter
	{
		particleCountMin = min;
		particleCountMax = max;
		return this;
	}
	
	public function setDelay(min:Float, max:Float):Emitter
	{
		delayMin = min;
		delayMax = max;
		return this;
	}
	
	public function setRotationSpeed(speedFrom:Float, speedTo:Float):Emitter
	{
		rotationSpeedFrom = speedFrom;
		rotationSpeedTo = speedTo;
		return this;
	}
	
	public function setVelocity(velocityFromMin:Point, velocityFromMax:Point, velocityToMin:Point, velocityToMax:Point):Emitter
	{
		this.velocityFromMin = velocityFromMin;
		this.velocityFromMax = velocityFromMax;
		this.velocityToMin = velocityToMin;
		this.velocityToMax = velocityToMax;
		return this;
	}
	
	public function setColorTransition(colorFrom:UInt, colorTo:UInt):Emitter
	{
		this.colorFrom = colorFrom;
		this.colorTo = colorTo;
		return this;
	}
	
	public function setScaleTransition(scaleFrom:Float, scaleTo:Float):Emitter
	{
		this.scaleFrom = scaleFrom;
		this.scaleTo = scaleTo;
		return this;
	}
	
	public function pause()
	{
		state = EmitterState.ContinousPaused;
	}
	
	public function unpause()
	{
		state = EmitterState.ContinousActive;
	}
	
	public function emitOnce(onDeath:Emitter->Void = null)
	{
		state = EmitterState.Once;
		this.onDeath = onDeath;
		
		for (_ in 0...Random.intBetween(particleCountMin, particleCountMax))
		{
			newParticle();
		}
	}
	
	public function emit(emitRate:Float)
	{
		state = EmitterState.ContinousActive;
		
		timer.repeat(function () {
			if (state == EmitterState.ContinousActive && children.length < particleCountMax)
				newParticle();
		}, 1.0 / emitRate);
	}
	
	override private function update()
	{
		super.update();
		
		if (state == EmitterState.Once && children.length == 0) {
			if (onDeath != null) { onDeath(this); }
			else if (parent != null) { removeSelf(); }
		}
	}
	
	private function newParticle()
	{
		var rotationDir = Random.sign();
		var particle = new Particle(Random.floatBetween(x, x + width) - scaleFrom / 2, Random.floatBetween(y, y + height) - scaleFrom / 2)
			.setVelocity(Random.floatBetween(velocityFromMin.x, velocityFromMax.x), 
				Random.floatBetween(velocityFromMin.y, velocityFromMax.y))
			.setRotationSpeed(rotationSpeedFrom * rotationDir)
			.assignDrawable(particleBitmap)
			.setScale(scaleFrom, scaleFrom)
			.setColor(colorFrom)
			.setOrigin(0.5, 0.5);
			
		var color = Color.toRGBAFromHex(colorTo);
		particle.tween(Random.floatBetween(lifeMin, lifeMax), 
			{ scaleX: scaleTo, scaleY: scaleTo, 
				a: color.a, r: color.r, g: color.g, b: color.b,
				velocityX: Random.floatBetween(velocityToMin.x, velocityToMax.x), 
				velocityY: Random.floatBetween(velocityToMin.y, velocityToMax.y),
				rotationSpeed: rotationSpeedTo * rotationDir } )
			.delay(Random.floatBetween(delayMin, delayMax))
			.ease(easing)
			.then(function (p:Particle) {
				p.removeSelf();
			});
			
		addChild(particle);
	}
}