package idv.cjcat.classes {
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.materials.special.LineMaterial;
	
	public class PV3DExampleWithCube extends PV3DExample {
		
		public function PV3DExampleWithCube() {
			var lineMat:LineMaterial = new LineMaterial(0x808080, 1);
			var lines:Lines3D = new Lines3D();
			pv3dContainer.addChild(lines);
			lines.addLine(new Line3D(lines, lineMat, 1, new Vertex3D( 320, 320, 320), new Vertex3D( -320, 320, 320)));
			lines.addLine(new Line3D(lines, lineMat, 1, new Vertex3D( -320, 320, 320), new Vertex3D( -320, -320, 320)));
			lines.addLine(new Line3D(lines, lineMat, 1, new Vertex3D( -320, -320, 320), new Vertex3D( 320, -320, 320)));
			lines.addLine(new Line3D(lines, lineMat, 1, new Vertex3D( 320, -320, 320), new Vertex3D( 320, 320, 320)));
			lines.addLine(new Line3D(lines, lineMat, 1, new Vertex3D( 320, -320, 320), new Vertex3D( 320, -320, -320)));
			lines.addLine(new Line3D(lines, lineMat, 1, new Vertex3D( 320, 320, 320), new Vertex3D( 320, 320, -320)));
			lines.addLine(new Line3D(lines, lineMat, 1, new Vertex3D( -320, 320, 320), new Vertex3D( -320, 320, -320)));
			lines.addLine(new Line3D(lines, lineMat, 1, new Vertex3D( -320, -320, 320), new Vertex3D( -320, -320, -320)));
			lines.addLine(new Line3D(lines, lineMat, 1, new Vertex3D( 320, -320, -320), new Vertex3D( 320, 320, -320)));
			lines.addLine(new Line3D(lines, lineMat, 1, new Vertex3D( 320, 320, -320), new Vertex3D( -320, 320, -320)));
			lines.addLine(new Line3D(lines, lineMat, 1, new Vertex3D( -320, 320, -320), new Vertex3D( -320, -320, -320)));
			lines.addLine(new Line3D(lines, lineMat, 1, new Vertex3D( -320, -320, -320), new Vertex3D( 320, -320, -320)));
		}
	}
}