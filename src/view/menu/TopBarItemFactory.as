package view.menu {
	
	import flash.display.Sprite;
	
	import util.DeviceInfo;
	
	public class TopBarItemFactory extends Sprite {
		
		public function TopBarItemFactory() {
		
		}
			
		static public function addTopBarItem(title:String):TopBarItem {	
			
			var item:TopBarItem = new TopBarItem();
			
			var titleLower:String = title.toLowerCase();
			var file:String;
			
			if (DeviceInfo.os() == "iPhone") {
				file = "/images/icons/" + titleLower + "_40.png";
				item.titleSize = 22;
				item.setSize(76)
			} else {
				file = "/images/icons/" + titleLower + "_20.png";
				item.titleSize = 11;
				item.setSize(38)
			}
			
			
			item.init(title, file);
			
			titleLower = null;
			file = null;
			
			return item;
		}
	}
}