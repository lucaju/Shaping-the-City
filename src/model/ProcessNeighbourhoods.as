package model {
	
	//imports
	import flash.events.Event;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ProcessNeighbourhoods extends AbstractProcessment  {
		
		//****************** Properties ****************** ****************** ****************** 
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * 
		 * 
		 */
		public function ProcessNeighbourhoods() {
			name = "neighbourhoods";	
		}
		
		
		//****************** PROTECTED FUNCTIONS ****************** ****************** ****************** 
		
		override protected function onComplete(e:Event):void {
			
			data = new Array();
			
			var neighbourhood:Neighbourhood;
			
			//get data
			var rawData:Object = JSON.parse(e.target.data);
			
			//loop data
			for each (var raw:Object in rawData) {
				neighbourhood = new Neighbourhood(new Number(raw.id));
				neighbourhood.name = raw.name;
				neighbourhood.period = raw.period;
				
				data.push(neighbourhood);
			}
			
			this.dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
	}
}