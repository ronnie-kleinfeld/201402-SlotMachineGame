package idv.cjcat.stardust.common.particles {
	
	/** @private */
	public class PooledParticleList extends ParticleList {
		
		public function PooledParticleList() {
			
		}
		
		protected override final function createNode(particle:Particle):ParticleNode {
			return ParticleNodePool.get(particle);
		}
	}
}