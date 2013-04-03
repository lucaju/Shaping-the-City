package events{
	
	import flash.events.Event;
	
	public class PipelineEvents extends Event {
		
		public static const FILTER:String = "filter";
		public static const SORT:String = "sort";
		public static const CHANGE:String = "change";
		public static const COMPLETE:String = "complete";
		public static const SELECT:String = "select";
		public static const RESIZE:String = "resize";
		
		public var parameters:Object; 
			
		public function PipelineEvents(type:String,
									   parameters:Object = null,
									   bubbles:Boolean = true,
									   cancelable:Boolean = false) {
		
			super(type, bubbles, cancelable);
			this.parameters = parameters;
		}
		
		public override function clone():Event {
			return new PipelineEvents(type, parameters, bubbles, cancelable);
		}
		
		public override function toString():String {
			return formatToString("PipelineEvent", "type", "parameters", "bubbles", "cancelable", "eventPhase");
		}
			
	}
}