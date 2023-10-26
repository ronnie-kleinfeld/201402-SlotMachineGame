﻿package idv.cjcat.stardust.threeD.zones {
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.threeD.geom.MotionData3D;
	import idv.cjcat.stardust.threeD.geom.MotionData3DPool;
	
	public class SinglePoint3D extends Surface {
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function SinglePoint3D(x:Number = 0, y:Number = 0, z:Number = 0) {
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public override final function contains(x:Number, y:Number, z:Number):Boolean {
			if ((this.x == x) && (this.y == y) && (this.z == z)) return true;
			return false;
		}
		
		public override final function calculateMotionData3D():MotionData3D {
			return MotionData3DPool.get(x, y, z);
		}
		
		protected override final function updateVolume():void {
			volume = (4 / 3) * virtualThickness * virtualThickness * virtualThickness * Math.PI;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------

		public override function getXMLTagName():String {
			return "SinglePoint3D";
		}
		
		public override function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@x = x;
			xml.@y = y;
			xml.@z = z;
			
			return xml;
		}
		
		public override function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@x.length()) x = parseFloat(xml.@x);
			if (xml.@y.length()) y = parseFloat(xml.@y);
			if (xml.@z.length()) z = parseFloat(xml.@z);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
	
}