package com.gotchaslots.common.utils.animation
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class AnimationSprite extends Bitmap 
	{
		// consts
		public static const LEFT:uint = 1;
		public static const RIGHT:uint = 2;
		
		// members
		protected var _spriteSheetJson:SpriteSheetJson;
		protected var _sequences:Array;
		protected var _animationSequenceData:AnimationSequenceData;
		protected var _isDirty:Boolean;
		protected var donePlaying:Boolean;
		protected var _index:uint;  // Frame index into tile sheet 
		protected var curFrame:uint;  // Frame index in a sequence (local)
		private var _frameTimer:Number;
		
		// properties
		public function get GetSpriteSheetJson():SpriteSheetJson
		{
			return _spriteSheetJson;
		}
		public function get numFrames():int
		{
			return _spriteSheetJson.Length;
		}
		public function get numSequences():int
		{
			return _sequences.length;
		}
		public function get seqFrame():uint
		{
			return curFrame;
		}
		public function get Index():uint
		{
			return _index;
		}
		public function set Index(value:uint):void
		{
			if (_animationSequenceData)
			{
				_index = _animationSequenceData._frames[value];
			}
			else
			{
				_index = value;
			}
			
			_isDirty = true;
		}
		
		// class
		public function AnimationSprite(bitmapData:BitmapData = null)
		{
			super(bitmapData);
			
			_frameTimer = 0;
			_sequences = [];
		}
		public function Init(spriteSheetJson:SpriteSheetJson):void
		{
			if (spriteSheetJson)
			{
				_spriteSheetJson = spriteSheetJson;
				
				// Create the frame buffer
				bitmapData = new BitmapData(_spriteSheetJson.MaxRectangle.width, _spriteSheetJson.MaxRectangle.height); 
				smoothing = true;
				
				_animationSequenceData = null;
				this.Index = 0;
				
				drawFrame(true);
			}
		}
		
		// methods
		public function isPlaying(index:int=0):Boolean
		{
			return !donePlaying;
		}
		public function getSequenceData(seq:int):AnimationSequenceData
		{
			return _sequences[seq];
		}
		public function getSequence(seq:int):String
		{
			return _sequences[seq].seqName;
		}
		public function addSequence(name:String, frames:Array, frameRate:Number=0, looped:Boolean=true):void
		{
			_sequences.push(new AnimationSequenceData(name, frames, looped, frameRate));
		}
		public function findSequence(name:String):AnimationSequenceData
		{
			return findSequenceByName(name);
		}
		private function findSequenceByName(name:String):AnimationSequenceData
		{
			var aSeq:AnimationSequenceData;
			for (var i:int = 0; i < _sequences.length; i++)
			{
				aSeq = AnimationSequenceData(_sequences[i]);
				if (aSeq._key == name)
				{
					return aSeq;
				}
			}
			return null;
		}
		public function play(name:String=null):void
		{
			// Continue playing from last frame
			if (name == null)
			{
				donePlaying= false;
				_isDirty= true;
				_frameTimer = 0;
				
				return;
			}
			
			curFrame = 0;
			_index = 0;
			_frameTimer = 0;
			
			_animationSequenceData= findSequenceByName(name);
			if (!_animationSequenceData)
			{
				return;
			}
			
			// Set to first frame
			_index = _animationSequenceData._frames[0];
			donePlaying = false;
			_isDirty = true;
			
			// Stop if we only have a single frame
			if (_animationSequenceData._frames.length == 1)
			{
				donePlaying = true;
			}
		}
		
		
		// External use only (editor) 
		//
		public function stop():void
		{
			donePlaying= true;
		}
		
		// Manually advance one frame forwards or back
		// Used by the viewer (not the game)
		//
		public function frameAdvance(next:Boolean):void
		{
			if (next)
			{
				if (curFrame < _animationSequenceData._frames.length -1) ++curFrame;
			}
			else
			{
				if (curFrame > 0) --curFrame;
			}
			
			_index = _animationSequenceData._frames[curFrame];
			_isDirty = true;
		}
		
		
		public function drawFrame(force:Boolean=false):void
		{
			if (force || _isDirty)
			{
				drawFrameInternal();
			}
		}
		
		// TODO: Replace with global time based on getTimer()
		private var fakeElapsed:Number= 0.016;
		
		//  Call this function On every frame update
		//  
		public function updateAnimation():void
		{
			if (_animationSequenceData!=null && _animationSequenceData._delay > 0 && !donePlaying)
			{
				// Check elapsed time and adjust to sequence rate 
				_frameTimer += fakeElapsed;
				while(_frameTimer > _animationSequenceData._delay)
				{
					_frameTimer = _frameTimer - _animationSequenceData._delay;
					advanceFrame();
				}
			}
			
			if (_isDirty)
			{
				drawFrameInternal();
			}
		}
		
		protected function advanceFrame():void
		{
			if (curFrame == _animationSequenceData._frames.length -1)
			{
				if (_animationSequenceData._loop)
				{
					curFrame = 0;
				}
				else
				{
					donePlaying = true;
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			else
			{
				++curFrame;
			}
			
			_index= _animationSequenceData._frames[curFrame];
			_isDirty= true;
		}
		
		// Internal function to update the current animation frame
		protected function drawFrameInternal():void
		{
			_isDirty = false;
			
			bitmapData.fillRect(bitmapData.rect, 0);
			_spriteSheetJson.DrawBitmap(_index, bitmapData);
		}
	}
}