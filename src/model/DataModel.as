package model {
	
	//imports
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import events.PipelineEvents;
	
	import mvc.Observable;
	
	public class DataModel extends Observable {
		
		//properties
		private var urlLoader:URLLoader;
		private var urlRequest:URLRequest;
		
		private var shapeCollection:Array;			//Collection
		private var neighbourhoodCollection:Array;			//Collection
		
		public function DataModel() {
			super();
			
			//define name
			this.name = "DataModel";
			
		}
		
		//*************** LOADS ***************
				
		public function loadShapesData():void {
			
			if (!hasShapesData) {
				
				var processShapes:ProcessShapes = new ProcessShapes();
				processShapes.addEventListener(Event.COMPLETE, processComplete);
				processShapes.loadData("http://labs.fluxo.art.br/pipeline/pipeline/php/getShapes.php");
				processShapes = null;
			}
			
		}
		
		public function loadNeigbourhoods():void {
			if (!hasNeighbourhoodData) {
				var processNeighbourhoods:ProcessNeighbourhoods = new ProcessNeighbourhoods();
				processNeighbourhoods.addEventListener(Event.COMPLETE, processComplete);
				processNeighbourhoods.loadData("http://labs.fluxo.art.br/pipeline/pipeline/php/getNeighbourhoods.php");
				processNeighbourhoods = null;
			}
		}
		
		private function processComplete(e:Event):void {
			
			var obj:Object;
			
			switch (e.target.name) {
				
				case "cityShapes":
					shapeCollection = e.target.data;
					obj = {type:e.target.name, data:shapeCollection};
					break;
				
				case "neighbourhoods":
					neighbourhoodCollection = e.target.data;
					obj = {type:e.target.name, data:neighbourhoodCollection};
					break;
				
			}
			
			this.dispatchEvent(new PipelineEvents(PipelineEvents.COMPLETE,obj));
			obj = null;
		}
		
		public function getShapeCollection():Array {
			return shapeCollection.concat();
		}
		
		//*************** SHAPES METHODS
		public function get hasShapesData():Boolean {
			return shapeCollection ? true : false;
		}
		
		//*************** NEIGHBOURHOODS METHODS
		
		public function get hasNeighbourhoodData():Boolean {
			return neighbourhoodCollection ? true : false;
		}
		
		public function getNeighbourhoods():Array {
			return neighbourhoodCollection.concat();
		}
		
		public function getNeighbourhoodNames():Array {
			var areas:Array = neighbourhoodCollection.concat();;
			areas.sortOn("name");
			var names:Array = new Array;
			
			for each (var n:Neighbourhood in areas) {
				names.push(n.name);
			}
			
			areas = null;
			return names;
		}
		
		public function getPeriod():Array {
			var areas:Array = neighbourhoodCollection.concat();;
			areas.sortOn("period",Array.UNIQUESORT);
			
			var periods:Array = new Array;
			
			for each (var n:Neighbourhood in areas) {
				if (periods[periods.length-1] != n.period) {
					periods.push(n.period);
				}
			}
			
			//clean
			for each (var p:int in periods) {
				if (p == 0) {
					periods.splice(periods.indexOf(p),1);
				}
			}
			
			areas = null;
			return periods;
		}
	}
}