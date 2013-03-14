package model {
	
	//imports
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class AbstractProcessment extends EventDispatcher  {
		
		//properties
		public var name:String;
		public var data:Array;
		
		public function AbstractProcessment() {
			
		}
		
		public function loadData(file:String):void {
			
			//---------get list info.
			var url:URLRequest = new URLRequest(file);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.load(url);
			
		}
		
		protected function onComplete(e:Event):void {
			
		}
		
	}
}