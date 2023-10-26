package
{
	import com.milkmangames.nativeextensions.GVFacebookFriend;
	import com.milkmangames.nativeextensions.GoViral;
	import com.milkmangames.nativeextensions.events.GVFacebookEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class MilkmanGoViral extends Sprite
	{
		// members
		private var _log:TextField;
		
		// class
		public function MilkmanGoViral()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			AddTextField("Create", 6, 6, onCreateClick);
			AddTextField("Init", 6, 56, onInitClick);
			AddTextField("Login", 6, 106, onLoginClick);
			AddTextField("Logout", 6, 156, onLogoutClick);
			AddTextField("Get Profile", 6, 206, onGetProfileClick);
			AddTextField("Is Supported", 6, 256, onIsSupportedClick);
			AddTextField("Is FB Supported", 6, 306, onIsFacebookSupportedClick);
			AddTextField("Is FB Authenticated", 6, 356, onIsFacebookAuthenticatedClick);
			AddTextField("Get Permissions", 6, 406, onGetPermissionsClick);
			AddTextField("Clear", 6, 456, onClearClick);
			
			_log = new TextField();
			_log.wordWrap = true;
			_log.x = 150;
			_log.y = 6;
			_log.width = 318;
			_log.height = 788
			_log.multiline = true;
			addChild(_log);
			
			Log("Initialized");
		}
		
		// methods
		private function Log(string:String):void
		{
			_log.text = _log.text + string + "\n";
		}
		private function AddTextField(text:String, x:int, y:int, onClick:Function):void
		{
			var tf:TextField = new TextField();
			tf.text = text;
			tf.x = x;
			tf.y = y;
			tf.addEventListener(MouseEvent.CLICK, onClick);
			addChild(tf);
		}
		
		// events
		private function onCreateClick(event:MouseEvent):void
		{
			try
			{
				Log("onCreateClick");
				GoViral.create();
				Log("Created");
				Log("Version " + GoViral.VERSION);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_CANCELED, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FAILED, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FINISHED, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_IN, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_OUT, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_CANCELED, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_FAILED, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_FAILED, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_RESPONSE, onFacebookEvent);
				Log("EventListener added");
			}
			catch (error:Error)
			{
				Log("Error on onCreateClick " + error.message);
			}
		}
		private function onInitClick(event:MouseEvent):void
		{
			try
			{
				Log("onInitClick");
				GoViral.goViral.initFacebook("238302886324024","");
				Log("onInitClick done");
			}
			catch (error:Error)
			{
				Log("Error on onInitClick " + error.message);
			}
		}
		private function onLoginClick(event:MouseEvent):void
		{
			try
			{
				Log("onLoginClick");
				if (GoViral.goViral.isFacebookAuthenticated())
				{
					Log("already authenticated");
				}
				else
				{
					GoViral.goViral.authenticateWithFacebook("basic_info");
				}
			}
			catch (error:Error)
			{
				Log("Error on onLoginClick " + error.message);
			}
		}
		private function onLogoutClick(event:MouseEvent):void
		{
			try
			{
				Log("onLogoutClick");
				GoViral.goViral.logoutFacebook();
			}
			catch (error:Error)
			{
				Log("Error on onLogoutClick " + error.message);
			}
		}
		private function onGetProfileClick(event:MouseEvent):void
		{
			try
			{
				Log("onGetProfileClick");
				GoViral.goViral.requestMyFacebookProfile();
			}
			catch (error:Error)
			{
				Log("Error on onGetProfileClick " + error.message);
			}
		}
		private function onIsSupportedClick(event:MouseEvent):void
		{
			try
			{
				Log("Is Supported " + GoViral.isSupported());
			}
			catch (error:Error)
			{
				Log("Error on onIsSupportedClick " + error.message);
			}
		}
		private function onIsFacebookSupportedClick(event:MouseEvent):void
		{
			try
			{
				Log("Is Facebook Supported " + GoViral.goViral.isFacebookSupported());
			}
			catch (error:Error)
			{
				Log("Error on onIsFacebookSupportedClick " + error.message);
			}
		}
		private function onIsFacebookAuthenticatedClick(event:MouseEvent):void
		{
			try
			{
				Log("Is Facebook Authenticated " + GoViral.goViral.isFacebookAuthenticated());
			}
			catch (error:Error)
			{
				Log("Error on onIsFacebookAuthenticatedClick " + error.message);
			}
		}
		private function onGetPermissionsClick(event:MouseEvent):void
		{
			try
			{
				Log("onGetPermissionsClick");
				GoViral.goViral.facebookGraphRequest("me/permissions");
			}
			catch (error:Error)
			{
				Log("Error on onGetPermissionsClick " + error.message);
			}
		}
		private function onClearClick(event:MouseEvent):void
		{
			_log.text = "";
			Log("Cleared");
		}
		
		protected function onFacebookEvent(event:GVFacebookEvent):void
		{
			Log("onFacebookEvent " + event.type);
			switch(event.type)
			{
				case GVFacebookEvent.FB_LOGGED_IN:
					break;
				case GVFacebookEvent.FB_LOGGED_OUT:
					break;
				case GVFacebookEvent.FB_LOGIN_CANCELED:
					break;
				case GVFacebookEvent.FB_LOGIN_FAILED:
					break;
				case GVFacebookEvent.FB_REQUEST_FAILED:
					break;
				case GVFacebookEvent.FB_REQUEST_RESPONSE:
					if (event.friends == null)
					{
						Log("PostSuccess");
					}
					else
					{
						switch (event.graphPath)
						{
							case "me":
								var gvFacebookFriend:GVFacebookFriend = event.friends[0];
								Log("id" + gvFacebookFriend.id);
								Log("name " + gvFacebookFriend.name);
								Log("email" + gvFacebookFriend.email());
								Log("gender " + gvFacebookFriend.gender);
								Log("installed " + gvFacebookFriend.installed);
								Log("link" + gvFacebookFriend.link);
								Log("ProfileUpdated");
								break;
							case "me/permissions":
								var permissions:Object = event.data.data[0];
								Log("Permissions " + event.jsonData);
								break;
							default:
								Log("RequestFailed");
						}
					}
					break;
				default:
					Log("RequestFailed");
			}
		}
	}
}