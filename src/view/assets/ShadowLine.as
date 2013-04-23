package view.assets  {
	
	//import
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ShadowLine extends Sprite {

		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param range
		 * @param orientation
		 * @param rotation
		 * 
		 */
		public function ShadowLine(range:Number, orientation:String = "horizontal", rotation:int = 270) {
			
			//matrix - rotation
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(5, 5, (Math.PI/180)*rotation, 0, 0);
			
			//GRadient
			var shadow:Shape = new Shape();
			shadow.graphics.beginGradientFill("linear",[0x000000,0x000000],[0,.9],[0,255],matrix);
			
			//orientation
			if (orientation == "horizontal") {
				shadow.graphics.drawRect(0,0,range,5);
			} else {
				shadow.graphics.drawRect(0,0,5,range);
			}
			
			//finals
			shadow.graphics.endFill();
			shadow.blendMode = "multiply";
			shadow.alpha = .5;
			addChild(shadow);
			
		}
	}
}