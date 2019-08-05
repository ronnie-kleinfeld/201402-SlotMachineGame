﻿package idv.cjcat.stardust.common.clocks {
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	
	/**
	 * Causes the emitter to create particles at a steady rate.
	 */
	public class SteadyClock extends Clock {
		
		/**
		 * How many particles to create in each emitter step.
		 * 
		 * <p>
		 * If less than one, it's the probability of an emitter to create a single particle in each step.
		 * </p>
		 */
		public var ticksPerCall:Number;
		
		public function SteadyClock(ticksPerCall:Number = 0) {
			this.ticksPerCall = ticksPerCall;
		}
		
		public override final function getTicks(time:Number):int {
			return StardustMath.randomFloor(ticksPerCall * time);
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		public override function getXMLTagName():String {
			return "SteadyClock";
		}
		
		public override function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@ticksPerCall = ticksPerCall;
			
			return xml;
		}
		
		public override function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@ticksPerCall.length()) ticksPerCall = parseFloat(xml.@ticksPerCall);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}