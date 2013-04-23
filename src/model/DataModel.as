package model {
	
	//imports
	import flash.events.Event;
	
	import events.PipelineEvents;
	
	import mvc.Observable;
	import settings.Settings;
	
	/**
	 * This Class manage all data related to the map.
	 *  
	 * @author lucaju
	 * 
	 */
	public class DataModel extends Observable {
		
		//****************** Properties ****************** ****************** ****************** 
		
		protected var shapeCollection				:Array;						//Holds Shape Collection
		protected var neighbourhoodCollection		:Array;						//Holds Neighbourhood Collection
		protected var highlightedShapes			:HighlightedShapes;			//Holds Highlight Information: Type, and Periods, Neighbourhoods and Shapes affected.
		protected var serverPath					:String;
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * Construct Data Model. Set model name. 
		 * 
		 */
		public function DataModel() {
			super();
			
			//define name
			this.name = "DataModel";
			
			if (Settings.server == "local") {
				serverPath = "http://localhost:8888/pipeline/shapingcity/php/";
			} else {
				serverPath = "http://labs.fluxo.art.br/pipeline/shapingcity/php/"
			}
			
		}
		
		//****************** LOADS ****************** ****************** ****************** 
				
		/**
		 * 
		 * 
		 */
		public function loadShapesData():void {
			if (!hasShapesData) {
				var processShapes:ProcessShapes = new ProcessShapes();
				processShapes.addEventListener(Event.COMPLETE, processComplete);
				processShapes.loadData(serverPath+"getShapes.php?phase="+Settings.projectPhase);
				processShapes = null;
			}
			//load Neighbourhoods
			loadNeigbourhoods();
		}
		
		/**
		 * 
		 * 
		 */
		public function loadNeigbourhoods():void {
			if (!hasNeighbourhoodData) {
				var processNeighbourhoods:ProcessNeighbourhoods = new ProcessNeighbourhoods();
				processNeighbourhoods.addEventListener(Event.COMPLETE, processComplete);
				processNeighbourhoods.loadData(serverPath+"getNeighbourhoods.php?phase="+Settings.projectPhase);
				processNeighbourhoods = null;
			}
		}
		
		//****************** LOADS PROCESSING ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param e
		 * 
		 */
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
		
		
		//****************** SHAPE METHODS****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hasShapesData():Boolean {
			return shapeCollection ? true : false;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getShapeCollection():Array {
			return shapeCollection.concat();
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getCityShapeByID(value:int):CityShape {
			for each (var s:CityShape in shapeCollection) {
				if (s.id == value) {
					return s;
					break;
				}
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getCityShapesByNeighbourhood(value:int):Array {
			
			var sArray:Array = new Array();
			
			for each (var s:CityShape in shapeCollection) {
				if (s.neighbourhood == value) {
					sArray.push(s);
				}
			}
			
			return sArray;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getShapeInfo(value:int):Object {
			for each (var s:CityShape in shapeCollection) {
				if (s.id == value) {
					
					var n:Neighbourhood = getNeighbourhoodByID(s.neighbourhood);
						
					var info:Object = new Object();
					
					info.neighbourhood = n.name;
					info.period = n.period;
					
					n = null;
					
					return info;
					
					break;
				}
			}
			return null;
		}
		
		
		//****************** NEIGHBOURHOOD METHODS****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hasNeighbourhoodData():Boolean {
			return neighbourhoodCollection ? true : false;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getNeighbourhoods():Array {
			return neighbourhoodCollection.concat();
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getNeighbourhoodByID(value:int):Neighbourhood {
			
			for each (var n:Neighbourhood in neighbourhoodCollection) {
				if (n.id == value) {
					return n;
					break;
				}
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getNeighbourhoodByName(value:String):Neighbourhood {
			
			for each (var n:Neighbourhood in neighbourhoodCollection) {
				if (n.name == value) {
					
					//check it saves shapes
					if (!n.shapes) {
						n.shapes = getCityShapesByNeighbourhood(n.id);
					}

					return n;
					
				}
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getNeighbourhoodIDByName(value:String):int {
			for each (var n:Neighbourhood in neighbourhoodCollection) {
				if (n.name.toLowerCase() == value.toLowerCase()) {
					return n.id;
					break;
				}
			}
			return null;
		}
		
		/**
		 * 
		 * @param pStart
		 * @param pEnd
		 * @return 
		 * 
		 */
		public function getNeighbourhoodIDsByPeriod(pStart:int, pEnd:int):Array {
			
			var nArray:Array = new Array();
			
			for each (var n:Neighbourhood in neighbourhoodCollection) {
				if (n.period >= pStart && n.period <= pEnd) {
					nArray.push(n.id);
				}
			}
			
			return nArray;
		}
		
		/**
		 * 
		 * @param pStart
		 * @param pEnd
		 * @return 
		 * 
		 */
		public function getNeighbourhoodsByPeriod(pStart:int, pEnd:int):Array {
			
			var nArray:Array = new Array();
			
			for each (var n:Neighbourhood in neighbourhoodCollection) {
				if (n.period >= pStart && n.period <= pEnd) {
					
					//check it saves shapes
					if (!n.shapes) {
						n.shapes = getCityShapesByNeighbourhood(n.id);
					}
					
					nArray.push(n);
				}
			}
			
			return nArray;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getNeighbourhoodNames():Array {
			var nArray:Array = neighbourhoodCollection.concat();;
			nArray.sortOn("name");
			
			var names:Array = new Array;
			
			for each (var n:Neighbourhood in nArray) {
				names.push(n.name);
			}
			
			nArray = null;
			return names;
		}
		
		
		
		//****************** PERIODS METHODS****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPeriod():Array {
			var nArray:Array = neighbourhoodCollection.concat();;
			nArray.sortOn("period",Array.UNIQUESORT);
			
			var periods:Array = new Array;
			
			for each (var n:Neighbourhood in nArray) {
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
			
			nArray = null;
			return periods;
		}
		
		
		//****************** HIGHLIGHTED METHODS****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSelectedContentType():String {
			if (highlightedShapes) {
				return highlightedShapes.type; //Problem... Have to reset highlightedShapes after clean the selection
			}
			
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getHighlightedNeighbourhoods():Array {
			
			if (highlightedShapes) {
				return highlightedShapes.neighbourhoods;
			}
			
			return null;
			
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getHighlightedPeriods():Array {
			
			if (highlightedShapes) {
				return highlightedShapes.periods;
			}
			
			return null;
			
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getHighlightedNeighbourhoodsNames():Array {
			
			if (highlightedShapes) {	
				var nNames:Array = new Array();
					
				for each (var n:Neighbourhood in highlightedShapes.neighbourhoods) {
					nNames.push(n.name);
				}
					
				return nNames;
				
			}
			
			return null;
	
		}
		
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getHighlightedShapes(value:String):Array {
			
			var shapes:Array = new Array();
			
			var nId:int = this.getNeighbourhoodIDByName(value);
			
			if (highlightedShapes) {
				
				for each (var cs:CityShape in highlightedShapes.shapes) {
					if (cs.neighbourhood == nId) {
						shapes.push(cs);	
					}
					
				}
				
				return shapes;
				
			}
			
			return null;
			
		}
		
		/**
		 * 
		 * @param data
		 * @param type
		 * @param source
		 * 
		 */
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
			
			
			//output
			if (Settings.debug) {
				/*trace ("Action: "+ eventData.action);
				trace ("Type: " + eventData.type);
				trace ("Method: " + eventData.method);
				trace ("Reset: " + eventData.reset);
				trace ("Request Neighbourhoods: " + affectetedNeighbourhoods.length + " - " + affectetedNeighbourhoods);
				trace ("Current Total Neighbourhoods Highlight: " + nArray.length);
				trace ("Current Total Shapes Highlight: " + sArray.length);*/
			}
			
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
			
			//output
			if (Settings.debug) {
				/*trace ("Neighbourhoods Affected: " + affectetedNeighbourhoods.length)
				trace ("Shapes Affected: " + affectetedShapes.length)
				trace ("Update Total Neighbourhoods Highlight: " + nArray.length)
				trace ("Update Total Shapes Highlight: " + sArray.length)
				
				trace ("-------")*/
			}
		}
		
		/**
		 * 
		 * @param data
		 * @param type
		 * @param source
		 * 
		 */
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
				
				if (type == "period") {
					highlightedShapes.removePeriod(source)
				}
				
				//output
				if (Settings.debug) {
					/*trace ("Action: "+ eventData.action);
					trace ("Type: " + eventData.type);
					trace ("Method: " + eventData.method);
					trace ("Reset: " + eventData.reset);
					trace ("Request Neighbourhoods: " + affectetedNeighbourhoods.length + " - " + affectetedNeighbourhoods)
					trace ("Current Total Neighbourhoods Highlight: " + nArray.length)
					trace ("Current Total Shapes Highlight: " + sArray.length)*/
				}
				
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
				
				
				//reset highlightShapes if not shape is highlighted
				if (highlightedShapes.shapes.length == 0) {
					highlightedShapes.clean();
				}
				
				//sending the event
				eventData.shapes = affectetedShapes;
				this.dispatchEvent(new PipelineEvents(PipelineEvents.CHANGE, eventData));
				
				//output
				if (Settings.debug) {
					/*trace ("Neighbourhoods Affected: " + affectetedNeighbourhoods.length)
					trace ("Shapes Affected: " + affectetedShapes.length)
					trace ("Update Total Neighbourhoods Highlight: " + nArray.length)
					trace ("Update Total Shapes Highlight: " + sArray.length)
					
					trace ("-------")*/
				}
			}
			
		}
		
	}
}