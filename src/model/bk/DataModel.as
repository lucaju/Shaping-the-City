package model {
	
	//imports
	import events.PipelineEvents;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mvc.Observable;
	
	public class DataModel extends Observable {
		
		//properties
		private var shapeCollection:Array;			//Collection
		private var urlLoader:URLLoader;
		private var urlRequest:URLRequest;
		private var dataSourceType:String;
		private var processData:ProcessShapes;
		
		public function DataModel() {
			super();
			
			//define name
			this.name = "data";
			
			//init
			//define data source
			dataSourceType = "kml";	//XML or KML
			loadData(initData()) 
		}
		
		private function initData():Array {
			var data:Array;
			
			if (dataSourceType == "xml") {
				data = ["full_city.xml"];
			} else {
				data = ["Empire_Park.kml"];
			}
				
			return data;
		}
				
		private function loadData(dataSources:Array):void {
			
			urlRequest = new URLRequest();
			
			urlRequest.url = "resource/" + dataSourceType + "/" + dataSources[0];
			
			
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, parseData);
			urlLoader.load(urlRequest);	
			
		}
		
		private function parseData(e:Event):void {
			//data process
			var dataXML:XML = XML(e.target.data);
			
			trace (data)
			
			processData = new ProcessShapes(dataXML);
			processData.source = dataSourceType;
			processData.init();
			
			//get results
			//shapeCollection = new Array();
			shapeCollection = processData.getObjects();
			
			var data:Object = {data:shapeCollection.concat()};
			
			this.dispatchEvent(new PipelineEvents(PipelineEvents.COMPLETE,data));
		}
		
		public function getShapeCollection():Array {
			return shapeCollection.concat();
		}
	}
}