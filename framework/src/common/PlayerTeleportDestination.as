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
	
	public class PlayerTeleportDestination extends Component
	{
		private var _game :SignalHandler;
		private var _name :String;
		private var _pos :Position;
		private var _playerPos :Position;
		
		override public function start() :void
		{
			_game = getProperty("game") as SignalHandler;
			_name = getProperty("name") as String;
			_pos = getComponent(Position) as Position;

			var player :Entity = getProperty("player") as Entity;
			_playerPos = player.getComponent(Position) as Position;
		}

		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.TELEPORT_PLAYER)
			{
				if (_name == args.destinationName)
				{
					_playerPos.worldX = _pos.worldX;
					_playerPos.worldY = _pos.worldY;
					
					_game.handleSignal(Signals.CENTER_CAMERA, this, { } );
					return true;
				}
			}

			return false;
		}

	} // class

} // package
