package idv.cjcat.stardust.twoD.actions.triggers  {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.actions.triggers.ActionTrigger2D;
	import idv.cjcat.stardust.twoD.deflectors.Deflector;
	
	/**
	 * <p>
	 * Default priority = -1;
	 * </p>
	 */
	public class DeflectorTrigger extends ActionTrigger2D {
		
		public var deflector:Deflector;
		
		public function DeflectorTrigger(deflector:Deflector = null) {
			priority = -6;
			
			this.deflector = deflector;
		}
		
		public override function testTrigger(emitter:Emitter, particle:Particle, time:Number):Boolean {
			return Boolean(particle.dictionary[deflector]);
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		public override function getRelatedObjects():Array {
			return [deflector];
		}
		
		public override function getXMLTagName():String {
			return "DeflectorTrigger";
		}
		
		public override function toXML():XML {
			var xml:XML = super.toXML();
			
			if (deflector) xml.@deflector = deflector.name;
			
			return xml;
		}
		
		public override function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@deflector.length()) deflector = builder.getElementByName(xml.@deflector) as Deflector;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}