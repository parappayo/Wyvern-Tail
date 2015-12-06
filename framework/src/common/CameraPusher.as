//
//	Wyvern Tail Project
//  Copyright 2015 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package common
{
	import flash.geom.Rectangle;
	import wyverntail.core.*;

	public class CameraPusher extends Component
	{
		private var _pos :Position2D;
		private var _camera :Camera;
		private var _deadzone :Rectangle

		override public function start() :void
		{
			var cameraEntity :Entity = getProperty("camera") as Entity;

			_pos = getComponent(Position2D) as Position2D;
			_camera = cameraEntity.getComponent(Camera) as Camera;
			_deadzone = getProperty("cameraPusherDeadzone") as Rectangle;

			_camera.worldX = _pos.worldX;
			_camera.worldY = _pos.worldY;
		}

		override public function update(elapsed :Number) :void
		{
			var dx :Number = _pos.worldX - _camera.worldX;
			var dy :Number = _pos.worldY - _camera.worldY;

			if (dx < _deadzone.left)
			{
				_camera.worldX = _pos.worldX + _deadzone.right;
			}
			else if (dx > _deadzone.right)
			{
				_camera.worldX = _pos.worldX + _deadzone.left;
			}

			if (dy < _deadzone.top)
			{
				_camera.worldY = _pos.worldY + _deadzone.bottom;
			}
			else if (dy > _deadzone.bottom)
			{
				_camera.worldY = _pos.worldY + _deadzone.top;
			}
		}

		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.CENTER_CAMERA)
			{
				_camera.worldX = _pos.worldX;
				_camera.worldY = _pos.worldY;
			}
			return false;
		}

	} // class

} // package
