package util {
	
	//imports
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class Utilities extends Sprite {
		
		public function Utilities() {
			
		}
		
		
		static public function setRegistrationPoint(s:Sprite, regx:Number, regy:Number, showRegistration:Boolean = false):void {
			//translate movieclip 
			s.transform.matrix = new Matrix(1, 0, 0, 1, -regx, -regy);
			
			//registration point.
			if (showRegistration) {
				var mark:Sprite = new Sprite();
				mark.graphics.lineStyle(1, 0x000000);
				mark.graphics.moveTo(-5, -5);
				mark.graphics.lineTo(5, 5);
				mark.graphics.moveTo(-5, 5);
				mark.graphics.lineTo(5, -5);
				s.parent.addChild(mark);
			}
		}
		

	}
}