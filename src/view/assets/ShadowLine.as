package view.assets  {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class ShadowLine extends Sprite {

		public function ShadowLine(w:Number, rotation:int = 270) {
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(5, 5, (Math.PI/180)*rotation, 0, 0);
			
			
			var shadow:Shape = new Shape();
			shadow.graphics.beginGradientFill("linear",[0x000000,0x000000],[0,.9],[0,255],matrix);
			shadow.graphics.drawRect(0,0,w,5);
			shadow.graphics.endFill();
			shadow.blendMode = "multiply";
			shadow.alpha = .5;
			addChild(shadow);
			
			/*
			var shadow:Sprite = new Sprite();
			
			shadow.graphics.beginGradientFill("linear",[0x000000,0xFFFFFF],[1,0],[0,255]);
			shadow.graphics.drawRect(0,0,255,w);
			shadow.graphics.endFill();
			shadow.alpha = .8;
			shadow.width = 16;
			shadow.x = shadow.height;
			shadow.rotation = 90;
			addChild(shadow);
			*/
		}
	}
}