package objects
{
	import Extensions.ParticleSystem.PDParticleSystem;
	
	import core.Assets;
	
	public class Explosion extends PDParticleSystem
	{
		public function Explosion()
		{
			super(XML(new Assets.explosionXML()), Assets.ta.getTexture("explosion"));
		}
	}
}