//
//	Wyvern Tail Project
//  Copyright 2015 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package common 
{
	import wyverntail.core.*;

	public class ActionButtonTrigger extends Component
	{
		public var spawnArgs :Object;
		
		private var _game :SignalHandler;
		private var _signal :int;
		private var _signalArgs :Object;
		private var _pos :Position2D;
		private var _playerPos :Position2D;
		private var _triggerRadius :Number;
		
		override public function start() :void
		{
			this.spawnArgs = spawnArgs;
			
			_game = getProperty("game") as SignalHandler;
			_signal = getProperty("signal") as int;
			_pos = getComponent(Position2D) as Position2D;
			var player :Entity = getProperty("player") as Entity;
			_playerPos = player.getComponent(Position2D) as Position2D;
			_triggerRadius = getProperty("triggerRadius") as Number;
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.ACTION_KEYUP)
			{
				var distSq :Number = _pos.distanceSquared(_playerPos);
				if (distSq < _triggerRadius * _triggerRadius)
				{
					_game.handleSignal(_signal, this, spawnArgs);
					return true;
				}
			}
			
			return false;
		}
		
	} // class

} // package
