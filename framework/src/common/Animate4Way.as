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

	public class Animate4Way extends Component
	{
		protected var _clip :MovieClip;
		protected var _mover :Movement4Way;

		protected static const DIRECTION_UP :int = 0;
		protected static const DIRECTION_DOWN :int = 1;
		protected static const DIRECTION_LEFT :int = 2;
		protected static const DIRECTION_RIGHT :int = 3;
		protected var _facingDirection :int;

		override public function start() :void
		{
			_clip = getComponent(wyverntail.core.MovieClip) as wyverntail.core.MovieClip;
			_mover = getComponent(Movement4Way) as Movement4Way;
			_facingDirection = DIRECTION_DOWN;
		}

		override public function update(elapsed :Number) :void
		{
			if (!enabled) { return; }

			if (_mover.isMovingUp)
			{
				_facingDirection = DIRECTION_UP;
				_clip.play("walk_up", true);
			}
			else if (_mover.isMovingDown)
			{
				_facingDirection = DIRECTION_DOWN;
				_clip.play("walk_down", true);
			}
			else if (_mover.isMovingLeft)
			{
				_facingDirection = DIRECTION_LEFT;
				_clip.play("walk_left", true);
			}
			else if (_mover.isMovingRight)
			{
				_facingDirection = DIRECTION_RIGHT;
				_clip.play("walk_right", true);
			}
			else if (_facingDirection == DIRECTION_UP)
			{
				_clip.play("idle_up", true);
			}
			else if (_facingDirection == DIRECTION_LEFT)
			{
				_clip.play("idle_left", true);
			}
			else if (_facingDirection == DIRECTION_RIGHT)
			{
				_clip.play("idle_right", true);
			}
			else
			{
				_clip.play("idle_down", true);
			}
		}

	} // class

} // package
