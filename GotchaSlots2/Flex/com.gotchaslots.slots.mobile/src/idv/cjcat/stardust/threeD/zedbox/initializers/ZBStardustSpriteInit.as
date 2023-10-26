﻿package idv.cjcat.stardust.threeD.zedbox.initializers  {
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.threeD.initializers.Initializer3D;
	import idv.cjcat.stardust.twoD.display.IStardustSprite;
	
	public class ZBStardustSpriteInit extends Initializer3D {
		
		public function ZBStardustSpriteInit() {
			
		}
		
		public override final function initialize(particle:Particle):void {
			var target:IStardustSprite = particle.dictionary[ZBDisplayObjectClass] as IStardustSprite;
			if (target) target.init(particle);
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		public override function getXMLTagName():String {
			return "ZBStardustSpriteInit";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}