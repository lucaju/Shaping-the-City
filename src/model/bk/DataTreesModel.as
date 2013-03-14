package model {
	
	//imports
	import events.PipelineEvents;
	
	import flash.events.Event;
	
	import mvc.Observable;
	
	public class DataTreesModel extends Observable {
		
		//properties
		private var data:Array;
		
		public function DataTreesModel() {
			super();
			
			//define name
			this.name = "trees";
			
		}
		
		
		public function hasData():Boolean {
			return data ? true : false;
		}
		
		public function load():void {
			var pT:ProcessDataTrees = new ProcessDataTrees();
			pT.addEventListener(Event.COMPLETE, processComplete);
			pT = null;
		}
		
		private function processComplete(e:Event):void {
			
			//trace (e.target.data)
			
			data = e.target.data;
			
			var obj:Object = {data:data}
			
			//this.notifyObservers(obj);
			this.dispatchEvent(new PipelineEvents(PipelineEvents.COMPLETE,obj));
			
		}
		
		public function getTrees():Array {
			return data.concat();
		}
	}
}