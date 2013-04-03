package view.menu.submenu {
	
	import flash.display.Sprite;
	
	import util.DeviceInfo;
	
	public class SubMenuItemFactory extends Sprite {
		
		public function SubMenuItemFactory() {
		
		}
			
		/**
		 * addSubMenuItem. Static function to add submenus items. It creates the appropriate submenu item according to the OS.  
		 * @param type:String
		 * @param hMax:Maximum Height
		 * @return: SubMenuItem
		 * 
		 */
		static public function addSubMenuItem(type:String, wMax:Number = 100):SubMenuItem {	
			
			var item:SubMenuItem = new SubMenuItem(type,wMax);
			
			if (DeviceInfo.os() == "iPhone") {
				item.titleSize = 32;
				item.marginH = 40;
				item.marginV = 16;
			} else {
				item.titleSize = 16;
				item.marginH = 20;
				item.marginV = 8;
			}
			
			return item;
		}
	}
}