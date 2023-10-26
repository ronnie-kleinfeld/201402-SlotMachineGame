package
{
    import mochi.as3.*;
    import ui.*;
    
    public class UserData
    {
        private static const MY_KEY:String = 'UserDataKey';
        private static const USERID:String = 'userABC';
        
        public static var myData:Object;
        
        public static function init():void
        {
            myData = { 'value': "Still loading" };
        }
        
        private static function getData(e:* = null):void
        {
            MochiUserData.getData(USERID, MY_KEY, onDataGet );
        }
        
        public static function get menu():Menu
        {
            var menu:Array = [ 
                new MenuItem( UserData.getData, 'Get UserData' ),
                itemSetData('A'),
                itemSetData('B'),
                itemSetData('C'),
                new MenuItem( Core.returnToMain, 'Return to Main Menu' )                
             ];

            return new Menu( "User Data API Demonstration: " + JSON.stringify(myData) , menu );
        }
        
        public static function itemSetData( item:String ):MenuItem
        {
            return new MenuItem( function(e:* = null):void {
                myData = { string: item };
                Core.MainMenu.menu = menu;
                
                MochiUserData.putData( USERID, MY_KEY, myData, onDataSet );
            }, 'Set data to: ' + item.toUpperCase() );
        }

        private static function onDataGet(userData:MochiUserData):void
        {
            if (userData.isError) {
                trace("[ERROR] could not get UserData:" + userData.errorCode);
                return;
            }
            myData = userData.data;
            Core.MainMenu.menu = menu;
            trace("Succussfully get UserData");
        }

        private static function onDataSet( userData:MochiUserData = null ):void
        {
            if (userData.isError) {
                trace("[ERROR] could not put UserData:" + userData.errorCode);
                return;
            }
            Core.popup("Data was sent to the server");
            trace("Succesfully update UserData");
        }
    }
}
