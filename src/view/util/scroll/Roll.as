package view.util.scroll {		//imports	import flash.display.Sprite;	import flash.geom.Rectangle;		public class Roll extends Sprite {				protected var _size:Object;		protected var _color:uint;				//properties		public function Roll(color_:uint = 0x000000) {						color = color_						// constructor code			alpha = 0;		}				public function init(direction:String):void {						var slice9rect:Rectangle;						this.graphics.beginFill(color, .6);						if (direction == "vertical") {								this.graphics.drawRoundRect(0,0,6,30,5);				slice9rect = new Rectangle(1, 10, 4, 6);							} else {				this.graphics.drawRoundRect(0,0,30,6,5);				slice9rect = new Rectangle(10, 1, 6, 4);					}						this.graphics.endFill();						this.scale9Grid = slice9rect; 						size = {w:this.width, h:this.height};		}		public function get size():Object {
			return _size;
		}		public function set size(value:Object):void {
			_size = value;
		}		public function get color():uint {
			return _color;
		}		public function set color(value:uint):void {
			_color = value;
		}	}	}