package hxfw;

/**
 * ...
 * @author Andreas McDermott
 * Based on code by @x_rxi
 */

typedef Target = { start:Float, end:Float, difference:Float }

enum EaseType
{
	Linear;
	EaseInAndOut;
	SquaredEaseIn;
	SquaredEaseOut;
	ExpoEaseIn;
	ExpoEaseOut;
}

enum RepeatType
{
	None;
	Reverse;
	Restart;
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
				if (tween.onComplete != null)
					tween.onComplete(tween.target);
				
				if (tween.repeatType == RepeatType.None || tween.repeatCount == 0)
					tweens.remove(tween);
				else
				{
					tween.progress = 0.0;
					tween.repeatCount--;
				
					if (tween.repeatType == RepeatType.Reverse)
						tween.reset();
				}
			}
		}
	}
	
	public static function tween(target:Dynamic, time:Float, fields:Dynamic = null):Tween
	{
		var tween = getTweenByTarget(target);
		if(tween != null)
			for (key in Reflect.fields(fields))
				tween.fields.remove(key);
		
		tween = new Tween(target, time, fields);
	  tweens.add(tween);
		return tween;
	}
	
	public static function repeatTween(target:Dynamic, repeat:RepeatType):Tween
	{
		var tween = getTweenByTarget(target);
		if (tween != null)
		{
			tween.repeatType = repeat;
			tween.repeatCount = 1;
		}
		return tween;
	}
	
	public static function abortTween(target:Dynamic)
	{
		var tween = getTweenByTarget(target);
		if (tween != null)
			tweens.remove(tween);
	}
	
	private inline static function getTweenByTarget(target:Dynamic):Tween
	{
		for (tween in tweens)
			if (tween.target == target)
				return tween;
		
		return null;
	}
	
	// End static
	
	private var progress:Float;
	private var target:Dynamic;
	private var rate:Float;
	private var easing:EaseType;
	private var repeatType:RepeatType;
	private var repeatCount:Int;
	private var delayCounter:Float;
	private var onComplete:Dynamic->Void;
	private var fields:Map<String, Target>;
	
	public function new(target:Dynamic, time:Float, variables:Dynamic) 
	{
		repeatType = RepeatType.None;
		repeatCount = -1;
		delayCounter = 0.0;
		rate = (time > 0.0) ? 1.0 / time : 1.0;
		progress = 0.0;
		this.target = target;
		easing = EaseType.EaseInAndOut;
		fields = new Map<String, Target>();
		for (key in Reflect.fields(variables))
		{
			var originalValue:Float = Reflect.getProperty(target, key);
			var newValue:Float = Reflect.field(variables, key);
			fields.set(key, { start: originalValue, end: newValue, difference: newValue - originalValue } );
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
	
	public function repeat(repeat:RepeatType, count:Int = -1):Tween
	{
		repeatType = repeat;
		repeatCount = count;
		return this;
	}
	
	private function reset()
	{
		for (field in fields)
		{
			var temp = field.start;
			field.start = field.end;
			field.end = temp;
			field.difference = field.end - field.start;
		}
	}
}