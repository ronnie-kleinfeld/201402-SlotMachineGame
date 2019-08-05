package idv.cjcat.classes  {
	import flash.events.MouseEvent;
	
	public class PasibleExample extends StardustExample {
		
		public function PasibleExample() {
			
		}
		
		protected override function buildExtraObjects():void {
			pause_btn.addEventListener(MouseEvent.CLICK, togglePause);
		}
		
		private function togglePause(e:MouseEvent):void {
			if (e.target["label"] == "Pause") {
				emitter.active = false;
				PausibleEmitter(emitter).actions.active = false;
				e.target["label"] = "Resume";
			} else {
				emitter.active = true;
				PausibleEmitter(emitter).actions.active = true;
				e.target["label"] = "Pause";
			}
		}
	}
}