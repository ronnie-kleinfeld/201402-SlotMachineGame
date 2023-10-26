package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.external.ExtensionContext;
	
	import pl.mllr.extensions.contactEditor.ContactEditor;
	
	public class ContactsFetcher extends Sprite
	{
		public function ContactsFetcher()
		{
			super();
			
			// support autoOrients
; 			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var ce:ContactEditor = new ContactEditor();
			trace("getContactCount:", ce.getContactCount());
			
			var ar:Array = ce.getContactsSimple();
			
			for (var i:int = 0; i < ar.length; i++)
			{
				try
				{
					var contact:Object = ce.getContactDetails(ar[i].recordId);
					if (contact)
					{
						for (var j:int = 0; j < contact.emails.length; j++)
						{
							trace(i, " ", contact.compositename, " ", contact.emails[j], " ", contact.account_name);
						}
					}
					else
					{
						trace(i, " null contact");
					}
				}
				catch (error:Error)
				{
					trace(i, " error ", error.message);
				}
			}
		}
	}
}