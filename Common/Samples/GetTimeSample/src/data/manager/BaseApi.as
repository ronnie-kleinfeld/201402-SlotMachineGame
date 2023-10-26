package data.manager
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.net.URLRequestMethod;
	
	public class BaseApi extends EventDispatcher
	{
		// members
		private var _serverGW:ServerGW;
		protected var _key:String;
		protected var _urlRequestEx:URLRequestEx;
		
		// properties
		public function get Key():String
		{
			return _key;
		}
		public function get GetServerGW():ServerGW
		{
			return _serverGW;
		}
		public function set ServerGW(value:ServerGW):void
		{
			_serverGW = value;
		}
		public function get Url():String
		{
			throw new NotImplementedError();
		}
		public function get GetURLRequestEx():URLRequestEx
		{
			return _urlRequestEx;
		}
		protected function get Method():String
		{
			return URLRequestMethod.POST;
		}
		public function get ServerErrorAction():int
		{
			return ServerErrorActionEnum.BUBBLE;
		}
		public function get MaxTries():int
		{
			return 3;
		}
		public function get BulkLoaderType():String
		{
			return "";
		}
		public function get LinkagePre():String
		{
			return "";
		}
		protected function get AddRandom():Boolean
		{
			return false;
		}
		
		// class
		public function BaseApi()
		{
			super();
			
			Init(Url);
		}
		public function Init(url:String):void
		{
			_key = url;
			
			_urlRequestEx = new URLRequestEx(url, Method);
		}
		
		public function Dispose():void
		{
			
		}
		
		// params
		protected function AddParam(key:String, value:Object):void
		{
			_urlRequestEx.AddPostParam(key, value);
		}
		
		// response
		public function GetResponse():*
		{
			throw new NotImplementedError();
		}
		protected function GetString():String
		{
			var result:String = _serverGW.GetBulkLoader.getText(Key);
			return result;
		}
		
		protected function GetXML():XML
		{
			var result:XML = _serverGW.GetBulkLoader.getXML(Key);
			return result;
		}
		
		protected function GetMovieClip():MovieClip
		{
			var result:MovieClip = _serverGW.GetBulkLoader.getMovieClip(Key);
			return result;
		}
		
		protected function GetBitmap():Bitmap
		{
			var result:Bitmap = _serverGW.GetBulkLoader.getBitmap(Key);
			return result;
		}
	}
}