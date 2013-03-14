package view.style {
	
	//imports
	import flash.text.TextFormat;

	public class TXTFormat {
		
		public function TXTFormat() {
			
		}
		
		static public function getStyle(styleName:String = "standard", statusColor:String = "standard"):TextFormat {
			
			var style:TextFormat = new TextFormat();
			style.font = "Myriad Pro";
			style.color = ColorSchema.getColor(statusColor);
			style.leading = 2;
			
			switch (styleName) {
				
				case "Main Title":
					style.size = 21;
					style.bold = true;
					style.color = 0xCCCCCC;
					break;
				
				case "Top Bar Item Title":
					style.size = 11;
					style.color = 0xCCCCCC;
					break;
				
				case "credits":
					style.size = 10;
					style.color = 0x999999;
					break;
				
				
				default:
					style.size = 12;
					break;
				
			}
		
			return style;
		}
		 
	}
}