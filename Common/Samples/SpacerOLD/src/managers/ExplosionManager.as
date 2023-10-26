package managers
{
	import com.leebrimelow.starling.StarlingPool;
	
	import objects.Explosion;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	import states.Play;

	public class ExplosionManager
	{
		private var play:Play;
		private var pool:StarlingPool;
		
		public function ExplosionManager(play:Play)
		{
			this.play = play;
			pool = new StarlingPool(Explosion, 15);
		}
		
		public function spawn(x:int, y:int):void
		{
			var ex:Explosion = pool.getSprite() as Explosion;
			ex.emitterX = x;
			ex.emitterY = y;
			ex.start(0.1);
			play.addChild(ex);
			Starling.juggler.add(ex);
			ex.addEventListener(Event.COMPLETE, onComplete);
		}
		
		private function onComplete(event:Event):void
		{
			var ex:Explosion = event.currentTarget as Explosion;
			Starling.juggler.remove(ex);
			
			if(pool != null)
				pool.returnSprite(ex);
		}
		
		public function destroy():void
		{
			for(var i:int=0; i<pool.items.length; i++)
			{
				var ex:Explosion = pool.items[i];
				ex.dispose();
				ex = null;
			}
			pool.destroy();
			pool = null;
		}
	}
}