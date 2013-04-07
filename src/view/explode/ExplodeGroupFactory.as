package view.explode {
	
	//imports
	import util.DeviceInfo;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ExplodeGroupFactory {
			
		/**
		 * addExplodeGroup. Static function to add explode groups. It creates the appropriate explode group item according to the OS.  
		 * Sets Font size and separator caliber.
		 * 
		 */
		static public function addExplodeGroup():ExplodeGroup {	
			
			var item:ExplodeGroup = new ExplodeGroup();
			
			if (DeviceInfo.os() == "iPhone") {
				item.titleSize = 40;
				item.separatorCaliber = 4;
			} else {
				item.titleSize = 20;
				item.separatorCaliber = 2;
			}
			
			return item;
		}
		
	}
}