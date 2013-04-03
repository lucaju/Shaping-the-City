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
		private var highlightedShapes			:HighlightedShapes;		//{type:String, neighbourhoods:Array, shapes:Array}
		
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
		
		public function getHighlightedPeriods():Array {
			
			if (highlightedShapes) {
				return highlightedShapes.periods;
			} else {
				return null;
			}
		}
		
		public function getHighlightedNeighbourhoods():Array {
			
			if (highlightedShapes) {
				if (highlightedShapes.periods.length == 0) {
					return highlightedShapes.neighbourhoods;
				}
			}
			
			return null;
			
		}
		
		public function getHighlightedNeighbourhoodsNames():Array {
			
			if (highlightedShapes) {
				if (highlightedShapes.periods.length == 0) {
					
					var neighbourhoodsName:Array = new Array();
					
					for each (var n:Neighbourhood in highlightedShapes.neighbourhoods) {
						neighbourhoodsName.push(n.name);
					}
					
					return neighbourhoodsName;
				}
			}
			
			return null;
			
		}
		
		public function addHighlightShapes(data:Array, type:String, source:String):void {
			
			//Creating data to send
			var eventData:Object = new Object();
			eventData.source = source;
			eventData.type = type;
			eventData.method = "highlight";
			eventData.action = "add";
			eventData.reset = false;
			
			var affectetedShapes:Array = new Array();
			var affectetedNeighbourhoods:Array = data;
			
			//if shapes are not highlighted yet
			if (!highlightedShapes) {
				highlightedShapes = new HighlightedShapes();
			}
			
			
			//if the type doesn't match
			//Remove previous higlighted shapes and initiate a new one.
			if (highlightedShapes.type != type) {
				highlightedShapes.clean();
				highlightedShapes.type = type;
				highlightedShapes.neighbourhoods = new Array();;
				highlightedShapes.shapes = new Array();
				
				eventData.reset = true;  /////<<<<<<<<<<<<<<<<<<<<< // Reset if the user change types
			}
			
			//if type is period, save the source button
			if (type == "period") {
				highlightedShapes.addPeriod(source)
			}
			
			//get data
			var nArray:Array = highlightedShapes.neighbourhoods;
			var sArray:Array = sArray = highlightedShapes.shapes;
			
			/*
			trace ("Action: "+ eventData.action);
			trace ("Type: " + eventData.type);
			trace ("Method: " + eventData.method);
			trace ("Reset: " + eventData.reset);
			trace ("Request Neighbourhoods: " + affectetedNeighbourhoods.length + " - " + affectetedNeighbourhoods);
			trace ("Current Total Neighbourhoods Highlight: " + nArray.length);
			trace ("Current Total Shapes Highlight: " + sArray.length);
			*/
			
			//test if the neighbourhoods are already on the list
			var ignoreNeighbourhoods:Array = new Array();
		
			for each (var nHighlighted:Neighbourhood in nArray) {
				for each (var toHightlight:int in affectetedNeighbourhoods) {
					if (nHighlighted.id == toHightlight) {
						ignoreNeighbourhoods.push(affectetedNeighbourhoods.indexOf(toHightlight));
					}
				}
			}
			
			//ignore neighbourhoods that are already on the list
			for each (var ig:int in ignoreNeighbourhoods) {
				affectetedNeighbourhoods.splice(ig,1)
			}
			
			ignoreNeighbourhoods = null;
			
			
			//Proceed if there are at leat one affected neighbourhood
			if (affectetedNeighbourhoods.length > 0) {
				
				//For each new neighbourhood
				for each (var nAffect:int in affectetedNeighbourhoods) {
					
					//save neighbourhood to the list
					nArray.push(getNeighbourhoodByID(nAffect));
					
					//get new shapes to add
					affectetedShapes = affectetedShapes.concat(getCityShapesByNeighbourhood(nAffect));
				}
				
				//add shapes to the list
				sArray = sArray.concat(affectetedShapes);
			
				//saving
				highlightedShapes.neighbourhoods = nArray;
				highlightedShapes.shapes = sArray;
				
			}
				
			//send data event
			eventData.shapes = affectetedShapes;
			this.dispatchEvent(new PipelineEvents(PipelineEvents.CHANGE, eventData));
			
			/*
			trace ("Neighbourhoods Affected: " + affectetedNeighbourhoods.length)
			trace ("Shapes Affected: " + affectetedShapes.length)
			trace ("Update Total Neighbourhoods Highlight: " + nArray.length)
			trace ("Update Total Shapes Highlight: " + sArray.length)
			
			trace ("-------")
			*/
		}
		
		public function removeHighlightedShapes(data:*, type:String, source:String):void {
			
			//if there are highlighted shapes AND the type does match
			if (highlightedShapes && highlightedShapes.type == type) {
				
				//Creating data to send
				var eventData:Object = new Object();
				eventData.source = source;
				eventData.type = type;
				eventData.method = "highlight";
				eventData.action = "remove";
				eventData.reset = false;
				
				var affectetedShapes:Array = new Array();
				var affectetedNeighbourhoods:Array = data;
				
				var nArray:Array = highlightedShapes.neighbourhoods;
				var sArray:Array = highlightedShapes.shapes;
				
				/*
				trace ("Action: "+ eventData.action);
				trace ("Type: " + eventData.type);
				trace ("Method: " + eventData.method);
				trace ("Reset: " + eventData.reset);
				trace ("Request Neighbourhoods: " + affectetedNeighbourhoods.length + " - " + affectetedNeighbourhoods)
				trace ("Current Total Neighbourhoods Highlight: " + nArray.length)
				trace ("Current Total Shapes Highlight: " + sArray.length)
				*/
				
				//test if the neighbourhoods are already on the list
				var confirmAffected:Array = new Array();
				
				for each (var nHighlighted:Neighbourhood in nArray) {
					for each (var toHightlight:int in affectetedNeighbourhoods) {
						if (nHighlighted.id == toHightlight) {
							confirmAffected.push(toHightlight);
						}
					}
				}
				
				//
				affectetedNeighbourhoods = confirmAffected;
				confirmAffected = null;
				
				//trace (">>>: " + affectetedNeighbourhoods.length)
				//Proceed if there are at leat one affected neighbourhood
				if (affectetedNeighbourhoods.length > 0) {
					
					//For each affected neighbourhood
					for each (var nAffect:int in affectetedNeighbourhoods) {
						
						//remove neighbourhood from the list
						var n:Neighbourhood = getNeighbourhoodByID(nAffect);
						nArray.splice(nArray.indexOf(n),1)
						
						//add shapes to remove
						affectetedShapes = affectetedShapes.concat(getCityShapesByNeighbourhood(nAffect));
						
						
					}
					
					//remove shapes from the list
					for each (var sc:CityShape in affectetedShapes) {
						sArray.splice(sArray.indexOf(sc),1)
					}
					
								//saving
					highlightedShapes.neighbourhoods = nArray;
					highlightedShapes.shapes = sArray;
				}
					
				
				//sending the event
				eventData.shapes = affectetedShapes;
				this.dispatchEvent(new PipelineEvents(PipelineEvents.CHANGE, eventData));
				
				/*
				trace ("Neighbourhoods Affected: " + affectetedNeighbourhoods.length)
				trace ("Shapes Affected: " + affectetedShapes.length)
				trace ("Update Total Neighbourhoods Highlight: " + nArray.length)
				trace ("Update Total Shapes Highlight: " + sArray.length)
				
				trace ("-------")
				*/
			}
			
		}
		
	}
}