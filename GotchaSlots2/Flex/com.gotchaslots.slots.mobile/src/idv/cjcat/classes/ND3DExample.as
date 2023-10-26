package idv.cjcat.classes {
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.renderer.Renderer;
	import idv.cjcat.stardust.common.math.StardustMath;
	
	public class ND3DExample extends PausibleExample {
		
		protected var nd3dRenderer:Renderer;
		protected var nd3dCamera:PointCamera;
		protected var nd3dRenderList:Array;
		
		public function ND3DExample() {
			
		}
		
		protected override final function buildExtraObjects():void {
			nd3dRenderer = new Renderer(container);
			nd3dCamera = new PointCamera(640, 480);
			nd3dRenderList = [];
		}
		
		protected final function mouseRotate():void {
			var theta:Number = 0.55 * (mouseX - 320) * StardustMath.DEGREE_TO_RADIAN;
			var phy:Number = 0.35 * (mouseY - 240) * StardustMath.DEGREE_TO_RADIAN;
			phy = StardustMath.clamp(phy, -0.45 * Math.PI, 0.45 * Math.PI);
			var r:Number = 10;
			var x:Number = r * Math.sin(theta) * Math.cos(phy);
			var y:Number = r * Math.sin(phy);
			var z:Number = -r * Math.cos(theta) * Math.cos(phy);
			nd3dCamera.x = x;
			nd3dCamera.y = y;
			nd3dCamera.z = z;
			
			nd3dCamera.angleX = -phy;
			nd3dCamera.angleY = -theta;
		}
	}
}