package view.menu.submenu {
	
	//imports
	import mvc.IController;
	
	import util.DeviceInfo;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class SubMenuFactory {
		
		/**
		 * Submenu. Static function to add submenus. It creates the appropriate submenu according to the OS and the orientation chose. 
		 * 
		 * @param c:IController
		 * @param type:String
		 * @param orientation:String
		 * @return:SubMenu
		 * 
		 */
		static public function subMenu(c:IController, type:String, orientation:String = "horizontal"):SubMenu {	
			
			var subMenu:SubMenu = new SubMenu(c,type);
			
			subMenu.orientation = orientation;
			
			if (orientation == "horizontal") {
				
				switch (DeviceInfo.os()) {
					
					case "iPhone":
						subMenu.rangeSize = 1;	//80
						break;
					
					default:
						subMenu.rangeSize = 1; //40
						break;
					
				}
				
			} else if (orientation == "vertical") {
				
				switch (DeviceInfo.os()) {
					
					case "iPhone":
						subMenu.rangeSize = 328;
						break;
					
					default:
						subMenu.rangeSize = 164;
						break;
					
				}
				
			}
			
			return subMenu;
		}
	}
}