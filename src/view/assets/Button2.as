package view.assets {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import view.style.TXTFormat;
	
	public class Button2 extends Sprite {
		
		//properties
		private var shape:Shape;
		private var labelTF:TextField;
		
		private var _label:String
		private var _color:uint;
		private var _style:String;
		
		private var txtFormat:TXTFormat;
		
		private var margin:Number = .2; 					//Defined proportionaly in percentage
		
		private var _status:String = "active";
		
		public function Button2(l:String, s:String = "Button Style", c:uint = 0x333333) {
			
			super();
			
			//init
			label = l;
			color = c;
			style = s;
			
			//label
			labelTF = new TextField();
			labelTF.selectable = false;
			labelTF.autoSize = "left";
			labelTF.text = label;
			labelTF.setTextFormat(TXTFormat.getStyle(style, status));
			this.addChild(labelTF);
			
			//shape
			
			var w:Number = labelTF.width + (labelTF.width * margin * 0.2);
			var h:Number = labelTF.height + (labelTF.height * margin * 0.2);
			
			shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawRoundRect(0,0,w,h,10);
			shape.graphics.endFill();
			
			shape.alpha = 0;
			
			this.addChildAt(shape,0);
			
			//align
			labelTF.x = (shape.width/2 - labelTF.width/2) - 1;
			labelTF.y = (shape.height/2 - labelTF.height/2);
			
			//events
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, _over);
			this.addEventListener(MouseEvent.MOUSE_OUT, _out);
			
		}
		
		private function _over(e:MouseEvent):void {
				shape.alpha = .1;
		}
		
		private function _out(e:MouseEvent):void {
				shape.alpha = 0;
		}

		public function get label():String {
			return _label;
		}

		public function set label(value:String):void {
			_label = value;
		}

		public function get color():uint {
			return _color;
		}

		public function set color(value:uint):void {
			_color = value;
		}

		public function get status():String {
			return _status;
		}

		public function set status(value:String):void {
			_status = value;
			labelTF.setTextFormat(TXTFormat.getStyle(style, status));
			
			if (status == "selected") {
				shape.alpha = 1;
				
				this.removeEventListener(MouseEvent.MOUSE_OVER, _over);
				this.removeEventListener(MouseEvent.MOUSE_OUT, _out);
				
			} else {
				shape.alpha = 0;
				
				this.addEventListener(MouseEvent.MOUSE_OVER, _over);
				this.addEventListener(MouseEvent.MOUSE_OUT, _out);
			}
		}

		public function get style():String {
			return _style;
		}

		public function set style(value:String):void {
			_style = value;
		}


	}
}