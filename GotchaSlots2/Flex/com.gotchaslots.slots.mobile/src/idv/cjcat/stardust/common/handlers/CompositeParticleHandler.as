package idv.cjcat.stardust.common.handlers {
	import idv.cjcat.stardust.common.particles.ParticleCollection;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	
	public class CompositeParticleHandler extends ParticleHandler {
		
		protected var handlers:Array;
		public function CompositeParticleHandler() {
			handlers = [];
		}
		
		public override final function stepBegin(emitter:Emitter, particles:ParticleCollection, time:Number):void {
			for (i = 0, len = handlers.length; i < len; ++i) {
				ParticleHandler(handlers[i]).stepBegin(emitter, particles, time);
			}
		}
		
		public override final function stepEnd(emitter:Emitter, particles:ParticleCollection, time:Number):void {
			for (i = 0, len = handlers.length; i < len; ++i) {
				ParticleHandler(handlers[i]).stepEnd(emitter, particles, time);
			}
		}
		
		private var i:int, len:int;
		
		public override final function particleAdded(particle:Particle):void {
			for (i = 0, len = handlers.length; i < len; ++i) {
				ParticleHandler(handlers[i]).particleAdded(particle);
			}
		}
		
		public override final function particleRemoved(particle:Particle):void {
			for (i = 0, len = handlers.length; i < len; ++i) {
				ParticleHandler(handlers[i]).particleRemoved(particle);
			}
		}
		
		public override final function readParticle(particle:Particle):void {
			for (i = 0, len = handlers.length; i < len; ++i) {
				ParticleHandler(handlers[i]).readParticle(particle);
			}
		}
		
		public function addParticleHandler(particleHandler:ParticleHandler):void {
			if (handlers.indexOf(particleHandler) < 0) handlers.push(particleHandler);
		}
		
		public function removeParticleHandler(particleHandler:ParticleHandler):void {
			var index:int;
			if ((index = handlers.indexOf(particleHandler)) >= 0) {
				handlers.splice(index, 1);
			}
		}
		
		public function clearParticleHandlers():void {
			for (i = 0, len = handlers.length; i < len; ++i) {
				removeParticleHandler(ParticleHandler(handlers[i]));
			}
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		public override function getRelatedObjects():Array {
			return handlers;
		}
		
		public override function getXMLTagName():String {
			return "CompositeParticleHandler";
		}
		
		public override function toXML():XML {
			var xml:XML = super.toXML();
			
			if (handlers.length) {
				xml.appendChild(<handlers/>);
				for (i = 0, len = handlers.length; i < len; ++i) {
					xml.handlers.appendChild(ParticleHandler(handlers[i]).getXMLTag());
				}
			}
			
			return xml;
		}
		
		public override function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			clearParticleHandlers();
			for each (var node:XML in xml.handlers.*) {
				addParticleHandler(ParticleHandler(builder.getElementByName(node.@name)));
			}
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}