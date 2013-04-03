package controller {
	
	//imports
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.CityShape;
	import model.DataModel;
	
	import mvc.AbstractController;
	import mvc.Observable;
	
	public class PipelineController extends AbstractController {
		
		//properties
		private var dataModel:DataModel;
		//private var dataTreesModel:DataTreesModel;
		private var abstractModel:Observable;			//generic model
		
		private var mapProportion:Object;
		
		
		
		/**
		 * 
		 * @param list
		 * 
		 */
		public function PipelineController(list:Array) {
			
			super(list);
			dataModel = DataModel(this.getModel("DataModel"));
			
			//dataTreesModel = DataTreesModel(this.getModel("trees"));
			
		}
		
		/**
		 * 
		 * 
		 */
		public function loadShapeData():void {
			dataModel.loadShapesData();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getShapeCollection():Array {
			var shapeCollection:Array = dataModel.getShapeCollection();
			return shapeCollection;
		}
		
		/**
		 * 
		 * @param receivedData
		 * 
		 */
		public function highlightShapes(receivedData:Object):void {
			
			var affectedNeighbourhoods:Array;
			var source:String = receivedData.param;
			
			//get neighbourhood IDs
			switch(receivedData.type) {
				
				case "community":
					affectedNeighbourhoods = [this.getNeighbourhoodIDByName(receivedData.param)]; //transforming into an array
					break;
				
				case "period":
					var st:String = receivedData.param;
					var ar:Array = st.split(" - ");
					
					var pStart:int = ar[0];
					var pEnd:int = ar[1];
					
					affectedNeighbourhoods = this.getNeighbourhoodIDsByPeriod(pStart,pEnd);
					
					st = null;
					ar = null;
					
					break;
			}
			
			
			//add or remove highlight
			switch (receivedData.action) {
				case true:
					dataModel.addHighlightShapes(affectedNeighbourhoods, receivedData.type, source);
					break;
				
				case false:
					dataModel.removeHighlightedShapes(affectedNeighbourhoods, receivedData.type, source);
					break;
			}
	
		}
		
		//*************** Neighbourhoods ***************
		
		/**
		 * 
		 * 
		 */
		private function loadNeighbourhhods():void {
			dataModel.loadNeigbourhoods();
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getNeighbourhoodInfo(value:String = null):Array {
			if (dataModel.hasNeighbourhoodData) {
				
				var data:Array;
				
				switch(value) {
					
					case "community":
						data = dataModel.getNeighbourhoodNames();
						break;
					
					case "period":
						data = dataModel.getPeriod();
						break;
					
					default:
						data = dataModel.getNeighbourhoods();
						break;
				}
				
				return data;
				
			} else {
				
				loadNeighbourhhods();
				return null;
				
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getNeighbourhoodNames():Array {
			if (dataModel.hasNeighbourhoodData) {
				return dataModel.getNeighbourhoodNames();
			} else {
				loadNeighbourhhods();
				return null;
			}
		}
		
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getNeighbourhoodIDByName(value:String):int {
			return dataModel.getNeighbourhoodIDByName(value);
		}
		
		/**
		 * 
		 * @param pStart
		 * @param pEnd
		 * @return 
		 * 
		 */
		public function getNeighbourhoodIDsByPeriod(pStart:int, pEnd:int):Array {
			return dataModel.getNeighbourhoodIDsByPeriod(pStart,pEnd);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSelectedContent(type:String):Array {
			
			switch(type.toLowerCase()) {
				
				case "community":
					return dataModel.getHighlightedNeighbourhoodsNames();
					break;
				
				case "period":
					return dataModel.getHighlightedPeriods();
					break;
			}
			
			return null;
			
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getHighlightedNeighbourhoods():Array {
			return dataModel.getHighlightedNeighbourhoods();
			
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPeriods():Array {
			if (dataModel.hasNeighbourhoodData) {
				return dataModel.getPeriod();
			} else {
				loadNeighbourhhods();
				return null;
			}
			
		}
		
		
		//****************************** MAP ***********************************************************
		
		/**
		 * 
		 * @param activeArea
		 * @return 
		 * 
		 */
		public function getMapPropportions(activeArea:Rectangle):Object {
			
			if (mapProportion) {
				return mapProportion;
			} else {
				var collection:Array = getShapeCollection();
				
				var lx:Number;
				var ly:Number;
				var lw:Number;
				var lh:Number;
				
				for each (var obj:CityShape in collection) {
					
					for each (var point:Point in obj.coordinates) {
						
						if (!lx) {
							lx = point.x;
							ly = point.y;
							lw = point.x;
							lh = point.y;
						}
						
						if (point.x < lx) {
							lx = point.x;
						}
						
						if (point.y < ly) {
							ly = point.y;
						}
						
						if (point.x > lw) {
							lw = point.x;
						}
						
						if (point.y > lh) {
							lh = point.y;
						}
					}
					
					
				}
				
				
				var o:Point = new Point(lx,ly);
				var rect:Rectangle = new Rectangle(lx,ly,lw-lx,lh-ly);
				
				var rx:Number = activeArea.width / (rect.width);
				var ry:Number = activeArea.height / (rect.height);
				
				var r:Number = Math.min(rx,ry);
	
				var results:Object = new Object();
				results.rate = r;
				results.origin = o;
				
				mapProportion = results;
				
				return mapProportion;
			}
			
		}
		/*
		public function getTreePropportions():Object {
			var collection:Array = getTrees();
			
			
			var lx:Number;
			var ly:Number;
			var lw:Number;
			var lh:Number;
			
			for each (var obj:TreeModel in collection) {
				
					
				if (!lx) {
					lx = obj.longitude;
					ly = obj.latitude;
					lw = obj.longitude;
					lh = obj.latitude;
				}
				
				if (obj.longitude < lx) {
					lx = obj.longitude;
				}
				
				if (obj.latitude < ly) {
					ly = obj.latitude;
				}
				
				if (obj.longitude > lw) {
					lw = obj.longitude;
				}
				
				if (obj.latitude > lh) {
					lh = obj.latitude;
				}
				
			}
			
			var o:Point = new Point(lx,ly);
			var rect:Rectangle = new Rectangle(lx,ly,lw-lx,lh-ly);
			
			//1100
			//800
			
			var rx:Number = 1000 / (rect.width);
			var ry:Number = 700 / (rect.height);
			
			var r:Number = Math.min(rx,ry)
			
			
			var results:Object = new Object();
			results.rate = r;
			results.origin = o;
			
			//trace (lx, ly)
			
			return results;
			
		}
		
	
		public function loadTrees():void {
			if (!dataTreesModel.hasData()) {
				dataTreesModel.load();
			}
		}
		
		public function getTrees():Array {
			if (dataTreesModel.hasData()) {
				return dataTreesModel.getTrees();
			}
			
			return null;
		}
		*/
	}
}