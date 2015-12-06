//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.core
{
	import flash.geom.Vector3D;

	public class Position extends Component
	{
		protected var _position :Vector3D;
		protected var _parent :Position;

		// if set, these define a valid range of values, inclusive
		// TODO: should be a Rectangle instead
		protected var _max :Vector3D;
		protected var _min :Vector3D;

		public function Position()
		{
			_position = new Vector3D();
		}

		override public function start() :void
		{
			// TODO: if entity parent changes, signal and reset this
			_parent = _entity.parent != null ? _entity.parent.getComponent(Position) as Position : null;

			if (hasProperty("worldX"))
			{
				worldX = getProperty("worldX") as Number;
			}
			if (hasProperty("worldY"))
			{
				worldY = getProperty("worldY") as Number;
			}
			if (hasProperty("worldZ"))
			{
				worldZ = getProperty("worldZ") as Number;
			}
			if (hasProperty("worldW"))
			{
				worldW = getProperty("worldW") as Number;
			}
		}

		public function get worldX() :Number
		{
			return _position.x + (_parent == null ? 0 : _parent.worldX);
		}

		public function get worldY() :Number
		{
			return _position.y + (_parent == null ? 0 : _parent.worldY);
		}

		public function get worldZ() :Number
		{
			return _position.z + (_parent == null ? 0 : _parent.worldZ);
		}

		public function get worldW() :Number
		{
			return _position.w + (_parent == null ? 0 : _parent.worldW);
		}

		public function set worldX(value :Number) :void
		{
			localX = value - (_parent == null ? 0 : _parent.worldX);
		}

		public function set worldY(value :Number) :void
		{
			localY = value - (_parent == null ? 0 : _parent.worldY);
		}

		public function set worldZ(value :Number) :void
		{
			localZ = value - (_parent == null ? 0 : _parent.worldZ);
		}

		public function set worldW(value :Number) :void
		{
			localW = value - (_parent == null ? 0 : _parent.worldW);
		}

		public function get localX() :Number { return _position.x; }
		public function get localY() :Number { return _position.y; }
		public function get localZ() :Number { return _position.z; }
		public function get localW() :Number { return _position.w; }

		public function set localX(value :Number) :void
		{
			_position.x = value;

			if (_max)
			{
				_position.x = Math.min(_position.x, _max.x);
			}
			if (_min)
			{
				_position.x = Math.max(_position.x, _min.x);
			}
		}

		public function set localY(value :Number) :void
		{
			_position.y = value;

			if (_max)
			{
				_position.y = Math.min(_position.y, _max.y);
			}
			if (_min)
			{
				_position.y = Math.max(_position.y, _min.y);
			}
		}

		public function set localZ(value :Number) :void
		{
			_position.z = value;

			if (_max)
			{
				_position.z = Math.min(_position.z, _max.z);
			}
			if (_min)
			{
				_position.z = Math.max(_position.z, _min.z);
			}
		}

		public function set localW(value :Number) :void
		{
			_position.w = value;

			if (_max)
			{
				_position.w = Math.min(_position.w, _max.w);
			}
			if (_min)
			{
				_position.w = Math.max(_position.w, _min.w);
			}
		}

		public function cloneLocalPosition() :Vector3D { return _position.clone(); }

		public function setLimits(p1 :Vector3D, p2 :Vector3D) :void
		{
			if (!_max) { _max = new Vector3D(); }
			if (!_min) { _min = new Vector3D(); }

			_max.x = Math.max(p1.x, p2.x);
			_max.y = Math.max(p1.y, p2.y);
			_max.z = Math.max(p1.z, p2.z);
			_max.w = Math.max(p1.w, p2.w);
			_min.x = Math.min(p1.x, p2.x);
			_min.y = Math.min(p1.y, p2.y);
			_min.z = Math.min(p1.z, p2.z);
			_min.w = Math.min(p1.w, p2.w);
		}

		public function clearLimits() :void
		{
			_max = null;
			_min = null;
		}

		public function distance2DSquared(pos :Position) :Number
		{
			return distance2DSquared2f(pos.worldX, pos.worldY);
		}

		public function distance2DSquared2f(worldX :Number, worldY :Number) :Number
		{
			const dx :Number = worldX - this.worldX;
			const dy :Number = worldY - this.worldY;
			return dx * dx + dy * dy;
		}

	} // class

} // package

