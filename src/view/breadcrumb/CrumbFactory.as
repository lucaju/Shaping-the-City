package view.breadcrumb {
	
	import util.DeviceInfo;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CrumbFactory {
			
		/**
		 * addCrumb. Static function to add Crumbs items. It creates the appropriate crumb item according to the OS.  
		 * Sets scale factor, Crumb heught and font size.
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