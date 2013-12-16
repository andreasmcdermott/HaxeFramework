package hxfw;

/**
 * ...
 * @author Andreas McDermott
 * Based on code by @x_rxi
 */

typedef Target = { start:Float, difference:Float }

enum EaseType
{
	Linear;
	EaseInAndOut;
	SquaredEaseIn;
	SquaredEaseOut;
	ExpoEaseIn;
	ExpoEaseOut;
}

class Tween
{
	// Static

	private static var tweens:List<Tween> = new List<Tween>();
	
	public static function update()
	{
		for (tween in tweens)
		{
			if (tween.delayCounter > 0.0)
			{
				tween.delayCounter -= Game.Dt;
				continue;
			}
				
			tween.progress += tween.rate * Game.Dt;
			var currentProgress:Float = (tween.progress >= 1.0) ? 1.0 : 
			switch(tween.easing)
			{
				case EaseType.Linear:
					tween.progress;
				case EaseType.EaseInAndOut:
					tween.progress * tween.progress  * (3 - 2 * tween.progress);
				case EaseType.SquaredEaseIn:
					tween.progress * tween.progress;
				case EaseType.SquaredEaseOut:
					1 - (1 - tween.progress) * (1 - tween.progress);
				case EaseType.ExpoEaseIn:
					Math.pow(2, 10 * (tween.progress - 1));
				case EaseType.ExpoEaseOut:
					-Math.pow(2, -10 * tween.progress) + 1;
			}
			
			for (key in tween.fields.keys())
			{
				var value = tween.fields.get(key);
				Reflect.setProperty(tween.target, key, value.start + currentProgress * value.difference);
			}
			
			if (currentProgress >= 1.0)
			{
				tweens.remove(tween);
				if (tween.onComplete != null)
					tween.onComplete(tween.target);
			}
		}
	}
	
	public static function tween(target:Dynamic, time:Float, fields:Dynamic = null):Tween
	{
		for (tween in tweens)
		{
			if (tween.target != target)
				continue;
			for (key in Reflect.fields(fields))
			{
				tween.fields.remove(key);
			}
		}
		
		var tween = new Tween(target, time, fields);
	  tweens.add(tween);
		return tween;
	}
	
	// End static
	
	private var progress:Float;
	private var target:Dynamic;
	private var rate:Float;
	private var easing:EaseType;
	private var delayCounter:Float;
	private var onComplete:Dynamic->Void;
	private var fields:Map<String, Target>;
	
	public function new(target:Dynamic, time:Float, variables:Dynamic) 
	{
		delayCounter = 0.0;
		rate = (time > 0.0) ? 1.0 / time : 1.0;
		progress = 0.0;
		this.target = target;
		easing = EaseType.EaseInAndOut;
		fields = new Map<String, Target>();
		for (key in Reflect.fields(variables))
		{
			var targetValue:Float = Reflect.getProperty(target, key);
			fields.set(key, { start: targetValue, difference: Reflect.field(variables, key) - targetValue } );
		}
	}
	
	public function delay(time:Float):Tween
	{
		delayCounter = time;
		return this;
	}
	
	public function then(onComplete:Dynamic->Void):Tween
	{
	  this.onComplete = onComplete;
		return this;
	}
	
	public function ease(easing:EaseType):Tween
	{
		this.easing = easing;
		return this;
	}
}