package model {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Neighbourhood {
		
		//****************** Properties ****************** ****************** ****************** 
		
		protected var _id					:int;
		protected var _name					:String;
		protected var _period				:int = 0;
		protected var _shapes				:Array;
		
		
		//****************** Construtor ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param id_
		 * 
		 */
		public function Neighbourhood(id_:int) {
			_id = id_;
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
		public function get name():String {
			return _name;
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
		public function get shapes():Array {
			return _shapes;
		}
		
		
		//****************** SETTERS ****************** ****************** ****************** 

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set name(value:String):void {
			_name = value;
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
		public function set shapes(value:Array):void {
			_shapes = value;
		}

	}
}