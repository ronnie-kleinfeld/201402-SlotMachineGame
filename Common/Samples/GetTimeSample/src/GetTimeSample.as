package
{
	import br.com.stimuli.loading.BulkLoader;
	
	import data.api.GetTimeApi;
	import data.manager.ServerGW;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class GetTimeSample extends Sprite
	{
		public function GetTimeSample()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var serverGW:ServerGW = new ServerGW();
			serverGW.AddApi(new GetTimeApi());
			serverGW.addEventListener(Event.COMPLETE, OnLoginComplete);
			serverGW.addEventListener(ServerGW.ServerError, OnLoginServerError);
			serverGW.Execute();
		}
		protected function OnLoginComplete(event:Event):void
		{
			try
			{
				var serverGW:ServerGW = ServerGW(event.currentTarget);
				serverGW.removeEventListener(ServerGW.ServerError, OnLoginServerError);
				serverGW.removeEventListener(Event.COMPLETE, OnLoginComplete);
				
				var result:Object = serverGW.GetResponse(GetTimeApi.URL);
			}
			catch (error:Error)
			{
			}
		}
		protected function OnLoginServerError(event:Event):void
		{
			var serverGW:ServerGW = ServerGW(event.currentTarget);
			serverGW.removeEventListener(ServerGW.ServerError, OnLoginServerError);
			serverGW.removeEventListener(Event.COMPLETE, OnLoginComplete);
		}
	}
}