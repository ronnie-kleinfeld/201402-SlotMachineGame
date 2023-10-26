package idv.cjcat.classes {
	import flare.basic.Scene3D;
	import flare.core.Pivot3D;
	import flash.display.Sprite;
	import idv.cjcat.stardust.common.math.StardustMath;
	
	public class Flare3DExample extends PausibleExample {
		
		protected var f3dContainer:Pivot3D;
		protected var f3dScene:Scene3D;
		
		public function Flare3DExample() {
			
		}
		
		protected override final function buildExtraObjects():void {
			f3dContainer = new Pivot3D();
			f3dScene = new Scene3D(container);
			f3dScene.addChild(f3dContainer);
			f3dScene.camera.setPosition(0, 0, -200);
		}
		
		protected final function mouseRotate():void {
			f3dContainer.setRotation(StardustMath.clamp(0.5 * (240 - mouseY), -90, 90), 0, 0);
			f3dScene.setRotation(0, 0.65 * (320 - mouseX), 0);
		}
	}
}