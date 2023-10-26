
/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2011
 * http://flintparticles.org/
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package
{
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.BitmapRenderer;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	[SWF(width='300', height='400', frameRate='60', backgroundColor='#000000')]
	
	/**
	 * This example creates fire and smoke using two emitters.
	 * 
	 * <p>This is the document class for the Flex project.</p>
	 */

	public class Main extends Sprite
	{
		private var smoke:Emitter2D;
		private var fire:Emitter2D;
		
		public function Main()
		{
			smoke = new Smoke();
			smoke.x = 150;
			smoke.y = 380;
			smoke.start();
			
			fire = new Fire();
			fire.x = 150;
			fire.y = 380;
			fire.start();
			
			var renderer:BitmapRenderer = new BitmapRenderer( new Rectangle( 0, 0, 300, 400 ) );
			renderer.addEmitter( smoke );
			renderer.addEmitter( fire );
			addChild( renderer );
		}
	}
}