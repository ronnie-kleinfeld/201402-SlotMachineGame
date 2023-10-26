package com.gotchaslots.common.ui.common.components.freeActionScript.pngTrails
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.spline.SplineData;
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class PngTrails extends SpriteEx
	{
		// members
		private var _bitmapClass:Class;
		private var _spline:SplineData;
		private var _index:Number;
		
		private var _particles:Array;
		private var _maxSpeed:Number = 1;
		private var _fadeSpeed:Number = .025;
		private var _count:Number = 2;
		private var _range:Number = 5;
		
		// class
		public function PngTrails(bitmapClass:Class, point0:Point, point1:Point, point2:Point)
		{
			super();
			
			_bitmapClass = bitmapClass;
			_spline = Main.Instance.Application.Splines.GetSpline(point0, point1, point2);
			_index = 0;
			
			_particles = new Array();
			
			addEventListener(Event.ENTER_FRAME, OnEnterFrame);
		}
		public override function Dispose():void
		{
			removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
			
			while (numChildren > 0)
			{
				var o:Object = removeChildAt(0);
				if (o is MovieClip)
				{
					var movieClip:MovieClip = MovieClip(o);
					while (movieClip.numChildren > 0)
					{
						movieClip.removeChildAt(0);
					}
					movieClip = null;
				}
			}
			
			if (_particles)
			{
				while (_particles.length > 0)
				{
					_particles.pop();
				}
				_particles = null;
			}
			
			super.Dispose();
		}
		
		// methods
		private function CreateParticle(targetX:Number, targetY:Number):void
		{
			for (var i:Number = 0; i < _count; i++) 
			{
				var movieClip:MovieClip = new MovieClip();
				movieClip.addChild(new _bitmapClass());
				
				movieClip.x = targetX
				movieClip.y = targetY
				movieClip.rotation = Math.random() * 360;
				movieClip.alpha = Math.random() * .5 + .5;
				
				movieClip.boundyLeft = targetX - _range;
				movieClip.boundyTop = targetY - _range;
				movieClip.boundyRight = targetX + _range;
				movieClip.boundyBottom = targetY + _range;
				
				movieClip.speedX = Math.random() * _maxSpeed - Math.random() * _maxSpeed;
				movieClip.speedY = Math.random() * _maxSpeed + Math.random() * _maxSpeed;
				movieClip.speedX *= _maxSpeed
				movieClip.speedY *= _maxSpeed
				
				movieClip.fadeSpeed = Math.random() * _fadeSpeed;
				
				_particles.push(movieClip);
				
				addChild(movieClip);
			}
		}
		private function UpdateParticle():void
		{
			for (var i:int = 0; i < _particles.length; i++)
			{
				var movieClip:MovieClip = _particles[i];
				
				movieClip.alpha -= movieClip.fadeSpeed;
				movieClip.x += movieClip.speedX;
				movieClip.y += movieClip.speedY;
				
				if (movieClip.alpha <= 0)
				{
					DestroyParticle(movieClip);
				}
				else if (movieClip.x < movieClip.boundyLeft || 
					movieClip.x > movieClip.boundyRight || 
					movieClip.y < movieClip.boundyTop || 
					movieClip.y > movieClip.boundyBottom)
				{
					movieClip.fadeSpeed += .05;
				}
			}
		}
		private function DestroyParticle(particle:MovieClip):void
		{
			for (var i:int = 0; i < _particles.length; i++)
			{
				var movieClip:MovieClip = _particles[i];
				if (movieClip == particle)
				{
					_particles.splice(i,1);
					removeChild(movieClip);
				}
			}
		}
		
		// events
		private function OnEnterFrame(event:Event):void
		{
			_index = _index + 0.5;
			if (_index < _spline.Points.length)
			{
				CreateParticle(_spline.Points[int(_index)].x, _spline.Points[int(_index)].y);
			}
			
			UpdateParticle();
		}
	}
}