package view.util.scroll {		//imports	import flash.display.Sprite;	import flash.geom.Rectangle;		/**	 * 	 * @author lucaju	 * 	 */	public class Track extends Sprite {				//****************** Properties ****************** ****************** ****************** 						//****************** Constructor ****************** ****************** ****************** 				/**		 * 		 * 		 */		public function Track() {			alpha = 0;						this.graphics.beginFill(0x000000, .1);			this.graphics.drawRoundRect(0,0,5,10,2,2);			this.graphics.endFill();						var slice9rect:Rectangle = new Rectangle(1, 2, 3, 6);			this.scale9Grid = slice9rect;		}	}	}