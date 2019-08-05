package com.gotchaslots.common.utils.dataAdapter.api
{
	import com.gotchaslots.common.utils.dataAdapter.api.base.BaseApi;
	
	import flash.net.URLRequestMethod;
	
	public class GetTimeApi extends BaseApi
	{
		// consts
		public static const URL:String = "http://www.timeapi.org//utc/now";
		
		// properties
		public override function get Url():String
		{
			return URL;
		}
		protected override function get Method():String
		{
			return URLRequestMethod.GET;
		}

		// methods
		public override function GetResponse():*
		{
			return GetString();
		}
	}
}