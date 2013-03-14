package model {
	
	//imports
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import events.PipelineEvents;
	
	import mvc.Observable;
	
	public class DataModel extends Observable {
		
		//properties
		private var urlLoader					:URLLoader;
		private var urlRequest					:URLRequest;
		
		private var shapeCollection				:Array;			//Collection
		private var neighbourhoodCollection		:Array;			//Collection
		private var shapeHighlighted			:Object;		//{type:String, neighbourhoods:Array, shapes:Array}
		
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
		
		public function getCityShapeByID(value:int):CityShape {
			for each (var s:CityShape in shapeCollection) {
				if (s.id == value) {
					return s;
					break;
				}
			}
			return null;
		}
		
		public function getCityShapesByNeighbourhood(value:int):Array {
			
			var sArray:Array = new Array();
			
			for (var i:int = 0; i < shapeCollection.length; i++) {
				if (shapeCollection[i].neighbourhood == value) {
					sArray.push(shapeCollection[i]);
				}
			}
			
			return sArray;
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
		
		public function getNeighbourhoodByID(value:int):Neighbourhood {
			
			for each (var n:Neighbourhood in neighbourhoodCollection) {
				if (n.id == value) {
					return n;
					break;
				}
			}
			return null;
		}
		
		public function getNeighbourhoodIDByName(value:String):int {
			for each (var n:Neighbourhood in neighbourhoodCollection) {
				if (n.name.toLowerCase() == value.toLowerCase()) {
					return n.id;
					break;
				}
			}
			return null;
		}
		
		public function getNeighbourhoodIDsByPeriod(pStart:int, pEnd:int):Array {
			
			var selects:Array = new Array();
			
			for each (var n:Neighbourhood in neighbourhoodCollection) {
				if (n.period >= pStart && n.period <= pEnd) {
					selects.push(n.id);
				}
			}
			
			return selects;
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
		
		public function highlightShapes(data:*, type:String):void {
			
			var nArray:Array = new Array();
			var sArray:Array = new Array();
			
			//if shape are not highlighted yet OR if the type doesn't match
			//Remove previous higlighted shapes and initiate a new one.
			if (!shapeHighlighted || shapeHighlighted.type != type) {
				shapeHighlighted = null;
				
				shapeHighlighted = new Object();
				shapeHighlighted.type = type;
				shapeHighlighted.neighbourhoods = nArray;
				shapeHighlighted.shapes = sArray;
			}
			
			
			//test data: If it is just one nighbourhood or a collection o neighbouhoods
			if (data is int) {
				
				//test if the neighbourhoods is already on the list
				var hasNeighbourhood:Boolean = false;
				nArray = shapeHighlighted.neighbourhoods;
				
				for each (var hn:int in nArray) {	
					if (hn == data) {
						hasNeighbourhood = true;
						break;
					}
				}
				
				//If the neighbourhoods is not on the list yet, add shapes
				if (!hasNeighbourhood) {
					nArray.push(getNeighbourhoodByID(data));
					
					sArray = shapeHighlighted.shapes;
					
					//get new shapes to add
					var newShapesArray:Array = getCityShapesByNeighbourhood(data);
					
					//add shapes to the list
					sArray = sArray.concat(newShapesArray);
					
					
				}
				
				
				
			} else if (data is Array) {
				
			}
			
			
			
			shapeHighlighted.neighbourhoods = nArray;
			shapeHighlighted.shapes = sArray;
			
			
			var eventData:Object = new Object();
			eventData.type = "highlight";
			eventData.action = "add";
			eventData.data = shapeHighlighted.shapes;
			
			this.dispatchEvent(new PipelineEvents(PipelineEvents.CHANGE, eventData));
			
		}
	}
}