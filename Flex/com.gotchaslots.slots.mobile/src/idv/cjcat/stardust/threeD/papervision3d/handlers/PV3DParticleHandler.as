package idv.cjcat.stardust.threeD.papervision3d.handlers {
	import idv.cjcat.stardust.common.handlers.ParticleHandler;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.threeD.particles.Particle3D;
	import org.papervision3d.core.geom.Particles;
	import org.papervision3d.core.geom.renderables.Particle;
	
	/**
	 * This handler adds <code>particle</code> object to a <code>Particles</code> object, 
	 * removes dead particles from the <code>Particles</code> object, 
	 * and updates the <code>Particle</code> objects' x, y, z, rotationZ, and size properties.
	 * 
	 * @see org.papervision3d.core.geom.Particles
	 * @see org.papervision3d.core.geom.renderables.Particle
	 */
	public class PV3DParticleHandler extends ParticleHandler {
		
		private var particleContainer:Particles;
		
		public function PV3DParticleHandler(particleContainer:Particles = null) {
			this.particleContainer = particleContainer;
		}
		
		private var p:org.papervision3d.core.geom.renderables.Particle;
		private var container:Particles;
		
		public override function particleAdded(particle:idv.cjcat.stardust.common.particles.Particle):void {
			p = org.papervision3d.core.geom.renderables.Particle(particle.target);
			particleContainer.addParticle(p);
			particle.dictionary[PV3DParticleHandler] = particleContainer;
		}
		
		public override function particleRemoved(particle:idv.cjcat.stardust.common.particles.Particle):void {
			p = org.papervision3d.core.geom.renderables.Particle(particle.target);
			container = Particles(particle.dictionary[PV3DParticleHandler]);
			container.removeParticle(p);
		}
		
		private var p3D:Particle3D;
		
		public override function readParticle(particle:idv.cjcat.stardust.common.particles.Particle):void {
			p3D = Particle3D(particle);
			
			p = org.papervision3d.core.geom.renderables.Particle(particle.target);
			
			p.x = p3D.x;
			p.y = p3D.y;
			p.z = p3D.z;
			p.rotationZ = p3D.rotationZ;
			p.size = particle.scale;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		public override function getXMLTagName():String {
			return "PV3DParticleHandler";
		}
		
		//------------------------------------------------------------------------------------------------$
		//end of XML
	}
}