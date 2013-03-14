package mvc {
	
	//imports
	import mvc.IObserver;
	import flash.events.EventDispatcher;
	
	/**
	 * A Java-style Observable class used to represent the "subject"
	 * of the Observer design pattern. Observers must implement the Observer
	 * interface, and register to observe the subject via addObserver().
	 */
	public class Observable extends EventDispatcher{
		
		private var _name:String;
		
		private var changed:Boolean = false;			// A flag indicating whether this object has changed.
		
		private var observers:Array;					// A list of observers.
		
		/**
		 * Constructor function.
		 */
		public function Observable () {
			observers = new Array();
		}
		
		/**
		 * Define the name of the controller
		 * 
		 * @param	value - String
		 **/
		public function set name(value:String):void {
			if (!_name) {
				_name = value;
			}
		}
		
		/**
		* Return the name of the controller
		**/
		public function get name():String {
			return _name;
		}
		
		/**
		 * Adds an observer to the list of observers.
		 * @param   o   The observer to be added.
		 */
		public function addObserver(o:IObserver):Boolean {
			// Can't add a null observer.
			if (o == null) {
				return false;
			}
			
			// Don't add an observer more than once.
			for (var i:Number = 0; i < observers.length; i++) {
				if (observers[i] == o) {
					// The observer is already observing, so quit.
					return false;
				}
			}
			
			// Put the observer into the list.
			observers.push(o);
			o.setReg(observers.length);
			return true;
		}
		
		/**
		 * Removes an observer from the list of observers.
		 *
		 * @param   o   The observer to remove.
		 */
		public function removeObserver(o:IObserver):Boolean {
			// Find and remove the observer.
			var len:Number = observers.length;
			for (var i:Number = 0; i < len; i++) {
				if (observers[i] == o) {
					observers.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Tell all observers that the subject has changed.
		 *
		 * @param   infoObj   An object containing arbitrary data 
		 *                    to pass to observers.
		 */
		public function notifyObservers(infoObj:Object, targetReg:int = 0):void {
			// Use a null infoObject if none is supplied.
			if (infoObj == null) {
				infoObj = null;
			}
			
			// If the object hasn't changed, don't bother notifying observers.
			if (!changed) {
				return;
			}
			
			// Make a copy of the observers array. We do this
			// so that we can be sure the list won't change while
			// we're processing it.
			var observersSnapshot:Array = observers.slice(0);
			
			// This change has been processed, so unset the "changed" flag.
			clearChanged();
			
			// Invoke update() specific for one observer or to all of them
			if (targetReg > 0) {
				for each(var target:IObserver in observersSnapshot) {
					if (target.getReg() == targetReg) {
						target.update(this, infoObj);		
					}
				}
				
			} else {
				for (var i:Number = observersSnapshot.length-1; i >= 0; i--) {
					observersSnapshot[i].update(this, infoObj);
				}
			}
		}
		
		/**
		 * Removes all observers from the observer list.
		 */
		public function clearObservers():void {
			observers = new Array();
		}
		
		/**
		 * Indicates that the subject has changed.
		 */
		public function setChanged():void {
			changed = true;
		}
		
		/**
		 * Indicates that the subject has either not changed or
		 * has notified its observers of the most recent change.
		 */
		private function clearChanged():void {
			changed = false;
		}
		
		/**
		 * Checks if the subject has changed.
		 *
		 * @return   true if the subject has changed, as determined by setChanged().
		 */
		public function hasChanged():Boolean {
			return changed;
		}
		
		/**
		 * Returns the number of observers in the observer list.
		 *
		 * @return   An integer: the number of observers for this subject.
		 */
		public function countObservers():Number {
			return observers.length;
		}
	}
}