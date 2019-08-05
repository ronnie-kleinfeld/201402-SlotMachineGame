package
{
	import com.adobe.images.PNGEncoder;
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.slots.data.machine.paylines.payline.base.BasePaylineData;
	import com.gotchaslots.slots.data.machine.paylines.paylines.Paylines3x3Data;
	import com.gotchaslots.slots.data.machine.paylines.paylines.Paylines5x1Data;
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
	
	public class PayboxesGenerator extends SpriteEx
	{
		public function PayboxesGenerator()
		{
			super();
			
			trace("START");
			CreatesLine(new Paylines3x3Data(27), "Payboxes3x3");
			CreatesLine(new Paylines5x1Data(1), "Payboxes5x1");
			CreatesLine(new Paylines5x3Data(100), "Payboxes5x3");
			CreatesLine(new Paylines5x4Data(100), "Payboxes5x4");
			CreatesLine(new Paylines5x5Data(100), "Payboxes5x5");
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
			
			var paybox:PayboxData = payline.Payboxes[0];
			
			var shape:Shape = new Shape();
			shape.x = 3;
			shape.y = 3;
			shape.graphics.lineStyle(5, payline.Color, 0.8, false, "normal", null, JointStyle.ROUND);
			shape.graphics.beginFill(0xffffff);
			shape.graphics.drawRect(0, 0, paybox.Rect.width, paybox.Rect.height);
			shape.graphics.endFill();
			sprite.addChild(shape);
			
			var bitmapData:BitmapData = new BitmapData(paybox.Rect.width + 6, paybox.Rect.height + 6, true, 0x000000);
			bitmapData.draw(sprite);
			
			var byteArray:ByteArray = PNGEncoder.encode(bitmapData);
			
			var str:String = payline.ID < 10 ? "0" + payline.ID.toString() : payline.ID.toString();
			
			var file:File = File.documentsDirectory;
			file = file.resolvePath("GotchaSlots/com.xpdevwiz.slots.assets.payboxes." + path.toLowerCase() + "/src/assets/payboxes/" + path.toLowerCase() + "/Paybox_0" + str + ".png");
			var writeStream:FileStream = new FileStream();
			writeStream.open(file, FileMode.WRITE);
			writeStream.writeBytes(byteArray);
			writeStream.close();
		}
	}
}