package events{
	
	import flash.events.Event;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PipelineEvents extends Event {
		
		//****************** Properties ****************** ****************** ****************** 
		public static const FILTER					:String = "filter";
		public static const SORT					:String = "sort";
		public static const CHANGE					:String = "change";
		public static const COMPLETE				:String = "complete";
		public static const SELECT					:String = "select";
		public static const RESIZE					:String = "resize";
		
		public var parameters						:Object; 
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param type
		 * @param parameters
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function PipelineEvents(type:String,
									   parameters:Object = null,
									   bubbles:Boolean = true,
									   cancelable:Boolean = false) {
		
			super(type, bubbles, cancelable);
			this.parameters = parameters;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function clone():Event {
			return new PipelineEvents(type, parameters, bubbles, cancelable);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function toString():String {
			return formatToString("PipelineEvent", "type", "parameters", "bubbles", "cancelable", "eventPhase");
		}
			
	}
}