package
{
	import flash.display.Sprite;
	
	import temple.facebook.adapters.FacebookDummyAdapter;
	import temple.facebook.api.FacebookAPI;
	
	public class TempleLibrary extends Sprite
	{
		private var _facebook:FacebookAPI;
		
		public function TempleLibrary()
		{
			super();
			
			var adapter:FacebookDummyAdapter = new FacebookDummyAdapter();
			_facebook = new FacebookAPI(adapter);
			_facebook.init("165574113638046");
			
			//_facebook.dialogs.feedDialog();
			//_facebook.dialogs.friendsDialog("100004032744210");
			//_facebook.dialogs.requestDialog("Check this out!");
			_facebook.dialogs.oauthDialog("http://templelibrary.googlecode.com");
		}
	}
}