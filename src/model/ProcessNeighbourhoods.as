package model {
	
	//imports
	import flash.events.Event;
	
	public class ProcessNeighbourhoods extends AbstractProcessment  {
		
		//properties
		
		
		public function ProcessNeighbourhoods() {
			name = "neighbourhoods";	
		}
		
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