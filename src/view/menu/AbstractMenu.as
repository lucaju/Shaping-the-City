package view.menu {
	
	//imports
	import mvc.AbstractView;
	import mvc.IController;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractMenu extends AbstractView {
		
		//****************** Properties ****************** ****************** ****************** 
		protected var _orientation				:String = "horizontal";
		protected var _gap						:Number; 
		
		protected var optionCollection			:Array;
		protected var itemCollection			:Array;
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param c
		 * @param options
		 * 
		 */
		public function AbstractMenu(c:IController, options:Array = null) {
			super(c);
			
			optionCollection = new Array();
			itemCollection = new Array();
			
			if (options) {
				for each (var option:Object in options) {
					addOption(option);
				}
			}
		}
		
		//****************** Initialize ****************** ****************** ****************** 
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			//to override
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function addOption(value:Object):void {
			optionCollection.push(value);
			
		}
		
		
		//****************** GETTERS ****************** ****************** ****************** 

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get orientation():String{
			return _orientation;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get gap():Number {
			return _gap;
		}
		
		//****************** SETTERS ****************** ****************** ****************** 

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set orientation(value:String):void {
			_orientation = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set gap(value:Number):void {
			_gap = value;
		}
		

	}
}