package model {
	
	/**
	 * This class holds the highlighted shapes and its metadata. 
	 * @author lucaju
	 * 
	 */
	public class HighlightedShapes {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var _type					:String;
		protected var _neighbourhoods		:Array;
		protected var _periods				:Array;
		protected var _shapes				:Array;
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function HighlightedShapes() {
			_neighbourhoods = new Array();
			_periods = new Array();
			_shapes = new Array();
		}
		
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get type():String {
			return _type;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get neighbourhoods():Array {
			return _neighbourhoods;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get periods():Array {
			return _periods;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get shapes():Array {
			return _shapes;
		}
		
		
		//****************** SETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set type(value:String):void {
			_type = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set neighbourhoods(value:Array):void {
			_neighbourhoods = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set periods(value:Array):void {
			_periods = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set shapes(value:Array):void {
			_shapes = value;
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function addNeighbourhood(value:Neighbourhood):void {
			_neighbourhoods.push(value);
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function addPeriod(value:String):void {
			_periods.push(value);
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function removePeriod(value:String):void {
			_periods.splice(_periods.indexOf(value),1);
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function addShape(value:CityShape):void {
			_shapes.push(value);
		}
		
		/**
		 * 
		 * 
		 */
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