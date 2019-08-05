﻿package idv.cjcat.stardust.twoD.deflectors {
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.geom.MotionData4D;
	import idv.cjcat.stardust.twoD.geom.MotionData4DPool;
	import idv.cjcat.stardust.twoD.geom.Vec2D;
	import idv.cjcat.stardust.twoD.geom.Vec2DPool;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	/**
	 * Causes particles to be bounded within a circular region.
	 * 
	 * <p>
	 * When a particle hits the walls of the region, it bounces back.
	 * </p>
	 */
	public class BoundingCircle extends Deflector {
		
		/**
		 * The X coordinate of the center of the region.
		 */
		public var x:Number;
		/**
		 * The Y coordinate of the center of the region.
		 */
		public var y:Number;
		/**
		 * The radius of the region.
		 */
		public var radius:Number;
		public function BoundingCircle(x:Number = 0, y:Number = 0, radius:Number = 100) {
			this.bounce = 1;
			this.x = x;
			this.y = y;
			this.radius = radius;
		}
		
		private var cr:Number;
		private var r:Vec2D;
		private var len:Number;
		private var v:Vec2D;
		private var factor:Number;
		protected override function calculateMotionData4D(particle:Particle2D):MotionData4D {
			cr = particle.collisionRadius * particle.scale;
			r = Vec2DPool.get(particle.x - x, particle.y - y);
			len = r.length + cr;
			if (len < radius) {
				Vec2DPool.recycle(r);
				return null;
			}
			
			r.length = radius - cr;
			
			v = Vec2DPool.get(particle.vx, particle.vy);
			v.projectThis(r);
			
			factor = 1 + bounce;
			
			Vec2DPool.recycle(r);
			Vec2DPool.recycle(v);
			
			return MotionData4DPool.get(x + r.x, y + r.y, particle.vx - factor * v.x, particle.vy - factor * v.y);
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		public override function getXMLTagName():String {
			return "BoundingCircle";
		}
		
		public override function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@x = x;
			xml.@y = y;
			xml.@radius = radius;
			
			return xml;
		}
		
		public override function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@x.length()) x = parseFloat(xml.@x);
			if (xml.@y.length()) y = parseFloat(xml.@y);
			if (xml.@radius.length()) radius = parseFloat(xml.@radius);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
	
}