package data.manager 
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class URLRequestEx
	{
		// members
		private var urlRequest:URLRequest;
		
		// properties
		public function get UrlRequest():URLRequest
		{
			return urlRequest;
		}
		
		// class
		public function URLRequestEx(url:String, method:String = URLRequestMethod.POST):void 
		{
			urlRequest = new URLRequest(url);
			urlRequest.method = method;
			
			urlRequest.data = new URLVariables();
		}
		
		// methods
		public function AddPostParam(key:String, value:Object):void
		{
			URLVariables(urlRequest.data)[key] = value;
		}
	}
}