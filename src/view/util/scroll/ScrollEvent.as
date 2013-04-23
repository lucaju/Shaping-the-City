package view.util.scroll{
	
	//imports
	import flash.events.Event;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ScrollEvent extends Event {
		
		//****************** Properties ****************** ****************** ****************** 
		
		public static const SCROLL					:String = "scroll";
		public static const INERTIA					:String = "inertia";
		
		public var phase							:String;
		public var targetX							:Number; 
		public var targetY							:Number; 
		public var speedX							:Number;
		public var speedY							:Number;
			
		
		//****************** Properties ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param type
		 * @param phase
		 * @param targetX
		 * @param targetY
		 * @param speedX
		 * @param speedY
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function ScrollEvent(type:String,
									   phase:String = "",
									   targetX:Number = 0,
									   targetY:Number = 0,
									   speedX:Number = 0,
									   speedY:Number = 0,
									   bubbles:Boolean = true,
									   cancelable:Boolean = false) {
		
			super(type, bubbles, cancelable);
			this.phase = phase;
			this.targetX = speedX;
			this.targetY = speedY;
			this.speedX = speedX;
			this.speedY = speedY;
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function clone():Event {
			return new ScrollEvent(type, phase, speedX, speedY, targetX, targetY, bubbles, cancelable);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function toString():String {
			return formatToString("ScrollEvent", "type", "phase", "targetX", "targetY", "speedX", "speedY", "bubbles", "cancelable", "eventPhase");
		}
			
	}
}