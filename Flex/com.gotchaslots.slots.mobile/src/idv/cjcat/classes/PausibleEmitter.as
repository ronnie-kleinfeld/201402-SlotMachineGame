package idv.cjcat.classes  {
	import idv.cjcat.stardust.common.actions.CompositeAction;
	
	public interface PausibleEmitter {
		function get actions():CompositeAction;
	}
}