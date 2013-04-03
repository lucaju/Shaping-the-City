package {
	
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
		
		private static var _subMenuOrientation			:String;					//Holds orientation info
		private static var _useSubMenuItemSeparator		:Boolean;					//Holds orientation info
		private static var _subMenuHorizontalRows		:uint;						//Holds Summenu Number of rows in horizontal orientation
		private static var _footerMenuButton			:String;					//Holds Footer button type: button || switcher
		
		/**
		 * Constructor. Set default values 
		 * 
		 */
		public function Settings() {
			
			//default values
			
			_subMenuOrientation = VERTICAL;
			_useSubMenuItemSeparator = true;
			_subMenuHorizontalRows = 3;
			
			_footerMenuButton = "button";
		}
		
		//****************** GETTERS ****************** ****************** ******************
		
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
		
		
		//****************** SETTER ****************** ****************** ******************
		
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
		
	}
}