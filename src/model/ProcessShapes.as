package model {
	
	//imports
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ProcessShapes extends AbstractProcessment  {
		
		public function ProcessShapes() {
			name = "cityShapes";
		}
		
		override protected function onComplete(e:Event):void {
			
			var cityShape:CityShape;
			
			data = new Array();
			
			//get data
			var rawData:Object = JSON.parse(e.target.data);
			
			//loop data
			for each (var raw:Object in rawData) {
				cityShape = new CityShape(raw.id, new Point(raw.longitude,-raw.latitude));   //!!!!!!IMPORTANT 1. Longitude = x; Latitude = y; 2. tranform latitute to negative (*don't knwo why yet)
				cityShape.neighbourhood = raw.id_neighbourhhod;
				
				//coordinates
				var coordsPointsArray:Array = new Array();
				
				var coords:String = raw.coordinates;
				var coordsArray:Array = coords.split(" ");
				var pointArray:Array;
				
				for each (var pointString:String in coordsArray) {
					if (pointString != "") {
						pointArray = pointString.split(",");
						coordsPointsArray.push(new Point(pointArray[1],-pointArray[0]));
						pointArray = null;
					}
					
				}

				cityShape.coordinates = coordsPointsArray;
				data.push(cityShape);
				
				coordsPointsArray = null;
				coords = null;
				
			}
			
			cityShape = null;
			
			this.dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
	}
}