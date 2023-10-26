package idv.cjcat.classes {
	import idv.cjcat.stardust.common.math.StardustMath;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	public class PV3DExample extends PausibleExample {
		
		protected var pv3dRenderEngine:BasicRenderEngine;
		protected var pv3dCamera:Camera3D;
		protected var pv3dContainer:DisplayObject3D;
		protected var pv3dSuperContainer:DisplayObject3D;
		protected var pv3dScene:Scene3D;
		protected var pv3dViewport:Viewport3D;
		
		public function PV3DExample() {
			
		}
		
		protected override final function buildExtraObjects():void {
			pv3dRenderEngine = new BasicRenderEngine();
			pv3dCamera = new Camera3D();
			pv3dContainer = new DisplayObject3D();
			pv3dSuperContainer = new DisplayObject3D();
			pv3dScene = new Scene3D();
			pv3dViewport = new Viewport3D(640, 480);
			pv3dSuperContainer.addChild(pv3dContainer);
			pv3dScene.addChild(pv3dSuperContainer);
			container.addChild(pv3dViewport);
		}
		
		protected final function mouseRotate():void {
			pv3dContainer.rotationY = 0.65 * (320 - mouseX);
			pv3dSuperContainer.rotationX = 0.5 * (240 - mouseY);
			pv3dSuperContainer.rotationX = StardustMath.clamp(pv3dSuperContainer.rotationX, -90, 90);
		}
	}
}