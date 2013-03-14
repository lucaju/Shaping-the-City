package view {
	
	//imports
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class BlockShape extends Sprite{
		
		//properties
		public var trueLocation:Point;
		
		
		private var _id:int;
		private var _location:Point;
		private var _vector:Vector.<Number>;
		private var _group:String;
		private var _period:int;
		
		private var _numTrees:int = 0;
		
		private var scale:Number;
		
		public var surface:Number;
		
		public function BlockShape(id_:int, _scale:Number = 1) {
			_id = id_;
			scale = _scale;
			
			//this.addEventListener(MouseEvent.MOUSE_OVER, _over);
			//this.addEventListener(MouseEvent.MOUSE_OUT, _out);
			//this.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			//this.addEventListener(MouseEvent.MOUSE_UP, _mouseUp);
		}
		
		
		protected function _over(event:Event):void {
			this.alpha = 1;
		}	
		protected function _out(event:MouseEvent):void {
			this.alpha = .4;
		}
		
		protected function _mouseDown(event:MouseEvent):void {
			this.startDrag();
		}
		
		protected function _mouseUp(event:MouseEvent):void {
			this.stopDrag();
		}
		
		public function drawShape(coords:Array):void {
			var origin:Point = new Point(coords[0].x, coords[0].y);
			
			var shape:Array = new Array();
			
			for each (var coord:Point in coords) {
				
				//populate vector parts
				shape.push((coord.x - origin.x) * scale);
				shape.push((coord.y - origin.y) * scale);
				
			}
			
			//create vector and save the vector
			vector = Vector.<Number>(shape);
			
			var command:Vector.<int> = new Vector.<int>();
			var c:int = 0;
			
			//vector coordinates loop
			for (var i:int = 0; i < shape.length; i++) {
				
				if(i%2 == 0) {
					if (i==0) {
						command[c] = 1;
					} else {
						command[c] = 2;
					}
					
					
					c++;
				}
				
			}
			
			//draw object
			this.graphics.beginFill(0x333333);
			this.graphics.drawPath(command,vector);
			this.graphics.endFill();
			this.alpha = .4;	
			
			surface = getSurface();
			
		}
		
		public function get id():int {
			return _id;
		}
		
		public function get location():Point {
			return _location;
		}
		
		public function set location(value:Point):void {
			_location = value;
		}
		
		public function get vector():Vector.<Number> {
			return _vector;
		}
		
		public function set vector(value:Vector.<Number>):void {
			_vector = value;
		}
		
		public function get period():int {
			return _period;
		}
		
		public function set period(value:int):void {
			_period = value;
		}
		
		public function get group():String {
			return _group;
		}
		
		public function set group(value:String):void {
			_group = value;
		}
		
		public function getSurface():Number {
			
			//calculate are of a non convex irregular poligon
			//A = (1/2)[Det(x1,x2,y1,y2)+Det(x2,x3,y2,y3)+ ... +Det(xn,x1,yn,y1)],
			//where Det(a,b,c,d) = a*d-b*c.
			
			var i:int = 0; 
			var j:int = 0; 
			var k:int = 0;
			var l:int = 0;
			
			var n:int = vector.length; 
			var surf:Number = 0;
			
			for(i=0 ; i<n ; i+=2){ 
				j = (i+1) % n;
				k = (i+2) % n;
				l = (i+3) % n;
				
				surf += (vector[i] * vector[l]) - (vector[j] * vector[k]); 
			}
			
			surf = surf / 2;
			
			if (surf < 0) {
				surf = -surf;
			}
			
			return surf;
		}

		public function get numTrees():int {
			return _numTrees;
		}

		public function set numTrees(value:int):void {
			_numTrees = value;
		}

		
	}
}