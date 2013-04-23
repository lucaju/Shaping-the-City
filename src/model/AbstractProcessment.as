package model {
	
	//imports
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractProcessment extends EventDispatcher  {
		
		//****************** Properties ****************** ****************** ****************** 
		public var name				:String;
		public var data				:Array;
		
		
		//****************** PUBLIC FUNCTIONS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param file
		 * 
		 */
		public function loadData(file:String):void {
			var url:URLRequest = new URLRequest(file);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.load(url);
		}
		
		
		//****************** PROTECTED FUNCTIONS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onComplete(e:Event):void {
			
		}
		
	}
}