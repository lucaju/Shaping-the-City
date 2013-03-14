package model {
	import flash.geom.Point;
	
	//imports
	
	public class CityShape {
		
		//properties
		private var _id:int;
		private var _location:Point;
		private var _shape:Vector.<Number>;
		private var _coordinates:Array;
		private var _group:String;
		private var _neighbourhood:int;
		private var _period:int;
		
		public function CityShape(id_:int,location_:Point) {
			_id = id_;
			location = location_;
			
			_coordinates = new Array();
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
		
		public function get shape():Vector.<Number> {
			return _shape;
		}
		
		public function set shape(value:Vector.<Number>):void {
			_shape = value;
		}

		public function get period():int {
			return _period;
		}

		public function set period(value:int):void {
			_period = value;
		}
		
		public function get neighbourhood():int {
			return _neighbourhood;
		}
		
		public function set neighbourhood(value:int):void {
			_neighbourhood = value;
		}

		public function get group():String {
			return _group;
		}

		public function set group(value:String):void {
			_group = value;
		}
		
		public function set coordinates(value:Array):void {
			_coordinates = value;
		}
		
		public function get coordinates():Array {
			return _coordinates;
		}
		
		public function addCoordinate(value:Point):void {
			_coordinates.push(value);
		}

	}
}