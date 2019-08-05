package idv.cjcat.stardust.common.initializers {
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	
	/**
	 * Particles are simulated as circles for collision simulation.
	 * 
	 * <p>
	 * This initializer sets the collision radius of a particle.
	 * </p>
	 */
	public class CollisionRadius extends Initializer {
		
		/**
		 * The collsion radius.
		 */
		public var radius:Number;
		public function CollisionRadius(radius:Number = 0) {
			this.radius = radius;
		}
		
		public override final function initialize(particle:Particle):void {
			particle.collisionRadius = radius;
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		public override function getXMLTagName():String {
			return "CollisionRadius";
		}
		
		public override function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@radius = radius;
			
			return xml;
		}
		
		public override function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@radius.length()) radius = parseFloat(xml.@radius);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}