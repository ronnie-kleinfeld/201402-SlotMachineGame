package idv.cjcat.classes {
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.threeD.zedbox.handlers.ZBDisplayObjectHandler;
	import idv.cjcat.zedbox.display.RotationOrder;
	import idv.cjcat.zedbox.display.ZedScene;
	import idv.cjcat.zedbox.display.ZedSprite;
	
	public class ZBExample extends PausibleExample {
		
		protected var zbScene:ZedScene;
		
		protected var particleHandler:ZBDisplayObjectHandler;
		
		public function PV3DExample() {
			
		}
		
		protected override final function buildExtraObjects():void {
			zbScene = new ZedScene();
			zbScene.x = 320;
			zbScene.y = 240;
			
			container.addChild(zbScene);
			particleHandler = new ZBDisplayObjectHandler(zbScene);
		}
		
		protected final function mouseRotate():void {
			var theta:Number = 0.55 * (mouseX - 320) * StardustMath.DEGREE_TO_RADIAN;
			var phy:Number = 0.35 * (mouseY - 240) * StardustMath.DEGREE_TO_RADIAN;
			phy = StardustMath.clamp(phy, -0.45 * Math.PI, 0.45 * Math.PI);
			var r:Number = 1000;
			var x:Number = r * Math.sin(theta) * Math.cos(phy);
			var y:Number = r * Math.sin(phy);
			var z:Number = -r * Math.cos(theta) * Math.cos(phy);
			zbScene.camera.position.set(x, y, z);
			zbScene.camera.direction.set( -x, -y, -z);
		}
	}
}