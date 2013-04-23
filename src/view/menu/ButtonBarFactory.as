package view.menu {
	
	//imports
	import util.DeviceInfo;
	
	/**
	 * Button Bar Factory.
	 * Fabricates Button Bars according to the speciications.
	 * Location:
	 * 	- Topbar
	 * 	- Footer
	 * OS:
	 * 	- iPhone (iPad Retina Display)
	 *  - Mac OS
	 *  
	 * @author lucaju
	 * 
	 */
	public class ButtonBarFactory {
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ****************** 
		
		/**
		 * Add Button Bar
		 * Return a built Button Bars according to the speciications.
		 * Location:
		 * 	- Topbar
		 * 	- Footer
		 * OS:
		 * 	- iPhone (iPad Retina Display)
		 *  - Mac OS
		 * 
		 * @param title:String
		 * @param location:String
		 * @return ButtonBar
		 * 
		 */
		static public function addButtonBar(title:String, location:String = "topBar"):ButtonBar {	
			
			//create new Button Bar
			var item:ButtonBar = new ButtonBar();
			var titleLower:String = title.toLowerCase();
			
			//Switch Location
			switch (location) {
				
				case "topBar":
					buildTopBarButton(item,titleLower);
					break;
				
				case "footer":
					buildFooterBarButton(item,titleLower);
					break;
				
			}
	
			//initiate
			item.init(title);
			
			titleLower = null;
			
			return item;
		}
		
		
		//****************** STATIC PRIVATE METHODS ****************** ****************** ****************** 
		
		/**
		 * Built Top Bar Button.
		 * Define atrtibutes according to the OS
		 *  
		 * @param item:ButtonBar
		 * @param titleLower:String
		 * 
		 */
		private static function buildTopBarButton(item:ButtonBar, titleLower:String):void {
			if (DeviceInfo.os() == "iPhone") {
				item.bgFile = "images/top_bar_bg@2x.png";
				item.iconFile = getIconFileForIphone(titleLower);
				item.titleSize = 22;
				item.setSize(80,160)
			} else {
				item.bgFile = "images/top_bar_bg.png";
				item.iconFile = getIconFileForMac(titleLower);
				item.titleSize = 11;
				item.setSize(40,80)
			}	
		}
		
		/**
		 * Built Footer Button.
		 * Define atrtibutes according to the OS
		 *  
		 * @param item:ButtonBar
		 * @param titleLower:String
		 * 
		 */
		private static function buildFooterBarButton(item:ButtonBar, titleLower:String):void {
			if (DeviceInfo.os() == "iPhone") {
				item.bgFile = "images/top_bar_bg@2x.png";
				item.iconFile = getIconFileForIphone(titleLower);
				item.titleSize = 28;
				item.setSize(80,160)
			} else {
				item.bgFile = "images/top_bar_bg.png";
				item.iconFile = getIconFileForMac(titleLower);
				item.titleSize = 14;
				item.setSize(40,80)
			}
		}		
		
		/**
		 * Get Icon File for Mac
		 *  
		 * @param titleLower:Strinf
		 * @return String
		 * 
		 */
		static private function getIconFileForMac(titleLower:String):String {
			
			var file:String;
			
			switch(titleLower) {
				
				case "community":
					file = "images/icons/" + titleLower + "_20.png";
					break;
				
				case "period":
					file = "images/icons/" + titleLower + "_20.png";
					break;
				
				case "explode":
					file = "";
					break;
				
				case "animation":
					file = "";
					break;
				
			}
			
			return file;
		}
		
		/**
		 * Get Icon File for iPhone (iPad retina Display)
		 *  
		 * @param titleLower:Strinf
		 * @return String
		 * 
		 */
		static private function getIconFileForIphone(titleLower:String):String {
			
			var file:String;
			
			switch(titleLower) {
				
				case "community":
					file = "/images/icons/" + titleLower + "_40.png";
					break;
				
				case "period":
					file = "/images/icons/" + titleLower + "_40.png";
					break;
				
				case "explode":
					file = "";
					break;
				
				case "animation":
					file = "";
					break;
				
			}
			
			return "";
		}
	}
}