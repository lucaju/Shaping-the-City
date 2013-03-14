package view.assets.tooltip {
	
	//imports
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	public class Balloon extends Sprite {
		
		//properties
		private var balloon:Sprite;
		
		private var round:Number = 10;						// Round corners
		private var _color:uint = 0xFFFFFF;					// Fill color. Default: 0xFFFFFF
		
		private var _arrow:Sprite;
		private var arrowDirection:String = "bottom";		// Arrow point direction	
		private var arrowWidth:Number = 10;					// Balloon's arrow point width
		private var arrowHeight:Number = 5;					// Balloon's arrow point height
		
		
		/**
		 * Balooon Contructor.
		 * 
		 */
		public function Balloon() {
			
			super();
			
		}
		
		/**
		 * This method draws the ballon with an arrow positioned at the botton and add a glow effects.
		 *  
		 * @param w:Number
		 * @param h:Number
		 * 
		 */
		public function init(w:Number, h:Number):void {
			
			//draw balloon
			balloon = new Sprite();
			balloon.graphics.beginFill(_color,1);
			balloon.graphics.drawRoundRect(0,0,w,h,round,round);
			balloon.graphics.endFill();
			
			addChild(balloon)
			
			//draw arrow
			arrow = new Sprite();
			arrow.graphics.beginFill(_color,1);
			arrow.graphics.moveTo(-arrowWidth/2, -arrowHeight/2);
			arrow.graphics.lineTo(arrowWidth/2, -arrowHeight/2);
			arrow.graphics.lineTo(0,arrowHeight/2);
			arrow.graphics.lineTo(-arrowWidth/2, -arrowHeight/2);
			arrow.graphics.endFill();
			
			addChild(arrow)
			
			arrow.x = balloon.x + balloon.width/2;
			arrow.y = balloon.y + balloon.height + arrow.height/2;
			
			//effects
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x000000, .5);
			fxs.push(fxGlow);
			this.filters = fxs;
			
		}
		
		/**
		 * Switch arrow's position from bottom to top.
		 * Valid value: "top".
		 *  
		 * @param orientation:String
		 */
		public function changeOrientation(orientation:String):void {
			switch(orientation) {
				case "top":
					arrow.scaleY = -1;
					arrow.y = arrow.height/2;
					balloon.y = arrow.y + arrow.height/2;
					break;
			}
		}
		
		/**
		 * Move arrow horizontally.
		 *   
		 * @param offset:Number
		 * 
		 */
		public function arrowOffsetH(offset:Number):void {
			arrow.x += -offset;
		}
		
		public function set color(newColor:uint):void {
			_color = newColor;
		}
		
		public function get color():uint {
			return _color;
		}

		public function get arrow():Sprite {
			return _arrow;
		}

		public function set arrow(value:Sprite):void {
			_arrow = value;
		}
		
		// fx
		private function getBitmapFilter(colorValue:uint, a:Number):BitmapFilter {
			//propriedades
			var color:Number = colorValue;
			var alpha:Number = a;
			var blurX:Number = 3;
			var blurY:Number = 3;
			var strength:Number = 3;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality);
		}

	}
}