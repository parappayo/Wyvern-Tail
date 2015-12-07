
package  
{
	import flash.geom.Rectangle;
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.events.EnterFrameEvent;

	import wyverntail.core.*;
	import wyverntail.ogmo.*;
	import wyverntail.collision.*;
	import common.*;

	import ui.flows.RootFlow;
	import ui.flows.FlowStates;

	CONFIG::Ouya
	{
		import flash.desktop.NativeApplication;
	}

	public class Game extends starling.display.Sprite implements SignalHandler
	{
		private var _rootFlow :RootFlow;
		
		// all UI elements that should be on top of gameplay go here
		public var UISprite :Sprite; // TODO: fix this to not be public
		
		private var _gameplaySprite :Sprite;
		private var _gameplayScene :Scene;
		private var _globalScene :Scene;
		private var _cellgrid :CellGrid;
		
		public function Game() 
		{
			Assets.init();

			_gameplaySprite = new Sprite();
			_gameplayScene = new Scene();
			_globalScene = new Scene();
			_cellgrid = new CellGrid();
			UISprite = new Sprite();
			_rootFlow = new RootFlow(this);

			definePrefabs();
			_rootFlow.changeState(ui.flows.FlowStates.FRONT_END_FLOW);

			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);

			CONFIG::Ouya
			{
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, handleAppFocusLost);
			}
			
			addChild(_gameplaySprite);
			addChild(UISprite);

			Settings.ScreenScaleX = _gameplaySprite.scaleX;
			Settings.ScreenScaleY = _gameplaySprite.scaleY;
		}

		protected function handleAddedToStage(event :starling.events.Event) :void
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			addChild(new InputHandler(this));
		}

		public function handleEnterFrame(event :EnterFrameEvent) :void
		{
			_rootFlow.update(event.passedTime);
		}

		public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (_rootFlow.handleSignal(signal, sender, args)) { return true; }
			if (_globalScene.handleSignal(signal, sender, args)) { return true; }
			if (_gameplayScene.handleSignal(signal, sender, args)) { return true; }
			
			return false;
		}

		// called only while the game is running, not paused
		public function updateSim(elapsed :Number) :void
		{
			_globalScene.update(elapsed);
			_gameplayScene.update(elapsed);
		}

		public function unloadLevel() :void
		{
			_gameplayScene.destroy();
			_gameplaySprite.removeChildren(0, -1, true);
		}

		public function loadLevel(levelData :Class, spawnPointName :String) :void
		{
			// prevent two levels from being loaded together
			unloadLevel();

			// TODO: ideally the layer definitions and their properties come out of loading the Ogmo project XML (oep) file
			var level :Level = new Level();
			level.defineLayer("walkmesh", Layer.LAYER_TYPE_GRID);
			level.defineLayer("entities", Layer.LAYER_TYPE_ENTITIES);
			level.defineLayer("background", Layer.LAYER_TYPE_TILES);
			level.init(levelData);

			var backgroundLayer :TileLayer = level.layers["background"] as TileLayer;
			backgroundLayer.tileAtlas = Assets.TilesAtlas;
			var background :TileSprite = new TileSprite();
			background.setTiles(level.layers["background"] as TileData);
			background.setParent(_gameplaySprite);

			var walkmeshLayer :GridLayer = level.layers["walkmesh"] as GridLayer;
			_cellgrid.init(level.width / Settings.TileWidth, Settings.TileWidth, Settings.TileHeight);
			_cellgrid.addData(walkmeshLayer.bitstring);

			var camera :wyverntail.core.Entity = Prefab.spawn(_gameplayScene, "camera", { target : _gameplaySprite } );
			var player :wyverntail.core.Entity = Prefab.spawn(_gameplayScene, "player", { camera : camera, worldX : 0, worldY : 0 } );

			Prefab.setProperty("player_spawn", "player", player);
			Prefab.setProperty("level_transition", "player", player);

			var entityLayer :EntityLayer = level.layers["entities"] as EntityLayer;
			entityLayer.spawn(_gameplayScene);

			handleSignal(Signals.TELEPORT_PLAYER, this, { destinationName : spawnPointName } );
		}

		protected function definePrefabs() :void
		{
			Prefab.define("camera",
				Vector.<Class>([ Position, Camera ]),
				{});

			// not all games have a player entity, but this is a reasonable starting point for top-down action games
			// (you may want to add a Player component for your game's custom player logic)
			Prefab.define("player",
				Vector.<Class>([ Position, MovieClip, Hitbox, CameraPusher, Movement4Way ]),
				//Vector.<Class>([ Position, MovieClip, Hitbox, CameraPusher, Movement4Way, Animate4Way ]),
				{
					game : this,
					parentSprite : _gameplaySprite,
					walkmesh : _cellgrid,
					cameraPusherDeadzone : new Rectangle(
							-Settings.ScreenWidth * 0.3,
							-Settings.ScreenHeight * 0.3,
							Settings.ScreenWidth * 0.6,
							Settings.ScreenHeight * 0.6 )
				});

//			var playerClip :wyverntail.core.MovieClip = player.getComponent(wyverntail.core.MovieClip) as wyverntail.core.MovieClip;
//			playerClip.addAnimation("idle_up", Assets.EntitiesAtlas.getTextures("helmut_idle_up"), Settings.SpriteFramerate);
//			playerClip.addAnimation("walk_up", Assets.EntitiesAtlas.getTextures("helmut_walk_up"), Settings.SpriteFramerate);
//			playerClip.addAnimation("idle_down", Assets.EntitiesAtlas.getTextures("helmut_idle_down"), Settings.SpriteFramerate);
//			playerClip.addAnimation("walk_down", Assets.EntitiesAtlas.getTextures("helmut_walk_down"), Settings.SpriteFramerate);
//			playerClip.addAnimation("idle_left", Assets.EntitiesAtlas.getTextures("helmut_idle_left"), Settings.SpriteFramerate);
//			playerClip.addAnimation("walk_left", Assets.EntitiesAtlas.getTextures("helmut_walk_left"), Settings.SpriteFramerate);
//			playerClip.addAnimation("idle_right", Assets.EntitiesAtlas.getTextures("helmut_idle_right"), Settings.SpriteFramerate);
//			playerClip.addAnimation("walk_right", Assets.EntitiesAtlas.getTextures("helmut_walk_right"), Settings.SpriteFramerate);

			Prefab.define("player_spawn",
				Vector.<Class>([ Position, PlayerTeleportDestination ]),
				{} );

			Prefab.define("level_transition",
				Vector.<Class>([ Position, ProximityTrigger ]),
				{
					game : this,
					triggerRadius : Settings.TileWidth + 6,
					signal : Signals.LEVEL_TRANSITION,
					canRepeat : true
				});

			addPropPrefab("barrel");
			addPropPrefab("crate");
			addPropPrefab("bookshelf");
		}

		protected function addPropPrefab(name :String) :void
		{
			var texture :Texture = Assets.EntitiesAtlas.getTexture(name);

			Prefab.define(name,
				Vector.<Class>([ Position, wyverntail.core.Sprite, CellCollider ]),
				{
					parentSprite : _gameplaySprite,
					texture : texture,
					width : texture.width,
					height : texture.height,
					cellgrid : _cellgrid
				});
		}
		
	} // class

} // package

