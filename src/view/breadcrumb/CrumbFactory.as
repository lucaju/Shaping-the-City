package view.breadcrumb {
	
	import flash.display.Sprite;
	
	import util.DeviceInfo;
	
	public class CrumbFactory extends Sprite {
		
		public function CrumbFactory() {
		
		}
			
		/**
		 * addSubMenuItem. Static function to add submenus items. It creates the appropriate submenu item according to the OS.  
		 * @param type:String
		 * @param hMax:Maximum Height
		 * @return: SubMenuItem
		 * 
		 */
		static public function addCrumb(title:String):Crumb {	
			
			var item:Crumb = new Crumb();
			
			item.titleSize = 11;
			item.setCrumbHeight(20);
			item.init(title);
			
			if (DeviceInfo.os() == "iPhone") {
				item.scaleX = item.scaleY = 2;
			}
			
			return item;
		}
	}
}