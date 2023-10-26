package data.api
{
	import data.manager.ApiConsts;
	import data.manager.BaseApi;
	import com.xpinator.infrastructure.helpers.JsonHelper;
	import com.xpinator.infrastructure.model.L10NData;
	
	import flash.net.URLRequestMethod;
	
	public class GetLocaleTextsByLocaleApi extends BaseApi
	{
		// consts
		public static const URL:String = ApiConsts.GET_LOCALE_TEXTS_BY_LOCALE;
		
		// properties
		public override function get Url():String
		{
			return URL;
		}
		protected override function get Method():String
		{
			return URLRequestMethod.GET;
		}
		
		// params
		public function AddParams(locale:String):void
		{
			AddParam("locale", locale);
		}
		
		// response
		public override function GetResponse():*
		{
			return L10NData(JsonHelper.MapJsonToClass(GetString(), L10NData));
		}
	}
}