package idv.cjcat.stardust.twoD.actions.triggers {
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	import idv.cjcat.stardust.twoD.zones.SinglePoint;
	import idv.cjcat.stardust.twoD.zones.Zone;
	
	/**
	 * This action trigger is triggered when a particle is contained in a zone.
	 * 
	 * <p>
	 * Default priority = -6;
	 * </p>
	 */
	public class ZoneTrigger extends ActionTrigger2D {
		
		private var _zone:Zone;
		public function ZoneTrigger(zone:Zone = null) {
			priority = -6;
			
			this.zone = zone;
		}
		
		public function get zone():Zone { return _zone; }
		public function set zone(value:Zone):void {
			if (!value) value = new SinglePoint(0, 0);
			_zone = value;
		}
		
		public override function testTrigger(emitter:Emitter, particle:Particle, time:Number):Boolean {
			var p2D:Particle2D = Particle2D(particle);
			return _zone.contains(p2D.x, p2D.y);
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		public override function getRelatedObjects():Array {
			return [_zone];
		}
		
		public override function getXMLTagName():String {
			return "ZoneTrigger";
		}
		
		public override function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@zone = _zone.name;
			
			return xml;
		}
		
		public override function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@zone.length()) zone = builder.getElementByName(xml.@zone) as Zone;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}