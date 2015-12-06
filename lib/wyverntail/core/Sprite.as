//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.core
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.DisplayObject;
	import starling.textures.Texture;

	public class Sprite extends Component
	{
		protected var _sprite :starling.display.Sprite;
		protected var _pos :Position2D;
		
		public function get sprite() :starling.display.Sprite { return _sprite; }

		public function Sprite()
		{
			_sprite = new starling.display.Sprite();
		}
		
		override public function destroy() :void
		{
			_sprite.removeFromParent(true);
			_sprite = null;
			_pos = null;
		}
		
		override public function start() :void
		{
			_pos = getComponent(Position2D) as Position2D;

			var texture :Texture = getProperty("texture") as Texture;
			if (!texture)
			{
				trace("error: Sprite component has no texture,", _entity.prefab.id);
				return;
			}

			var img :Image = new Image(texture);
			img.width = getProperty("width") as Number;
			img.height = getProperty("height") as Number;
			addChild(img);

			if (_pos)
			{
				img.pivotX = img.width * 0.5;
				img.pivotY = img.height * 0.5;
			}

			var parent :starling.display.Sprite = getProperty("parentSprite") as starling.display.Sprite;
			setParent(parent);
		}

		override public function update(elapsed :Number) :void
		{
			if (_pos == null) { return; }
			
			_sprite.x = _pos.worldX;
			_sprite.y = _pos.worldY;
		}
		
		public function setParent(parentSprite :starling.display.Sprite) :void
		{
			parentSprite.addChild(_sprite);
		}

		public function addChild(displayObject :DisplayObject) :void
		{
			_sprite.addChild(displayObject);
		}

		public function get scaleX() :Number { return _sprite.scaleX; }
		public function get scaleY() :Number { return _sprite.scaleY; }
		public function set scaleX(value :Number) :void { _sprite.scaleX = value; }
		public function set scaleY(value :Number) :void { _sprite.scaleY = value; }

	} // class

} // package

