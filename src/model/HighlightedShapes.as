package model {
	
	public class HighlightedShapes {
		
		//****************** Properties ****************** ******************  ****************** 
		protected var _type					:String;
		protected var _neighbourhoods		:Array;
		protected var _periods				:Array;
		protected var _shapes				:Array;
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		public function HighlightedShapes() {
			_neighbourhoods = new Array();
			_periods = new Array();
			_shapes = new Array();
		}
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		public function get type():String {
			return _type;
		}

		public function get neighbourhoods():Array {
			return _neighbourhoods;
		}

		public function get periods():Array {
			return _periods;
		}

		public function get shapes():Array {
			return _shapes;
		}
		
		
		//****************** SETTERS ****************** ******************  ****************** 
		
		public function set type(value:String):void {
			_type = value;
		}
		
		public function set neighbourhoods(value:Array):void {
			_neighbourhoods = value;
		}
		
		public function set periods(value:Array):void {
			_periods = value;
		}
		
		public function set shapes(value:Array):void {
			_shapes = value;
		}
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		public function addNeighbourhood(value:Neighbourhood):void {
			_neighbourhoods.push(value);
		}
		
		public function addPeriod(value:String):void {
			_periods.push(value);
		}
		
		public function addShape(value:CityShape):void {
			_shapes.push(value);
		}
		
		public function clean():void {
			_type = "";
			_neighbourhoods = null;
			_periods = null;
			_shapes = null;
			
			_neighbourhoods = new Array();
			_periods = new Array();
			_shapes = new Array();
		}
		
		
	}
}