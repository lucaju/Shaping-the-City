package view.tooltip {
	
	//imports
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	public class Balloon extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var round							:Number = 10;					// Round corners

		protected var _arrowDirection				:String = "bottom";				// Arrow point direction
		protected var arrowWidth					:Number = 10;					// Balloon's arrow point width
		protected var arrowHeight					:Number = 5;					// Balloon's arrow point height
		
		protected var _color						:uint = 0xFFFFFF;				// Fill color. Default: 0xFFFFFF
		
		protected var balloon						:Sprite;
		protected var arrow							:Sprite;
			
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * Balooon Contructor.
		 * 
		 */
		public function Balloon() {
				
		}
		
		
		//****************** Initialize ****************** ******************  ****************** 

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
			arrow.graphics.beginFill(_color, 1);
			arrow.graphics.moveTo(-arrowWidth/2, -arrowHeight/2);
			arrow.graphics.lineTo(arrowWidth/2, -arrowHeight/2);
			arrow.graphics.lineTo(0,arrowHeight/2);
			arrow.graphics.lineTo(-arrowWidth/2, -arrowHeight/2);
			arrow.graphics.endFill();
			
			addChild(arrow)
			
			//position
			
			switch (arrowDirection) {
				case "bottom":
					arrow.x = balloon.x + balloon.width/2;
					arrow.y = balloon.y + balloon.height + arrow.height/2;
				break;
				
				case "top":
					arrow.rotation = 180;
					arrow.x = balloon.x + balloon.width/2;
					arrow.y = balloon.y - arrow.height/2;
			}
			
		}

		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get arrowDirection():String {
			return _arrowDirection;
		}
		
		
		//****************** SETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set arrowDirection(value:String):void {
			_arrowDirection = value;
		}
		
		/**
		 * 
		 * @param newColor
		 * 
		 */
		public function set color(newColor:uint):void {
			_color = newColor;
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
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
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function glow(value:Boolean):void {
			
			if (value) {
				
				var fxs:Array = new Array();
				var fxGlow:BitmapFilter = getBitmapFilter(0x000000, .5);
				fxs.push(fxGlow);
				this.filters = fxs;
				
				fxs = null;
				fxGlow = null;
				
			} else {
				
				this.filters = null;
				
			}
			
		}
		
		//****************** PRIVATE METHODS ****************** ******************  ******************
		
		/**
		 * 
		 * @param colorValue
		 * @param a
		 * @return 
		 * 
		 */
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