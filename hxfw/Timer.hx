package hxfw;

/**
 * Timer for handling time based events
 * @author Andreas McDermott
 * Base on code by @x_rxi
 */
class Timer
{
	private var events:List<TimerEvent>;
	private var current:TimerEvent = null;
	
	public function new()
	{
		events = new List<TimerEvent>();
	}
	
	public function delay(action:Void->Void, delay:Float):TimerEvent
	{
		var e = new TimerEvent(this, action, delay);
		events.add(e);	
		return e;
	}
	
	public function repeat(action:Void->Void, interval:Float)
	{
		var e = delay(action, interval);
		e.repeat = true;
	}
	
	public function abort()
	{
		if (current != null)
		{
			events.remove(current);
			current = null;
		}
	}
	
	public function again(?delay:Float = null)
	{
		if (current != null)
		{
			if (delay == null)
				delay = current.delay;
			
			var e = this.delay(current.action, delay);
			e.timeout += current.timeout;
			current = null;
		}
	}
	
	public function update()
	{
		for (e in events)
		{	
			if ((e.timeout -= Game.Dt) > 0.0)
				continue;
		
			current = e;
			e.action();
			if (e.repeat)
			{
				while ((e.timeout += Game.Dt) < 0.0 && current != null)
					e.action();
					
				e.timeout = e.delay;
			}
			else
				events.remove(e);
		}
		
		current = null;
	}
}

private class TimerEvent
{
	public var delay:Float;
	public var action:Void->Void;
	public var parent:Timer;
	public var timeout:Float;
	public var repeat:Bool;
	
	public function new(parent:Timer, action:Void->Void, delay:Float)
	{
		repeat = false;
		this.parent = parent;
		this.action = action;
		this.timeout = this.delay = delay;
	}
	
	public function then(action:Void->Void, delay:Float):TimerEvent
	{
		return parent.delay(action, delay + this.delay);
	}
}