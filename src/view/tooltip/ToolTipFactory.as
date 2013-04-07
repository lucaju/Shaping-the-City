package view.tooltip {
	
	//imports
	import util.DeviceInfo;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ToolTipFactory {
		
		/**
		 * ToolTip. Static function to add tooltips. It creates the appropriate tooltip according to the OS and the orientation chose. 
		 * 
		 */
		static public function addToolTip():ToolTip {	
			
			var toolTip:ToolTip = new ToolTip();
			
			switch (DeviceInfo.os()) {
				
				case "iPhone":
					toolTip.fontSize = 24;
					break;
				
				default:
					toolTip.fontSize = 12;
					break;
				
			}
			
			return toolTip;
		}
	}
}