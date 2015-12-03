
package  
{
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets 
	{
		// levels
		[Embed(source="../assets/ogmo/test.oel", mimeType="application/octet-stream")]
		public static const testLevel :Class;
		
		// ui screens
		[Embed(source="../assets/Textures/Screens/Legal.png")]
		private static const LegalScreenImg :Class;
		public static var LegalScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Title.png")]
		private static const TitleScreenImg :Class;
		public static var TitleScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/GameOver.png")]
		private static const GameOverScreenImg :Class;
		public static var GameOverScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Credits.png")]
		private static const CreditsScreenImg :Class;
		public static var CreditsScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Victory.png")]
		private static const VictoryScreenImg :Class;
		public static var VictoryScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Dialog.png")]
		private static const DialogueScreenImg :Class;
		public static var DialogueScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Loading.png")]
		private static const LoadingScreenImg :Class;
		public static var LoadingScreenTexture :Texture;

		[Embed(source="../assets/atlases/tiles.png")]
		private static var TilesImg :Class;
		[Embed(source="../assets/atlases/tiles.xml", mimeType="application/octet-stream")]
		private static var TilesXML :Class;
		public static var TilesAtlas :TextureAtlas;

		[Embed(source="../assets/atlases/entities.png")]
		private static var EntitiesImg :Class;
		[Embed(source="../assets/atlases/entities.xml", mimeType="application/octet-stream")]
		private static var EntitiesXML :Class;
		public static var EntitiesAtlas :TextureAtlas;

		static public function init() :void
		{
			LegalScreenTexture = Texture.fromBitmap(new LegalScreenImg());
			TitleScreenTexture = Texture.fromBitmap(new TitleScreenImg());
			GameOverScreenTexture = Texture.fromBitmap(new GameOverScreenImg());
			CreditsScreenTexture = Texture.fromBitmap(new CreditsScreenImg());
			VictoryScreenTexture = Texture.fromBitmap(new VictoryScreenImg());
			DialogueScreenTexture = Texture.fromBitmap(new DialogueScreenImg());
			LoadingScreenTexture = Texture.fromBitmap(new LoadingScreenImg());

			TilesAtlas = new TextureAtlas(Texture.fromBitmap(new TilesImg), XML(new TilesXML()));
			EntitiesAtlas = new TextureAtlas(Texture.fromBitmap(new EntitiesImg), XML(new TilesXML()));
		}
		
	} // class

} // package

