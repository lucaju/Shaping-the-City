package model {
	
	//imports
	import flash.geom.Point;
	
	public class TreeModel {
		
		//properties
		private var _id:int;
		private var _location:Point;
		private var _date:Date;
		private var _species:String;
		private var _type:String;
		private var _diameter:Number;
		private var _condition:Number;
		private var _owner:String;
		private var _neighbourhood:String;
		
		
		public function TreeModel(id_:int,location_:Point) {
			_id = id_;
			location = location_;
			
		}

		public function get id():int {
			return _id;
		}
		
		public function get location():Point {
			return _location;
		}
		
		public function get latitude():Number {
			return _location.y;
		}
		
		public function get longitude():Number {
			return _location.x;
		}
		
		public function set location(value:Point):void {
			_location = value;
		}
		
		public function get date():Date {
			return _date;
		}
		
		public function set date(value:Date):void {
			_date = value;
		}
		
		public function get species():String {
			return _species;
		}
		
		public function set species(value:String):void {
			_species = value;
		}
		
		public function get type():String {
			return _type;
		}
		
		public function set type(value:String):void {
			_type = value;
		}
		
		public function get diameter():Number {
			return _diameter;
		}
		
		public function set diameter(value:Number):void {
			_diameter = value;
		}
		
		public function get condition():Number {
			return _condition;
		}
		
		public function set condition(value:Number):void {
			_condition = value;
		}

		public function get owner():String {
			return _owner;
		}

		public function set owner(value:String):void {
			_owner = value;
		}

		public function get neighbourhood():String {
			return _neighbourhood;
		}

		public function set neighbourhood(value:String):void {
			_neighbourhood = value;
		}

	}
}