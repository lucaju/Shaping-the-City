package view.assets {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class ArrowBT extends Sprite {
		
		//properties
		private var shape:Shape;
		
		public function ArrowBT(direction:String = "down") {
			
			super();
			
			var triangleCommands:Vector.<int> = new Vector.<int>(3, true);
			
			triangleCommands[0] = 1;
			triangleCommands[1] = 2;
			triangleCommands[2] = 2;
			
			var triangleCoord:Vector.<Number> = new Vector.<Number>(10, true);
			triangleCoord[0] = -4; //x
			triangleCoord[1] = -5; //y 
			triangleCoord[2] = 4; 
			triangleCoord[3] = 0; 
			triangleCoord[4] = -4; 
			triangleCoord[5] = 5; 
			
			shape = new Shape();
			shape.graphics.beginFill(0xFFFFFF);
			shape.graphics.drawPath(triangleCommands,triangleCoord);
			shape.graphics.endFill();
			
			this.addChild(shape);
			
			changeDirection(direction);
		}
		
		public function changeDirection(direction:*):void {
			
			if(direction is String) {
			
				switch(direction) {
					
					case "down":
						shape.rotation = 90;
						break;
					
					case "up":
						shape.rotation = -90;
						break;
					
					case "right":
						shape.rotation = 0;
						break;
					
					case "left":
						shape.rotation = 180;
						break;
				}
			} else {
				shape.rotation = direction;
			}
			
		}
	}
}