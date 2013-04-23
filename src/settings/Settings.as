package settings {
	
	/**
	 * Settings.
	 * This class holds configuration settings of this app.
	 * 
	 * @author lucaju
	 * 
	 */
	public class Settings {
		
		//****************** Properties ****************** ****************** ******************
		private static const HORIZONTAL					:String = "horizontal";		//Orientation Horizontal
		private static const VERTICAL					:String = "vertical";		//Orientation Vertical
		
		private static var _server						:String;					//["local","remote"]
		private static var _platformTarget				:String;					//["air","mobile","web"]
		private static var _debug						:Boolean;					//Debug
		private static var _projectPhase				:String;					//Project Phase [Neighbourhoods and Shapes database]	
		
		private static var _subMenuOrientation			:String;					//Holds orientation info
		private static var _useSubMenuItemSeparator		:Boolean;					//Holds orientation info
		private static var _subMenuHorizontalRows		:uint;						//Holds Summenu Number of rows in horizontal orientation
		private static var _footerMenuButton			:String;					//Holds Footer button type: button || switcher
		
		private static var _showZoomControls			:Boolean
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * Constructor. Set default values 
		 * 
		 */
		public function Settings() {
			
			//default values
			_server = "remote";
			_platformTarget = "air";
			_debug = false;
			_projectPhase = "1";
			
			_subMenuOrientation = VERTICAL;
			_useSubMenuItemSeparator = true;
			_subMenuHorizontalRows = 3;
			_footerMenuButton = "button";
			
			_showZoomControls = false;
			
		}
		
		
		//****************** GETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get server():String {
			return _server;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get platformTarget():String {
			return _platformTarget;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get debug():Boolean {
			return _debug;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get projectPhase():String {
			return _projectPhase;
		}
		
		/**
		 *  Submenu Orientation. Return the current Orientation. Values: VERTICAL or HORIZONTAL
		 * @return:String
		 * 
		 */
		public static function get subMenuOrientation():String {
			return _subMenuOrientation
		}
		
		/**
		 * Use SubMenu Item Separator. Return the current use of separator.;
		 * @return: Boolean
		 * 
		 */
		public static function get useSubMenuItemSeparator():Boolean {
			return _useSubMenuItemSeparator
		}
		
		/**
		 * Return the current Number of SubMenu Horizontal Rows. 
		 * @return:uint
		 * 
		 */
		public static function get subMenuHorizontalRows():uint {
			return _subMenuHorizontalRows
		}
		
		/**
		 * Footer Menu Button. Return the current option Values: 1.Switcher or 2.Button
		 * @return:String
		 * 
		 */
		public static function get footerMenuButton():String {
			return _footerMenuButton
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get showZoomControls():Boolean {
			return _showZoomControls;
		}
		
		
		//****************** SETTER ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set server(value:String):void {
			if (value != "remote" && value != "local") {
				_server = "remote";
			} else {
				_server = value;
			}
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set platformTarget(value:String):void {
			if (value != "air" && value != "mobile" && value != "web") {
				_platformTarget = "air";
			} else {
				_platformTarget = value;
			}
		}
		
		public static function set debug(value:Boolean):void {
			_debug = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set projectPhase(value:String):void {
			_projectPhase = value;
		}
		
		/**
		 *  Submenu Orientation. You can choose between VERTICAL or HORIZONTAL
		 * @return:String
		 * 
		 */
		public static function set subMenuOrientation(value:String):void {
			_subMenuOrientation = value;
		}
		
		/**
		 * Use SubMenu Item Separator. Either true or false;
		 * @return: Boolean
		 * 
		 */
		public static function set useSubMenuItemSeparator(value:Boolean):void {
			_useSubMenuItemSeparator = value;
		}
		
		/**
		 * Number of SubMenu Horizontal Rows
		 * @return:uint
		 * 
		 */
		public static function set subMenuHorizontalRows(value:uint):void {
			_subMenuHorizontalRows = value;
		}
		
		/**
		 *  Footer Menu Button. You can choose between 1.Switcher or 2.Button
		 * @return:String
		 * 
		 */
		public static function set footerMenuButton(value:String):void {
			_footerMenuButton = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set showZoomControls(value:Boolean):void {
			_showZoomControls = value;
		}
		
	}
}