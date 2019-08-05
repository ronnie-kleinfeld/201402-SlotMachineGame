package
{
	import com.adobe.images.PNGEncoder;
	import com.gotchaslots.slots.data.machine.paylines.payline.base.BasePaylineData;
	import com.gotchaslots.slots.data.machine.paylines.paylines.Paylines3x3Data;
	import com.gotchaslots.slots.data.machine.paylines.paylines.Paylines5x3Data;
	import com.gotchaslots.slots.data.machine.paylines.paylines.Paylines5x4Data;
	import com.gotchaslots.slots.data.machine.paylines.paylines.Paylines5x5Data;
	import com.gotchaslots.slots.data.machine.paylines.paylines.base.BasePaylinesData;
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	
	import flash.display.BitmapData;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class PaylinesGenerator extends SpriteEx
	{
		public function PaylinesGenerator()
		{
			super();
			
			trace("START");
			CreatesLine(new Paylines3x3Data(27), "Paylines3x3");
			CreatesLine(new Paylines5x3Data(100), "Paylines5x3");
			CreatesLine(new Paylines5x4Data(100), "Paylines5x4");
			CreatesLine(new Paylines5x5Data(100), "Paylines5x5");
			trace("END");
		}
		private function CreatesLine(paylines:BasePaylinesData, path:String):void
		{
			trace(path);
			for (var i:int = 0; i < paylines.Paylines.length; i++)
			{
				trace(path + " " + i.toString() + "/" + paylines.Paylines.length);
				CreateLine(paylines.Paylines[i], path);
			}
		}
		private function CreateLine(payline:BasePaylineData, path:String):void
		{
			var sprite:SpriteEx = new SpriteEx();
			
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(5, payline.Color, 0.8, false, "normal", null, JointStyle.ROUND);
			shape.graphics.moveTo(payline.Payboxes[0].LeftCenter.x, payline.Payboxes[0].LeftCenter.y);
			shape.graphics.lineTo(payline.Payboxes[0].Center.x, payline.Payboxes[0].Center.y);
			for (var i:int = 1; i <= payline.Payboxes.length; i++)
			{
				shape.graphics.lineTo(payline.Payboxes[i].Center.x, payline.Payboxes[i].Center.y);
			}
			shape.graphics.lineTo(payline.Payboxes[payline.Payboxes.length - 1].RightCenter.x, payline.Payboxes[payline.Payboxes.length - 1].RightCenter.y);
			sprite.addChild(shape);
			
			var bitmapData:BitmapData = new BitmapData(800, 306, true, 0x000000);
			bitmapData.draw(sprite);
			
			var byteArray:ByteArray = PNGEncoder.encode(bitmapData);
			
			var str:String = payline.ID < 10 ? "0" + payline.ID.toString() : payline.ID.toString();
			
			var file:File = File.documentsDirectory;
			trace(file.nativePath);
			file = file.resolvePath("GotchaSlots/com.xpdevwiz.slots.assets.paylines." + path.toLowerCase() + "/src/assets/paylines/" + path.toLowerCase() + "/Line_0" + str + ".png");
			var writeStream:FileStream = new FileStream();
			writeStream.open(file, FileMode.WRITE);
			writeStream.writeBytes(byteArray);
			writeStream.close();
		}
	}
}