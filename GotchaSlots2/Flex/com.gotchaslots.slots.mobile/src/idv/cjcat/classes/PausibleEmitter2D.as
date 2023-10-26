package idv.cjcat.classes {
	import idv.cjcat.stardust.common.actions.CompositeAction;
	import idv.cjcat.stardust.common.clocks.Clock;
	import idv.cjcat.stardust.twoD.emitters.Emitter2D;
	
	public class PausibleEmitter2D extends Emitter2D implements PausibleEmitter {
		
		private var _actions:CompositeAction;
		
		public function PausibleEmitter2D(clock:Clock) {
			super(clock);
			
			_actions = new CompositeAction();
			addAction(_actions);
		}
		
		public function get actions():CompositeAction {
			return _actions;
		}
	}
}