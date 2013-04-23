package view.util.zoom {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class ZoomBt extends Sprite {
		
		//****************** Properties ****************** ****************** ****************** 
		
		protected var _label			:String; 
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param type
		 * 
		 */
		public function ZoomBt(type:String) {
			
			_label = type;
			
			//shape
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(1,0x666666,1,true);
			shape.graphics.beginFill(0xCCCCCC,.8);
			if (type == "plus") {
				shape.graphics.drawRoundRectComplex(0,0,20,20,3,3,0,0);
			} else if (type == "minus") {
				shape.graphics.drawRoundRectComplex(0,0,20,20,0,0,3,3);
			}
			
			shape.graphics.endFill();
			this.addChild(shape);
			
			//sign
			var sign:Shape = new Shape();
			sign.graphics.beginFill(0x333333);
			switch (type) {
				case "plus":
					sign.graphics.drawRect(5,9,11,3);
					sign.graphics.drawRect(9,5,3,11);
					sign.graphics.drawRect(9,9,3,3);
					break;
				
				case "minus":
					sign.graphics.drawRect(5,8,10,3);
					break;
					
			}
			
			sign.graphics.endFill();
			this.addChild(sign);
			
			this.buttonMode = true;
			this.mouseChildren = false;
			
		}
		
		
		//****************** GETTERS ****************** ****************** ****************** 

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get label():String {
			return _label;
		}
		
		
		//****************** SETTERS ****************** ****************** ****************** 

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set label(value:String):void {
			_label = value;
		}

	}
}