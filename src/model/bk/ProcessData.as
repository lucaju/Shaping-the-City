package model {
	
	//import
	import flash.geom.Point;
	
	public class ProcessData {
		
		//properties
		public const SOURCE_XML:String = "xml";
		public const SOURCE_KML:String = "kml";
		
		private var _source:String;
		private var data:XML;
		private var objectsArray:Array;
		private var geolactedObjectModel:CityShape;
		//private var objectCollection:Sprite;
		
		
		public function ProcessData(_data:XML) {
			
			//default
			data = _data
			source = SOURCE_XML;
			
		}

		public function get source():String {
			return _source;
		}

		public function set source(value:String):void {
			_source = value;
		}
		
		public function getObjects():Array {
			return objectsArray;
		}
		
		public function init():void {
			
			if (source == "xml") {
				processXML();
			} else if (source == "kml") {
				processKML();
			}
		}
		
		private function processKML():void {
			//grab name space
			var namespaces:Array = data.namespaceDeclarations();
			var xmlns:Namespace = namespaces[0];
			default xml namespace = xmlns;
			
			var neighborhoodName:String = data.Document.name;
			
			
			//grab the list of placeMarks
			var placeMarks:XMLList = data.descendants("Placemark");;
			
			//start arra to collect objects
			objectsArray = new Array();
			
			
			//loop
			//var i:int = 0;
			for each(var placeMark:XML in placeMarks) {
				
				
				//accessing coordinates instructions
				var coordinates:String = placeMark.Polygon.outerBoundaryIs.LinearRing.coordinates;
				var coordinatesArray:Array = coordinates.split("            "); //clean ans slipt shape coordinates
				
				//grab the origin
				var originCoord:Array = String(coordinatesArray[0]).split(",")
				var originPoint:Point = new Point(Number(originCoord[0]),Number(originCoord[1])); //create a point
					
				//Grab, clean and save each vector parts
				var vectorParts:Array = new Array();
				
				//create Geolocated Object Model
				geolactedObjectModel = new CityShape(objectsArray.length, originPoint);
			
				//coord loop
				for each (var coord:String in coordinatesArray) {
					
					var coordArray:Array = coord.split(",")
					var coodPoint:Point = new Point(Number(coordArray[0]),Number(coordArray[1])); //create a point
					
					//populate vector parts
					vectorParts.push((coordArray[0]) - originPoint.x);
					vectorParts.push((coordArray[1]) - originPoint.y);
					
					
					//save coords
					geolactedObjectModel.addCoordinate(coodPoint);
				}
				
				//create vector and save the vector
				var v:Vector.<Number> = Vector.<Number>(vectorParts);
				geolactedObjectModel.shape = v;
				
				//add to the list
				objectsArray.push(geolactedObjectModel);
				
				
					
				
			}
		}
		
		private function processXML():void {
			//grab name space
			var namespaces:Array = data.namespaceDeclarations();
			var xmlns:Namespace = namespaces[0];
			default xml namespace = xmlns;
			
			//Cerating a list of Paths
			var vectorsXML:XMLList = data.descendants("path");;
			
			//start arra to collect objects
			objectsArray = new Array();
			
			
			//loop
			//var i:int = 0;
			for each(var path:XML in vectorsXML) {
				
				//accessing attribute: coordenates instructions
				var info:String = path.@d;
				
				//split coordenates instructios by point and put into an array
				var infoParts:Array = info.split(" ");
				
				//get the firt element as origin and remove it from coordenates instructions
				var originString:String = infoParts.shift();
				originString = originString.substring(1); // removing the letter in front of the coordentate
				var originStringArray:Array = originString.split(","); //split coodenate: x,y
				var origin:Point = new Point(Number(originStringArray[0]),Number(originStringArray[1])); //create a point
				
				
				//Grab, clean and save each vector parts
				var vectorParts:Array = new Array();
				
				for each (var infoPart:String in infoParts) {
					
					infoPart = infoPart.substring(1);// removing the letter in front of the coordentate
					
					var infoPartArr:Array = infoPart.split(","); //split coodenate: x,y
					
					//populate vector parts
					vectorParts.push((infoPartArr[0] - origin.x) * 3.5);
					vectorParts.push((infoPartArr[1] - origin.y) * 3.5);
					
				}
				
				//create vector
				var v:Vector.<Number> = Vector.<Number>(vectorParts);
				
				//create Geolocated Object Model
				geolactedObjectModel = new CityShape(objectsArray.length, origin);
				geolactedObjectModel.shape = v;
				
				//add to the list
				objectsArray.push(geolactedObjectModel);

			}
		}
		
	}
}