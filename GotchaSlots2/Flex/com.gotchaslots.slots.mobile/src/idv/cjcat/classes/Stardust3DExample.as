package idv.cjcat.classes {
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.threeD.handlers.DisplayObjectHandler3D;
	
	public class Stardust3DExample extends PausibleExample {
		
		protected var particleHandler:DisplayObjectHandler3D;
		
		public function Stardust3DExample() {
			container.x = 320;
			container.y = 240;
		}
		
		protected override function buildExtraObjects():void {
			particleHandler = new DisplayObjectHandler3D(container);
		}
		
		protected function mouseRotate():void {
			var theta:Number = 0.55 * (mouseX - 320) * StardustMath.DEGREE_TO_RADIAN;
			var phy:Number = 0.35 * (mouseY - 240) * StardustMath.DEGREE_TO_RADIAN;
			phy = StardustMath.clamp(phy, -0.45 * Math.PI, 0.45 * Math.PI);
			var r:Number = 1000;
			var x:Number = r * Math.sin(theta) * Math.cos(phy);
			var y:Number = r * Math.sin(phy);
			var z:Number = -r * Math.cos(theta) * Math.cos(phy);
			particleHandler.camera.position.x = x;
			particleHandler.camera.position.y = y;
			particleHandler.camera.position.z = z;
			particleHandler.camera.direction.set( -x, -y, -z);
		}
	}
}