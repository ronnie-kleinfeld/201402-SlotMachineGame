package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class Milkman extends Sprite
	{
		// consts
		private static const GOOGLE_KEY:String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhzuGG8c8CPp7bUleDNGSd5mKC2dwWO9R0brLBl/fyEsXBcxQgqnHwFg9gs4a9lVexdYFQVYmkwxZ4oYtTLkDZR6KSYm4rnl3tJrLTylRNVGeaoKNs7MPq7QYCzdyZULfZjF1qAwyczyhZHaR/hvxoRqLyaZQ5RIiWlYXrH4I1Rj8NaQFWdh198xvElu1y6H6xUH8SlvMqixDR7/vTlJ1kHRJzUycQmhf6iF5imInh8q+Hd6MgwszUjrla3fIav5Prch1vSmHIVGiEb54jgR9HzcSOgX59UXuWQPfQbOU2NtAMMFAbhanz70T07aCHcdHGu/aHHXVsNqUF3D20mvVrQIDAQAB";
		
		// class
		public function Milkman()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
	}
}