package data.manager
{
	import flash.events.Event;
	
	public class ServerGWEvent extends Event
	{
		// events
		public static const Complete:String = "Complete";
		
		// members
		private var _serverGW:ServerGW;
		
		// properties
		public function get GetServerGW():ServerGW
		{
			return _serverGW;
		}
		
		// class
		public function ServerGWEvent(type:String, serverGW:ServerGW, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_serverGW = serverGW;
		}
	}
}