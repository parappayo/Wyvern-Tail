package common 
{
	import wyverntail.core.*;
	
	public class PlayerTeleportDestination extends Component
	{
		private var _game :Game;
		private var _name :String;
		private var _pos :Position2D;
		private var _playerPos :Position2D;
		
		override public function start() :void
		{
			_game = getProperty("game") as Game;
			_name = getProperty("name") as String;
			_pos = getComponent(Position2D) as Position2D;

			var player :Entity = getProperty("player") as Entity;
			_playerPos = player.getComponent(Position2D) as Position2D;
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
