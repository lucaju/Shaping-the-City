package view.menu {
	
	//imports
	import mvc.AbstractView;
	import mvc.IController;
	
	public class AbstractMenu extends AbstractView {
		
		//properties
		protected var _orientation:String = "horizontal";
		protected var _gap:Number; 
		
		protected var optionCollection:Array;
		protected var itemCollection:Array;
		
		
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
		
		public function init():void {
			
		}
		
		public function addOption(value:Object):void {
			optionCollection.push(value);
			
		}

		public function get orientation():String{
			return _orientation;
		}

		public function set orientation(value:String):void {
			_orientation = value;
		}

		public function get gap():Number {
			return _gap;
		}

		public function set gap(value:Number):void {
			_gap = value;
		}
		

	}
}