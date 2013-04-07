package model {
	
	public class Neighbourhood {
		
		//properties
		protected var _id:int;
		protected var _name:String;
		protected var _period:int = 0;
		protected var _shapes:Array;
		
		public function Neighbourhood(id_:int) {
			_id = id_;
		}

		public function get id():int {
			return _id;
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		public function get period():int {
			return _period;
		}

		public function set period(value:int):void {
			_period = value;
		}
		
		public function get shapes():Array {
			return _shapes;
		}
		
		public function set shapes(value:Array):void {
			_shapes = value;
		}

	}
}