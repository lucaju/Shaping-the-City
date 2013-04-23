package view.util.scroll {		//imports	import flash.display.Sprite;	import flash.geom.Rectangle;		public class Roll extends Sprite {				//****************** Properties ****************** ****************** ****************** 				protected var _size					:Object;		protected var _color				:uint;						//****************** Constructor ****************** ****************** ****************** 				/**		 * 		 * @param color_		 * 		 */		public function Roll(color:uint = 0x000000) {						_color = color;						// constructor code			alpha = 0;		}						//****************** Initialize ****************** ****************** ****************** 				/**		 * 		 * @param direction		 * 		 */		public function init(direction:String):void {						var slice9rect:Rectangle;						this.graphics.beginFill(color, .6);						if (direction == "vertical") {								this.graphics.drawRoundRect(0,0,6,30,5);				slice9rect = new Rectangle(1, 10, 4, 6);							} else {				this.graphics.drawRoundRect(0,0,30,6,5);				slice9rect = new Rectangle(10, 1, 6, 4);					}						this.graphics.endFill();						this.scale9Grid = slice9rect; 						size = {w:this.width, h:this.height};		}				//****************** GETTERS ****************** ****************** ****************** 				/**
		 * 
		 * @return 
		 * 
		 */
		public function get size():Object {
			return _size;
		}				/**		 * 		 * @return 		 * 		 */		public function get color():uint {			return _color;		}				//****************** SETTERS ****************** ****************** ****************** 		/**
		 * 
		 * @param value
		 * 
		 */
		public function set size(value:Object):void {
			_size = value;
		}		/**
		 * 
		 * @param value
		 * 
		 */
		public function set color(value:uint):void {
			_color = value;
		}	}	}