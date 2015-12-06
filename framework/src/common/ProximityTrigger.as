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

	public class ProximityTrigger extends Component
	{
		public var spawnArgs :Object;

		private var _game :SignalHandler;
		private var _signal :int;
		private var _signalArgs :Object;
		private var _pos :Position;
		private var _playerPos :Position;
		private var _triggerRadius :Number;
		private var _isTriggered :Boolean;
		private var _canRepeat :Boolean;
		
		override public function start() :void
		{
			this.spawnArgs = spawnArgs;

			_game = getProperty("game") as SignalHandler;
			_signal = getProperty("signal") as int;
			_pos = getComponent(Position) as Position;
			var player :Entity = getProperty("player") as Entity;
			_playerPos = player.getComponent(Position) as Position;
			_triggerRadius = getProperty("triggerRadius") as Number;
			_isTriggered = false;
			_canRepeat = getProperty("canRepeat") as Boolean;
		}
		
		override public function update(elapsed :Number) :void
		{
			var distSq :Number = _pos.distance2DSquared(_playerPos);
			if (distSq < _triggerRadius * _triggerRadius)
			{
				if (!_isTriggered)
				{
					_game.handleSignal(_signal, this, spawnArgs);
					
					_isTriggered = true;
				}
			}
			else if (_canRepeat && distSq > _triggerRadius * _triggerRadius * 1.44)
			{
				_isTriggered = false;
			}
		}

	} // class

} // package
