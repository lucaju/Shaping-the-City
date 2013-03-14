package model {
	
	//import
	//imports
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ProcessDataTrees extends EventDispatcher {
		
		//properties
		private var url:URLRequest;
		private var urlLoader:URLLoader;
		
		public var data:Array;
		
		
		public function ProcessDataTrees() {
			
			//---------get list info.
			url = new URLRequest("/resource/csv/trees_full.csv");
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress)
			urlLoader.load(url);
			
		}
		
		private function onProgress(e:ProgressEvent):void {
			trace (e.bytesLoaded + " / " + e.bytesTotal + " (" + (e.bytesLoaded * 100) / e.bytesTotal + ")")
		}

		private function onComplete(e:Event):void {
			
			var csvData:String = e.target.data;
			
			var csvArray:Array = csvData.split("\n");
			
			//init loop
			data = new Array();;
			var tree:TreeModel;
			
			
			for each (var csvItem:String in csvArray) {
				
				var csvItemArray:Array = csvItem.split(",");
				
				//trace ("id: " + csvItemArray[0] + " || latitude: " + csvItemArray[1] + " || longitue: " + csvItemArray[2] +" || date: " + csvItemArray[3] + " || diameter: " + csvItemArray[4] + " || condition: " + csvItemArray[5]+ " || neighbourhood: " + csvItemArray[6] + "|| owner: " + csvItemArray[7] + " || type: " + csvItemArray[8] + " || species: " + csvItemArray[9] + "," + csvItemArray[10])
			
				//location
				var p:Point = new Point(csvItemArray[2],csvItemArray[1]);

				//create new tree
				tree = new TreeModel(csvItemArray[0], p);
				
				//date
				var date:Date;
				
				if (csvItemArray[1] == "-") {
					var itemDateString:String = csvItemArray[3];
					var itemDateArray:Array = itemDateString.split("-");
					
					date = new Date(itemDateArray[0],itemDateArray[1],itemDateArray[2])
					
					tree.date = date;		
				};
				
				
				//other stuff
				tree.diameter = csvItemArray[4];
				tree.condition = csvItemArray[5];
				tree.neighbourhood = csvItemArray[6];
				tree.owner = csvItemArray[7];
				tree.type = csvItemArray[8];
				
				//species
				var s:String = csvItemArray[9];
				if (csvItemArray[10]) {
					s += csvItemArray[10]
				}
				tree.species = s;
				
				data.push(tree);
				
			}
			
			url = null;
			urlLoader = null;
			tree = null;
			
			this.dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
	}
}