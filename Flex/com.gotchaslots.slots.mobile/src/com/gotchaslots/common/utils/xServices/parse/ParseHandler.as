package com.gotchaslots.common.utils.xServices.parse
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.application.prices.ProductID;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	
	public class ParseHandler
	{
		// consts
		public static const REST_URL:String = 'https://api.parse.com/1/';
		public static const APPLICATION_ID:String = '2427pvd0O8hZMUtyc1h2qY7A3pc5O3KeiK3m8P4Q';
		public static const REST_API_KEY:String = 'fBwJrtiaDbVwdCSONRBwklpTrC9xhIjWjR7sAVjE';
		public static const CONTENT_TYPE:String = 'application/json';
		
		// members
		private var User:Object =
			{
				Delete: function (objectId:String, success:Function = null, error:Function = null):void
				{
					var url:String = REST_URL + 'users/' + objectId;
					Call(url, URLRequestMethod.DELETE, null, null, success, error);
				},
				Get: function (objectId:String, success:Function = null, error:Function = null):void
				{
					var url:String = REST_URL + 'users/' + objectId;
					Call(url, URLRequestMethod.GET, null, null, success, error);
				},
				Post: function (params:Object, success:Function = null, error:Function = null):void
				{
					var url:String = REST_URL + 'users';
					Call(url, URLRequestMethod.POST, params, null, success, error);				
				},
				Put: function (objectId:String, params:Object, success:Function = null, error:Function = null):void
				{
					var url:String = REST_URL + 'users/' + objectId;
					Call(url, URLRequestMethod.PUT, params, null, success, error);
				},
				Search: function (where:Object, success:Function = null, error:Function = null):void
				{
					var url:String = REST_URL + 'users';
					Call(url, URLRequestMethod.GET, null, where, success, error);
				}
			}
		
		// class
		public function ParseHandler()
		{
		}
		
		// methods
		public function RegisterDevice(success:Function, error:Function):void
		{
			try
			{
				Post('Devices', {
					deviceID: Main.Instance.XServices.DeviceID.DeviceID,
					os: Capabilities.os,
					deviceWidth: Main.Instance.Device.DeviceRectangle.width,
					deviceHeight: Main.Instance.Device.DeviceRectangle.height,
					deviceType: Main.Instance.Device.DeviceType,
					version: Main.Instance.CurrentVersion}, success, error);
			}
			catch (error:Error)
			{
			}
		}
		
		public function FacebookConnect():void
		{
			try
			{
				Post('Facebook', {
					deviceID: Main.Instance.XServices.DeviceID.DeviceID,
					os: Capabilities.os,
					facebookUid: Main.Instance.XServices.Social.FacebookUid,
					facebookName: Main.Instance.XServices.Social.FacebookName,
					facebookAccessToken: Main.Instance.XServices.Social.FacebookAccessToken},
					null, null);
			}
			catch (error:Error)
			{
			}
		}
		
		public function PurchaseComplete(_productID:String, _chips:int):void
		{
			try
			{
				Post('Purchase', {
					deviceID: Main.Instance.XServices.DeviceID.DeviceID,
					os: Capabilities.os,
					facebookUid: Main.Instance.XServices.Social.FacebookUid,
					facebookName: Main.Instance.XServices.Social.FacebookName,
					facebookAccessToken: Main.Instance.XServices.Social.FacebookAccessToken,
					balance: Main.Instance.Session.Wallet.GetBalance,
					xp: Main.Instance.Session.Wallet.GetXP,
					level: Main.Instance.Session.Wallet.GetLevel.LevelNumber,
					localTime: Main.Instance.XServices.InternetTime.CurrentLocalDateTime,
					chips: _chips,
					productID: _productID,
					productDescription: ProductID.DescriptionByProductID(_productID),
					productPrice: ProductID.PriceByProductID(_productID)},
					null, null);
			}
			catch (error:Error)
			{
			}
		}
		
		public function GetApps(success:Function, error:Function):void
		{
			try
			{
				Query('Apps', null, null, success, error);
			}
			catch (error:Error)
			{
			}
		}
		public function CreateApps():void
		{
			try
			{
				Post('Apps', {
					appName: "Slots",
					iTunes: "https://itunes.apple.com/us/app/gotchaslots/id795214708?l=iw&ls=1&mt=8",
					googlePlay: "https://play.google.com/store/apps/details?id=air.com.gotchaslots.slots",
					smallPhoto: "http://www.gotchaslots.com/apps/photos/SlotsSmall.jpg",
					largePhoto: "http://www.gotchaslots.com/apps/photos/SlotsLarge.jpg",
					active: true},
					null, null);
				Post('Apps', {
					appName: "Slots2",
					iTunes: "https://itunes.apple.com/us/app/gotchaslots/id795214708?l=iw&ls=1&mt=8",
					googlePlay: "https://play.google.com/store/apps/details?id=air.com.gotchaslots.slots",
					smallPhoto: "http://www.gotchaslots.com/apps/photos/SlotsSmall.jpg",
					largePhoto: "http://www.gotchaslots.com/apps/photos/SlotsLarge.jpg",
					active: false},
					null, null);
			}
			catch (error:Error) 
			{
			}
		}
		
		// methods
		private function Delete(className:String, objectId:String, success:Function = null, error:Function = null):void
		{
			var url:String = REST_URL + 'classes/' + className + '/' + objectId;
			Call(url, URLRequestMethod.DELETE, null, null, success, error);
		}
		private function Retrieve(className:String, objectId:String, success:Function = null, error:Function = null):void
		{
			var url:String = REST_URL + 'classes/' + className + '/' + objectId;
			Call(url, URLRequestMethod.GET, null, null, success, error);
		}
		private function Query(className:String, params:Object = null, where:Object = null, success:Function = null, error:Function = null):void
		{
			var url:String = REST_URL + 'classes/' + className;
			Call(url, URLRequestMethod.GET, params, where, success, error);
		}
		private function Post(className:String, params:Object = null, success:Function = null, error:Function = null):void
		{
			var url:String = REST_URL + 'classes/' + className;
			Call(url, URLRequestMethod.POST, params, null, success, error);
		}
		private function Put(className:String, objectId:String, params:Object = null, success:Function = null, error:Function = null):void
		{
			var url:String = REST_URL + 'classes/' + className + '/' + objectId;
			Call(url, URLRequestMethod.PUT, params, null, success, error);
		}
		private function SignIn(username:String, password:String, success:Function = null, error:Function = null):void
		{
			var params:Object = {username: username, password: password};
			var url:String = REST_URL + 'login';
			Call(url, URLRequestMethod.GET, params, null, success, error);
		}
		private function SignUp(params:Object, success:Function = null, error:Function = null):void
		{
			User.Post(params, success, error);
		}
		private function ResetPassword(email:String, success:Function = null, error:Function = null):void
		{
			var params:Object = {email: email};
			var url:String = REST_URL + 'requestPasswordReset';
			Call(url, URLRequestMethod.POST, params, null, success, error);
		}
		
		private function Batch(requests:Array, success:Function, error:Function):void
		{
			var params:Object = {requests: requests};
			var url:String = REST_URL + 'batch';
			Call(url, URLRequestMethod.POST, params, null, success, error);
		}
		
		// methods
		private function Call(url:String, method:String, params:Object = null, where:Object = null, success:Function = null, error:Function = null):void
		{
			try
			{
				if (Main.Instance.Device.IsMobile)
				{
					var urlLoader:URLLoader = new URLLoader();
					var urlRequest:URLRequest = new URLRequest(url);
					
					if (where != null)
					{
						if (params == null)
						{
							params = {};
						}
						params['where'] = JSON.stringify(where); 
					}
					
					if (params != null) { 
						if (method == URLRequestMethod.GET)
						{
							var vars:URLVariables = new URLVariables();
							for (var p:String in params)
							{
								vars[p] = params[p];
							}
							urlRequest.data = vars;
						}
						else
						{ 
							urlRequest.data = JSON.stringify(params); 
						}
					}
					urlRequest.contentType = CONTENT_TYPE;
					urlRequest.cacheResponse = false;
					urlRequest.method = method;
					urlRequest.useCache = false;
					urlRequest.requestHeaders.push(new URLRequestHeader('X-Parse-Application-Id', APPLICATION_ID));
					urlRequest.requestHeaders.push(new URLRequestHeader('X-Parse-REST-API-Key', REST_API_KEY));
					
					if (success != null)
					{
						urlLoader.addEventListener(Event.COMPLETE, function (event:Event):void
						{
							var data:Object = JSON.parse(event.target.data);
							success(data);
						}, false, 0, true);
					}
					if (error != null)
					{
						urlLoader.addEventListener(IOErrorEvent.IO_ERROR, error, false, 0, true);
					}
					
					urlLoader.load(urlRequest);
				}
				else
				{
					success(null);
				}
			}
			catch (error:Error)
			{
			}
		}
	}
}