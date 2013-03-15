package view.menu {
	
	import flash.display.Sprite;
	
	import util.DeviceInfo;
	
	public class SubMenuItemFactory extends Sprite {
		
		public function SubMenuItemFactory() {
		
		}
			
		static public function addSubMenuItem(type:String, hMax:Number = 20):SubMenuItem {	
			
			var item:SubMenuItem = new SubMenuItem(type,hMax);
			
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