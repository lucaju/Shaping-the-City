package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.events.Event;
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
		protected var activeArea		:Rectangle;
		protected var shapeCollection	:Array;
		protected var blockShape		:BlockShape;
		protected var highlightedShapes	:Array;
		protected var proportion		:Object;
		
		
		
		/**
		 * Contructor. MapView extends AbstractView, which requires an IController as parameter. In this case, it will be the PipelineController.
		 *  <p>It also initiate shapeCollection</>
		 * @param c
		 * 
		 */
		public function MapView(c:IController) {
			super(c);
			
			shapeCollection = new Array();
		}
		
		//****************** GETTERS ****************** ****************** ****************** 
		
		/**
		 * GetShapes. Return the shape collection 
		 * 
		 * @return:Array 
		 * 
		 */
		public function getShapes():Array {
			return shapeCollection.concat();;
		}
		
		/**
		 * Get Shape by ID. Returns the BlockShape that matches the parameter
		 *  
		 * @param value:int
		 * @return:BlockShape
		 * 
		 */
		public function getShapeById(value:int):BlockShape {
			for each (var b:BlockShape in shapeCollection) {
				if (b.id == value) {
					return b;
					break;
				}
			}
			
			return null;
		}
		
		
		//****************** SETTERS ****************** ****************** ****************** 
		
		/**
		 * SetProportion. Save the proportion between the map and the screen to a variable
		 * 
		 * @param value:Object
		 * 
		 */
		public function setProportion(value:Object):void {
			proportion = value;
		}
		
		/**
		 * SetActiveArea. Save the active area size to a variable.
		 * 
		 * @param value:Rectangle
		 * 
		 */
		public function setActiveArea(value:Rectangle):void {
			activeArea = value;
		}
		
		//****************** INIT ****************** ****************** ****************** 
		
		/**
		 * INIT. Initiate the MapView.
		 * <p>Add a listernet to wait for the data when it become available</p> 
		 * 
		 */
		public function init():void {
			
			var control:PipelineController = PipelineController(this.getController());
			var dataModel:DataModel = DataModel(control.getModel("DataModel"));
			dataModel.addEventListener(PipelineEvents.COMPLETE, onLoad);
			dataModel.addEventListener(PipelineEvents.CHANGE, onChange);
			control.loadShapeData();

		}
		
		//****************** PRIVATE METHODS  ****************** ****************** ****************** 
		
		/**
		 * Back to Origin. It animatte the shapes back to the original GPS location.
		 * 
		 */
		private function backToOrigin():void {
			
			var random:Number = Math.random();
			
			for each (var object:BlockShape in shapeCollection) {
				TweenMax.to(object,2,{x:object.location.x,y:object.location.y,delay:2 * random});
			}
			
			TweenMax.to(this,2,{scaleX:1, scaleY:1,delay:2 * random});
			
		}
		
		private function addHighlightShapes(shapesToAdd:Array):void {
			
			if (!highlightedShapes) {
				highlightedShapes = new Array();
			}
			
			//check for duplicates
			if (highlightedShapes.length > 0) {
				for each (var s:CityShape in shapesToAdd) {
					for each (var b:BlockShape in highlightedShapes) {
						if (s.id == b.id) {
							shapesToAdd.splice(shapesToAdd.indexOf(s),1)
						}
					}
				}
			}
			
			//add to the list
			for each (var cs:CityShape in shapesToAdd) {
				highlightedShapes.push(getShapeById(cs.id));
			}
			
			highlightAnimation();
			
		}
		
		private function highlightAnimation():void {
			
			for each (var b:BlockShape in highlightedShapes) {
				TweenMax.to(b,.5,{tint:0xF15A24});
			}
				
		}
		
		//****************** EVENT HANDLES  ****************** ****************** ****************** 
		
		/**
		 * onLoad. Treat the data.
		 * <p>It call for calculate proportion method in the Controller<p/>
		 * <p>Create and position the shapes</p>
		 * <p>Add listener to ZOOM and PAN interaction</p>
		 * @param e:PipelineEvents
		 * 
		 */
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
		
		protected function onChange(event:PipelineEvents):void {
			
			if (event.parameters.type == "highlight") {
				if (event.parameters.action == "add") {
					addHighlightShapes(event.parameters.data);
				}
			}
			
			//trace (event.parameters.type);
			//trace (event.parameters.action);
			//trace (event.parameters.data);
			
		}
		
		/**
		 * OnGesturePan. Move the map when the user make the two-fingers pan gesture.
		 * <p>Set the inverse moviment for iPhone logic</p>
		 * 
		 * @param event:TransformGestureEvent
		 * 
		 */
		protected function onGesturePan(event:TransformGestureEvent):void {
			
			if (DeviceInfo.os() != "Mac") {
				this.x += event.offsetX;
				this.y += event.offsetY;
			} else {
				this.x -= event.offsetX;
				this.y -= event.offsetY;
			}
			
		}
		
		/**
		 *  onGestureZoom. Zoom the map when the user make the two-finger pinch gesture.
		 * 
		 * @param event:TransformGestureEvent
		 * 
		 */
		protected function onGestureZoom(event:TransformGestureEvent):void {
			this.scaleX *= event.scaleX
			this.scaleY *= event.scaleY
			
		}
		
		//****************** PUBLIC METHODS  ****************** ****************** ****************** 
		
		/**
		 * Animation. Just a fun scale animation. Turno on and off.
		 * 
		 * @param swither:Boolean
		 * 
		 */
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
		
		
		/**
		 * Sort. This method sort the shapes. You can turn on and off and choose how the shapes will be sorted.
		 * <p>Default: "size"</p>
		 *  
		 * @param swither:Boolean
		 * @param by:String
		 * 
		 */
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
			
				backToOrigin();
			}
		}
		
		
		
		
		
		
	}
}