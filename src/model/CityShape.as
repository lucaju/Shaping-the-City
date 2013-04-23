package model {
	
	//imports
	import flash.geom.Point;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CityShape {
		
		//****************** Properties ****************** ****************** ****************** 
		
		protected var _id							:int;
		protected var _location						:Point;
		protected var _shape						:Vector.<Number>;
		protected var _coordinates					:Array;
		protected var _group						:String;
		protected var _neighbourhood				:int;
		protected var _period						:int;
		
		
		//****************** Construcotr ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param id_
		 * @param location_
		 * 
		 */
		public function CityShape(id:int,location:Point) {
			_id = id;
			_location = location;
			_coordinates = new Array();
		}
		
		//****************** GETTERS ****************** ****************** ****************** 

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get location():Point {
			return _location;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get shape():Vector.<Number> {
			return _shape;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get period():int {
			return _period;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get neighbourhood():int {
			return _neighbourhood;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get group():String {
			return _group;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get coordinates():Array {
			return _coordinates;
		}
		
		//****************** SETTERS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set location(value:Point):void {
			_location = value;
		}		
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set shape(value:Vector.<Number>):void {
			_shape = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set period(value:int):void {
			_period = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set neighbourhood(value:int):void {
			_neighbourhood = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set group(value:String):void {
			_group = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set coordinates(value:Array):void {
			_coordinates = value;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function addCoordinate(value:Point):void {
			_coordinates.push(value);
		}

	}
}