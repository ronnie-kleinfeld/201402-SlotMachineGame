/*
put in main

var size:int = 320;
var icon:Icon = new Icon();
icon.scaleX = icon.scaleY = size / icon.width;
icon.x = icon.y = int(15 * size / 128 / 2);
addChild(icon);

var sprite:Sprite = new Sprite();
sprite.addChild(icon);

var bitmapData:BitmapData = new BitmapData(size, size, true, 0xffffff);
bitmapData.draw(sprite);

var byteArray:ByteArray = PNG24Encoder.encode(bitmapData);

var file:File = File.documentsDirectory;
file = file.resolvePath("Icon" + size.toString() + "x" + size.toString() + ".png");
var writeStream:FileStream = new FileStream();
writeStream.open(file, FileMode.WRITE);
writeStream.writeBytes(byteArray);
writeStream.close();

*/
package com.gotchaslots.common.ui.external
{
	import com.gotchaslots.common.ui.common.components.base.BasePng;
	import com.gotchaslots.common.ui.common.components.gradientBG.RadialGradientBG;
	
	import flash.display.Bitmap;
	
	public class Icon extends BasePng
	{
		private const SIZE:Number = 512;
		
		// properties
		protected override function get HasFrame():Boolean
		{
			return true;
		}
		protected override function get FrameColorHigh():Number
		{
			return 0x7c306f;
		}
		protected override function get FrameColorLow():Number
		{
			return 0x8330ba;
		}
		protected override function get FrameThickness():Number
		{
			return 15 * SIZE / 128;
		}
		protected override function get FrameCorner():Number
		{
			return 20 * SIZE / 128;
		}
		protected override function get FrameFilters():Array
		{
			return null;
		}
		
		protected override function get PngFilters():Array
		{
			return null;
		}
		
		// class
		public function Icon()
		{
			super(SIZE, SIZE);
			
			addChild(new RadialGradientBG(W, H, 20 * SIZE / 128, 0xe7c0f7, 0xbf5deb));//0x8e3fbf));
			
			var bitmap:Bitmap = new com.gotchaslots.slots.assets.xServices.ExternalEmbed();
			bitmap.width = bitmap.height = W * 0.95;
			bitmap.x = bitmap.y = (W - bitmap.width) / 2;
			bitmap.smoothing = true;
			addChild(bitmap);
		}
	}
}