package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.PipelineController;
	
	import events.PipelineEvents;
	
	import model.CityShape;
	import model.DataModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	import util.DeviceInfo;
	
	public class MapView extends AbstractView {
		
		//properties
		private var activeArea:Rectangle;
		private var shapeCollection:Array;
		private var blockShape:BlockShape;
		private var proportion:Object;
		
		public function MapView(c:IController) {
			super(c);
			
			shapeCollection = new Array();
		}
		
		public function init():void {
			
			var control:PipelineController = PipelineController(this.getController());
			var dataModel:DataModel = DataModel(control.getModel("DataModel"));
			dataModel.addEventListener(PipelineEvents.COMPLETE, onLoad);
			control.loadShapeData();

		}
		
		private function onLoad(e:PipelineEvents):void {
			
			if (e.parameters.type == "cityShapes") {
				
				var data:Array = e.parameters.data;
				
				//get proportions
				proportion = PipelineController(this.getController()).getMapPropportions(activeArea);
				
				
				//loop
				var i:int = 0;
				
				for each (var cityShape:CityShape in data) {
				
					var origin:Point = proportion.origin;
					var scale:Number = proportion.rate;
					
					if (cityShape.location.x != 0) {
						i++;
						
						blockShape = new BlockShape(cityShape.id, scale);
						this.addChild(blockShape);
						
						blockShape.trueLocation = cityShape.location;
						blockShape.x = (cityShape.location.x - origin.x) * scale;
						blockShape.y = (cityShape.location.y - origin.y) * scale;
						
						blockShape.location = new Point(blockShape.x, blockShape.y);
						
						shapeCollection.push(blockShape);
						
						blockShape.drawShape(cityShape.coordinates);
						
						//blockShape.cacheAsBitmapMatrix = blockShape.transform.concatenatedMatrix; 
						//blockShape.cacheAsBitmap = true;
						
						//TweenMax.from(blockShape,1,{alpha:0, delay:0.005*i});
						//TweenMax.from(blockShape,Math.random()*20,{alpha:0, delay:0.1*i*Math.random()});
						//TweenMax.from(blockShape,1,{z:1000, rotation: 90, alpha:0,delay:0.01*i});
						//TweenMax.from(blockShape,10 + (Math.random() * 10),{scaleX: 1 + Math.random(),scaleY: 1 + Math.random(), alpha: .1 + (Math.random() / 2), yoyo:true, repeat:-1});
						
					}
					
					
				}
				
				this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onGestureZoom);
				this.addEventListener(TransformGestureEvent.GESTURE_PAN, onGesturePan);
			}
			
		}
		
		protected function onGesturePan(event:TransformGestureEvent):void {
			
			trace (event.target)
			trace (event.currentTarget)
			trace ("-------")
			if (DeviceInfo.os() != "Mac") {
				this.x += event.offsetX;
				this.y += event.offsetY;
			} else {
				this.x -= event.offsetX;
				this.y -= event.offsetY;
			}
			
		}
		
		protected function onGestureZoom(event:TransformGestureEvent):void {
			this.scaleX *= event.scaleX
			this.scaleY *= event.scaleY
			
		}
		
		public function setProportion(value:Object):void {
			proportion = value;
		}
		
		public function setActiveArea(value:Rectangle):void {
			activeArea = value;
		}
		
		public function animation(swither:Boolean):void {
			
			var object:BlockShape;
			
			if (swither) {
				for each (object in shapeCollection) {
					TweenMax.to(object,10 + (Math.random() * 10),{scaleX: 1 + Math.random(),scaleY: 1 + Math.random(), alpha: .1 + (Math.random() / 2), yoyo:true, repeat:-1});
				}
				
			} else {
				TweenMax.to(shapeCollection,1,{scaleX:1,scaleY:1, alpha: .4});
			}
			
		}
		
		public function sort(swither:Boolean, by:String = "size"):void {
			
			TweenMax.killChildTweensOf(this);
			
			if (swither) {
			
				var posX:Number = 0;
				var posY:Number = 0;
				var alt:Number = 0;
				
				if (by == "size") {
					shapeCollection.sortOn("surface", Array.NUMERIC);
				}
				
				var random:Number = Math.random();
				TweenMax.to(this,2,{scaleX:.7, scaleY:.7,delay:2 * random});
				
				for each (var object:BlockShape in shapeCollection) {
					
					//i++;
					
					TweenMax.to(object,2,{scaleX:1,scaleY:1, x:posX,y:posY,delay:2 * random});
					
					posX += object.width;
					
					if (alt < object.height) {
						alt = object.height + 1;
					}
					
					//if (posX > stage.width) {
					if (posX >1440) {
						posY += alt + 1;
						posX = 0;
						alt = 0;
					}
					
				}
				
			} else {
			
				_backToOrigin();
			}
		}
		
		
		private function _backToOrigin():void {
			
			var random:Number = Math.random();
			
			for each (var object:BlockShape in shapeCollection) {
				TweenMax.to(object,2,{x:object.location.x,y:object.location.y,delay:2 * random});
			}
			
			TweenMax.to(this,2,{scaleX:1, scaleY:1,delay:2 * random});
			
		}
		
		
		public function getShapes():Array {
			return shapeCollection.concat();;
		}
		
	}
}