package core
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		[Embed(source="../../assets/sky.png")]
		private static var sky:Class;
		public static var skyTexture:Texture;
		
		[Embed(source="../../assets/atlas.png")]
		private static var atlas:Class;
		
		public static var ta:TextureAtlas;
		
		[Embed(source="../../assets/atlas.xml", mimeType="application/octet-stream")]
		private static var atlasXML:Class;
		
		[Embed(source="../../assets/komika.png")]
		private static var komika:Class;
		
		[Embed(source="../../assets/komika.fnt", mimeType="application/octet-stream")]
		private static var komikaXML:Class;
		
		[Embed(source="../../assets/smoke.pex", mimeType="application/octet-stream")]
		public static var smokeXML:Class;
		
		[Embed(source="../../assets/explosion.pex", mimeType="application/octet-stream")]
		public static var explosionXML:Class;
		
		[Embed(source="../../assets/explosion.mp3")]
		private static var explosionSound:Class;
		public static var explosion:Sound;
		
		[Embed(source="../../assets/shoot.mp3")]
		private static var shootSound:Class;
		public static var shoot:Sound;
		
		public static function init():void
		{
			skyTexture = Texture.fromBitmap(new sky());
			
			ta = new TextureAtlas(Texture.fromBitmap(new atlas()),
				XML(new atlasXML()));
			
			TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new komika()),
				XML(new komikaXML())));
			
			explosion = new explosionSound();
			explosion.play(0, 0, new SoundTransform(0));
			
			shoot = new shootSound();
			shoot.play(0, 0, new SoundTransform(0));
		}
	}
}