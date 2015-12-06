//
//	Wyvern Tail Project
//  Copyright 2014 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.ogmo 
{
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class TileLayer extends Layer implements TileData
	{
		private var _tileAtlas :TextureAtlas;
		private var _tileNames :Vector.<String>;
		public function get tileAtlas() :TextureAtlas
		{
			return _tileAtlas;
		}
		public function set tileAtlas(value :TextureAtlas) :void
		{
			_tileAtlas = value;
			_tileNames = _tileAtlas.getNames("");
		}

		// in tiles
		private var _width :int;
		private var _height :int;
		public function get width() :int { return _width; }
		public function get height() :int { return _height; }
		
		private var _tileData :Vector.<int>;

		public function TileLayer(levelWidth :int, levelHeight :int) 
		{
			_width = levelWidth / Settings.TileWidth;
			_height = levelHeight / Settings.TileHeight;
			
			_tileData = new Vector.<int>(_width * _height);			
		}

		override public function init(data :XML) :void
		{
			for each (var tileXML :XML in data.children())
			{
				setTile(int(tileXML.@x), int(tileXML.@y), tileXML.@id);
			}
		}

		private function setTile(x :int, y :int, tile :int) :void
		{
			var i :int = y * _width + x;
			_tileData[i] = tile;
		}

		public function getTileTexture(x :int, y :int) :Image
		{
			var i :int = y * _width + x;
			var textureName :String = _tileNames[_tileData[i]];

			var tex :Texture = tileAtlas.getTexture(textureName);
			if (!tex)
			{
				trace("unknown texture: " + textureName);
				return null;
			}
			return new Image(tex);
		}
		
	} // class

} // package
