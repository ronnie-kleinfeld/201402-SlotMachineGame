package idv.cjcat.stardust.threeD.zones {
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	
	public class Surface extends Zone3D {
		
		private var _virtualThickness:Number;
		
		public function Surface() {
			_virtualThickness = 1;
		}
		
		public final function get virtualThickness():Number { return _virtualThickness; }
		public final function set virtualThickness(value:Number):void {
			_virtualThickness = value;
			updateVolume();
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		public override function getXMLTagName():String {
			return "Surface";
		}
		
		public override function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@virtualThickness = virtualThickness;
			
			return xml;
		}
		
		public override function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@virtualThickness.length()) virtualThickness = parseFloat(xml.@virtualThickness);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}