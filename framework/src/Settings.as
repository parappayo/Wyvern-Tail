
package  
{
	public class Settings 
	{
		// set to false for release builds
		public static const SkipUI :Boolean = false;
		public static const ShowStats :Boolean = false;
		
		public static const ScreenWidth :Number = 800;
		public static const ScreenHeight :Number = 720;
		public static var ScreenScaleX :Number = 1;
		public static var ScreenScaleY :Number = 1;
		
		public static const TileWidth :Number = 32;
		public static const TileHeight :Number = 32;
		
		public static const SpriteFramerate :Number = 10;
		
		public static const DefaultFont :String = "Arial";
		public static const FontSize :int = 16;

		public static const StartingLevel :Class = Assets.testLevel;
		
		// TODO: implement proper localization
		public static const PauseCaption :String = "Paused";
		public static const AcceptButton :String = "Enter";

		public static const IntroCaption :String = (<![CDATA[
]]> ).toString();

	} // class

} // package

