package idv.cjcat.classes {
	import idv.cjcat.stardust.common.actions.CompositeAction;
	import idv.cjcat.stardust.common.clocks.Clock;
	import idv.cjcat.stardust.threeD.emitters.Emitter3D;
	
	public class PausibleEmitter3D extends Emitter3D implements PausibleEmitter {
		
		private var _actions:CompositeAction;
		
		public function PausibleEmitter3D(clock:Clock) {
			super(clock);
			
			_actions = new CompositeAction();
			addAction(_actions);
		}
		
		public function get actions():CompositeAction {
			return _actions;
		}
	}
}