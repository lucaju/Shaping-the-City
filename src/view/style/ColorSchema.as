package view.style {
	
	public class ColorSchema {
		
		//status
		static private var active:uint = 0xBBBBBB;
		static private var selected:uint = 0x333333;
		static private var inactive:uint = 0xCCCCCC;
		
		//schema
		static private var filter1:uint = 0x56AF17;
		static private var filter2:uint = 0x843B9F;
		static private var filter3:uint = 0x0092D0;
		
		//color
		static private var gray:uint = 0x666666;
		static private var white:uint = 0xFFFFFF;
		static private var red:uint = 0xCC092F;
		
		//array
		static private var colors:Object = {
											active:active,
											selected:selected,
											inactive:inactive,
											filter1:filter1,
											filter2:filter2,
											filter3:filter3,
											gray:gray,
											red:red,
											white:white};
		
		
		public function ColorSchema() {
			
		}
		
		static public function getColor(value:String = null):uint {
			
			var color:uint = colors[value]
			
			return color;
			
		}
	}
}