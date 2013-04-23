package view {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.TweenProxy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.PipelineController;
	
	import events.PipelineEvents;
	
	import model.CityShape;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import settings.Settings;
	
	import util.DeviceInfo;
	
	import view.explode.ExplodeInfoView;
	import view.util.scroll.Scroll;
	import view.util.zoom.ZoomModule;
	
	/**
	 * MapViw
	 * <p>This class is the active sprite where all the shapes are organized.</p>
	 *  
	 * @author lucaju
	 * 
	 */
	public class MapView extends AbstractView {
		
		//****************** Properties ****************** ****************** ****************** 
		protected var activeArea			:Rectangle;					//Keep the active map view windows dimensions. 
		protected var proportion			:Object;					//Keep the propoportions between the map and the screen.
		
		protected var shapeCollection		:Array;						//Collection of all shapes on the map.
		protected var highlightedShapes		:Array;						//Collection of all highlighted shapes on the map.
		protected var ignoredShapes			:Array;						//Collection of all ignored shapes on the map.
		
		protected var selectedShape			:BlockShape;				//hold the selected shape
		
		protected var exploded				:Boolean = false;
		
		protected var scroll				:Scroll;
		protected var scrolledArea			:Sprite;
		protected var shapeContainer		:Sprite;
		protected var containerMask			:Sprite;
		
		protected var zoomControl			:ZoomModule;
		
		//****************** Constructor ****************** ****************** ****************** 
		/**
		 * Contructor. MapView extends AbstractView, which requires an IController as parameter. In this case, it will be the PipelineController.
		 *  <p>It also initiate shapeCollection</>
		 * @param c
		 * 
		 */
		public function MapView(c:IController) {
			super(c);
			
			shapeCollection = new Array();
			
			shapeContainer = new Sprite();
			this.addChild(shapeContainer);
		}
		
		
		//****************** INITIALIZE ****************** ****************** ****************** 
		
		/**
		 * INIT. Initiate the MapView.
		 * <p>Add a listernet to wait for the data when it become available</p> 
		 * 
		 */
		public function init():void {	
			
			//listeners
			this.getController().getModel("DataModel").addEventListener(PipelineEvents.COMPLETE, onLoad);
			this.getController().getModel("DataModel").addEventListener(PipelineEvents.CHANGE, onChange);
			
			//load Shapes
			PipelineController(this.getController()).loadShapeData();

			//background
			this.graphics.beginFill(0xFFFFFF,0);
			this.graphics.drawRect(0,0,this.activeArea.width,this.activeArea.height);
			this.graphics.endFill();
			
		}
		
		
		//****************** EVENT - INITIALIZATION ****************** ****************** ******************
		
		/**
		 * onLoad. Build the map.
		 * <p>It calls for calculate proportion method in the Controller<p/>
		 * <p>Create and position the shapes</p>
		 * <p>Add listener to ZOOM and PAN interaction</p>
		 * 
		 * @param e:PipelineEvents
		 * 
		 */
		private function onLoad(e:PipelineEvents):void {
			
			if (e.parameters.type == "cityShapes") {
				
				//remove listener
				e.target.removeEventListener(PipelineEvents.COMPLETE, onLoad);
				
				//data
				var data:Array = e.parameters.data;
				
				//get proportions
				proportion = PipelineController(this.getController()).getMapPropportions(activeArea);
				
				//loop
				var i:int = 0;
				var blockShape:BlockShape;
				
				for each (var cityShape:CityShape in data) {
					
					var origin:Point = proportion.origin;
					var scale:Number = proportion.rate;
					
					if (cityShape.location.x != 0) {
						i++;
						
						blockShape = new BlockShape(cityShape.id, scale);
						shapeContainer.addChild(blockShape);
						
						blockShape.x = (cityShape.location.x - origin.x) * scale;
						blockShape.y = (cityShape.location.y - origin.y) * scale;
						
						blockShape.neighbourhood = cityShape.neighbourhood;
						
						//save geolocation
						blockShape.location = new Point(blockShape.x, blockShape.y);
						
						shapeCollection.push(blockShape);
						
						blockShape.init(cityShape.coordinates);
						
						/*
						//blockShape.cacheAsBitmapMatrix = blockShape.transform.concatenatedMatrix; 
						//blockShape.cacheAsBitmap = true;
						
						//TweenMax.from(blockShape,1,{alpha:0, delay:0.005*i});
						//TweenMax.from(blockShape,Math.random()*20,{alpha:0, delay:0.1*i*Math.random()});
						//TweenMax.from(blockShape,1,{z:1000, rotation: 90, alpha:0,delay:0.01*i});
						//TweenMax.from(blockShape,10 + (Math.random() * 10),{scaleX: 1 + Math.random(),scaleY: 1 + Math.random(), alpha: .1 + (Math.random() / 2), yoyo:true, repeat:-1});
						*/
					}
					
					
				}
				
				//container background
				updateContentBackground();
				
				if (Settings.platformTarget != "web") {
				
					//mask for container
					containerMask = new Sprite();
					containerMask.graphics.beginFill(0xFFFFFF,0);
					containerMask.graphics.drawRect(shapeContainer.x, shapeContainer.y, activeArea.width, activeArea.height);
					this.addChild(containerMask);
					shapeContainer.mask = containerMask
					
					//add scroll system
					scroll = new Scroll();
					scroll.direction = "both";
					scroll.target = shapeContainer;
					scroll.maskContainer = containerMask;
					scroll.friction = .9;
					this.addChild(scroll);
					scroll.init();
				}
				
				
				//listener - Interaction
				this.addEventListener(MouseEvent.MOUSE_UP, onBlockClick);
				
				if (Settings.platformTarget != "web") {
					this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onMapGestureZoom);
				} else {
					Settings.showZoomControls = true; 
					this.addEventListener(MouseEvent.MOUSE_DOWN, dragMap);
				}
				
				//zoom controller
				if (Settings.showZoomControls) {
					zoomControl = new ZoomModule(this.getController(), shapeContainer);
					zoomControl.x = activeArea.width - zoomControl.width - 10;
					zoomControl.y = 10;
					this.addChild(zoomControl);
				}
				
				//Dispatch Event
				this.dispatchEvent(new Event(Event.COMPLETE));
				stage.addEventListener(Event.RESIZE, resize);
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		private function updateContentBackground():void {
			shapeContainer.graphics.clear();
			shapeContainer.graphics.beginFill(0xFFFFFF,0);
			shapeContainer.graphics.drawRect(0,0,shapeContainer.width,shapeContainer.height);
			shapeContainer.graphics.endFill();
			
			//if (scroll) scroll.update();
		}
		
		
		//****************** GETTERS ****************** ****************** ****************** 
		
		/**
		 * isExploded. Returns the current exploded condition
		 * @param value:Rectangle
		 * 
		 */
		public function isExploded():Boolean {
			return exploded;
		}
		
		
		//****************** SETTERS ****************** ****************** ****************** 
		
		/**
		 * SetActiveArea. Save the active area size to a variable.
		 * 
		 * @param value:Rectangle
		 * 
		 */
		public function setActiveArea(value:Rectangle):void {
			activeArea = value;
		}
		
		//****************** PROTECTED METHODS  ****************** ****************** ****************** 
		
		/**
		 * Get Shape by ID. Returns the BlockShape that matches the parameter
		 *  
		 * @param value:int
		 * @return:BlockShape
		 * 
		 */
		protected function getShapeById(value:int):BlockShape {
			for each (var b:BlockShape in shapeCollection) {
				if (b.id == value) {
					return b;
					break;
				}
			}
			
			return null;
		}
		
		/**
		 * Add Highlight Shapes.
		 * <p>Adds broadcast shapes from the model to the highlight list and initiate their state</p>
		 * <p>It checks for duplicates before add to the list</p>
		 * <p>The parameter reset calls for a method to remove all shapes from the highlight list.</p>
		 * <p>The reset is false by default, but if the user change submenu types, it will reset the highlight list.</p>
		 * <p>It also calls a dim method to make other non-highlight shapes to dim the lights down</p> 
		 * 
		 * @param shapesToAdd:Array
		 * @param reset:Boolean = false
		 * 
		 */
		protected function addHighlightShapes(shapesToAdd:Array, reset:Boolean = false):void {
			
			//reset highlight when contentType changes
			if (reset) resetHighlight();
			
			//create hughlight array if it does not exists yet
			if (!highlightedShapes) highlightedShapes = new Array();
			
			
			//add to the list
			var block:BlockShape;
			
			for each (var cs:CityShape in shapesToAdd) {
				block = getShapeById(cs.id);
				block.highlighted = true;
				block.dim(false);
				highlightedShapes.push(block);
				
				if (ignoredShapes) {
					ignoredShapes.splice(ignoredShapes.indexOf(block),1)
				}
			}
			
			//create ignore list it does not exists yet
			if (!ignoredShapes) {
				
				ignoredShapes = new Array();
				
				for each (block in shapeCollection) {
					if (!block.highlighted) {
						ignoredShapes.push(block);
						
						if (!exploded) {
							block.dim(true,"start");
						} else {
							//block.x = block.location.x;
							//block.y = block.location.y;
						}
					}
				}
				
			}

		}
		
		/**
		 * Remove Highlight Shapes.
		 * <p>Removes broadcast shapes from the model to the highlight list and turn them to the normal state</p>
		 * <p>It also calls a dim method to make this shapes lighter</p> 
		 * <p>If their no highlight shapes after the removal, it calls the method Dim to turn on the lights again</p>
		 *  
		 * @param shapesToRemove:Array
		 * 
		 */
		protected function removeHighlightShapes(shapesToRemove:Array):void {
			
			//dim ignored shapes
			if (highlightedShapes) {
				
				var block:BlockShape;

				for each (var cs:CityShape in shapesToRemove) {
					block = getShapeById(cs.id);
					block.highlighted = false;
					highlightedShapes.splice(highlightedShapes.indexOf(block),1)
					ignoredShapes.push(block);
					if(!exploded) block.dim(true);
				}
				
			}
			
			
			//get back to normal
			if (highlightedShapes.length == 0) {
				ignoredShapes = null;
				highlightedShapes = null;
				
				for each (block in shapeCollection) {
					block.dim(false,"end");
				}
			}
			
		}
		
		/**
		 * Reset Highlight.
		 * <p>It simply reset the highlight list and turn them back to the original state.</p> 
		 * 
		 */
		protected function resetHighlight():void {
			
			for each (var bs:BlockShape in highlightedShapes) {
				bs.highlighted = false;
			}
			
			highlightedShapes = null;
			ignoredShapes = null;
			
		}
		
		/**
		 * Non filtered explosion 
		 * 
		 */
		protected function explosion():void {
			
			TweenMax.to(shapeContainer,2,{scaleX:1, scaleY:1, x:0, y:0,delay:2 * random});
			
			//initial position
			var posX:Number = 2;
			var posY:Number = 0;
			var alt:Number = 0;
			
			var random:Number = Math.random();
			
			//loops
			for each (var object:BlockShape in shapeCollection) {
				
				//remove light fx
				object.dim(false,"end");
				object.highlighted = false;
				
				//update vertical position
				if (posX + object.width + 2 > stage.stageWidth) {
					posY += alt + 1;
					posX = 2;
					alt = 0;
					
					//new new position
					alt = object.height + 1;
				}

				//keep record of the taller object
				if (alt < object.height) {
					alt = object.height + 1;
				}
	
				//animation
				TweenMax.to(object,2,{x:posX - object.registrationTL.x, y:posY - object.registrationTL.y, delay:random});
				
				//update horizontal position
				posX += object.width + 2;
				
			}
			
			updateContentBackground();
		}
		
		/**
		 * Filtered explosion. It receive the params to add or remove shapes to the explosion
		 *  
		 * @param params:Object
		 * 
		 */
		protected function filteredExplosion(params:Object = null):void {
			
			//dim ignored shapes
			for each (var bIg:BlockShape in ignoredShapes) {
				bIg.dim(true,"out");
				TweenMax.to(bIg,2,{x:bIg.location.x,y:bIg.location.y});
			}
			
			//initial attributes
			var minY:Number = 70;
			
			switch (DeviceInfo.os()) {
				case "iPhone":
					minY = 140;
					break;
			}
			
			var posX:Number = 2;
			var posY:Number = minY;
			var alt:Number = 0;
			var groupPosX:Number = 0;
			
			var maxWidth:Number = ExplodeInfoView.groupWidth;
			var gap:Number = ExplodeInfoView.gap;
			var random:Number = Math.random();
			var i:int = 0; //group iterarion
			
			//content
			var control:PipelineController = this.getController() as PipelineController;
			var contentType:String = control.getHighlightedContentType();
			var highlightedContent:Array = control.getHighlightedContent(contentType);
			
			//Content type switch
			var communityIDs:Array = new Array();
			
			switch (contentType) {
				
				case "community":
					
					//Get neighbourhoods id
					for each (var n:String in highlightedContent) {
						communityIDs.push(control.getNeighbourhoodIDByName(n));
					}
					
					highlightedContent = communityIDs;
					communityIDs = null;
					
					explode();
					
					break;
				
				case "period":
					
					//convert period string into two: start and end date
					var start:int;
					var end:int;
					
					//Get neighbourhoods id
					for each (var p:String in highlightedContent) {
						var pArr:Array = p.split(" - ");
						start = pArr[0];
						end = pArr[1];
						
						communityIDs.push(control.getNeighbourhoodIDsByPeriod(start, end));;
					}
					
					var highlightedPeriod:Array = communityIDs;
					communityIDs = null;
					
					explodePeriod();
					
					break;
			}
			
			//explode by period
			function explodePeriod():void {
				
				//period loop
				for each (var period:Array in highlightedPeriod) {
					
					//save period's neighbourhoods
					highlightedContent = period;
					
					//update positioning
					groupPosX = (maxWidth * i ) + (gap * i);
					posX = groupPosX;
					posY = minY;
					
					explode();
					
					i++;
				}
			}
			
			//explode by community (period will use this to concatenate communities by period)
			function explode():void {
				for each (var content:int in highlightedContent) {
					
					//update positioning if community
					if (contentType == "community") {
						groupPosX = (maxWidth * i ) + (gap * i);
						posX = groupPosX;
						posY = minY;
					}
					
					//shape loop
					for each (var object:BlockShape in highlightedShapes) {
						
						//if shape bellongs to the exploding group
						if (content == object.neighbourhood) {
							
							//change status
							object.highlighted = true;
							
							//update vertical position
							if (posX + object.width + 2 > groupPosX + maxWidth) {
								posY += alt + 1;
								posX = groupPosX + 2;
								
								//new new position
								alt = object.height + 1;
							}
							
							//keep record of the taller object
							if (alt < object.height) {
								alt = object.height + 1;
							}
							
							//animation
							TweenMax.to(object,2,{x:posX - object.registrationTL.x, y:posY - object.registrationTL.y, delay:.5 * random});
							
							//update horizontal position
							posX += object.width + 2;
							
						}
					
					}
					
					//update iteration if community
					if (contentType == "community") {
						i++;
					}
					
				}
			}

			
			
			//if parameter is pass and the action is remove			
			if (params && params.action == "remove") {
				for each (var b:BlockShape in shapeCollection) {
					if (params.source == b.neighbourhood) {
						TweenMax.to(b,1,{alpha:0, x:b.location.x,y:b.location.y,delay:random});
					}
				}
			}
			
			updateContentBackground();
			
		}
		
		/**
		 * Back to Origin. It animatte the shapes back to the original GPS location.
		 * 
		 */
		protected function backToOrigin(collection:Array = null):void {
			
			var random:Number = Math.random();
			
			TweenMax.to(shapeContainer,2,{scaleX:1, scaleY:1, x:0, y:0,delay:random,onComplete:updateContentBackground});
			
			var affectedArray:Array = shapeCollection;
			
			//define what is going ack to origin. If a argument is passed, so use it. Otherwise it is the end of explosion.
			if (collection) {
				affectedArray = collection;
			} else {
				exploded = false;
			}
			
			//move it back
			for each (var object:BlockShape in affectedArray) {
				TweenMax.to(object,2,{x:object.location.x,y:object.location.y,delay:random});
			}
			
			
			//dim ignore
			for each (var bIg:BlockShape in ignoredShapes) {
				bIg.dim(true);
			}
			
			affectedArray = null;
			
		}
		
		
		//****************** EVENT - ACTIONS  ****************** ****************** ****************** 
		
		/**
		 * CHANGE. Manage the changes broadcast by the model.
		 * <p>Type: Highlight</p>
		 * <p>Adds or removes shapes from highlight state.</p>
		 *  
		 * @param event:PipelineEvents
		 * 
		 */
		protected function onChange(event:PipelineEvents):void {
			
			if (event.parameters.method == "highlight") {
				
				var reset:Boolean = event.parameters.reset;
				
				switch (event.parameters.action) {
				
					case "add":
						addHighlightShapes(event.parameters.shapes, reset);
						break;
					
					case "remove":
						removeHighlightShapes(event.parameters.shapes);
						break;
				}
				
			}
			
		}
		
		/**
		 * Add or remove content to filtered explosion
		 * 
		 * @param event
		 * 
		 */
		protected function explosionContentChange(event:PipelineEvents):void {
			
			switch (event.parameters.action) {
				
				case "addBulk":
					filteredExplosion()
					break;
				
				case "add":
					filteredExplosion()
					break;
				
				case "remove":
					
					var control:PipelineController = this.getController() as PipelineController;
					
					var communityID:int = control.getNeighbourhoodIDByName(event.parameters.source);
					
					var data:Object = {};
					data.action = event.parameters.action;
					data.source = communityID;
					
					filteredExplosion(data)
					
					control = null;
					data = null;
					
					break;
				
				case "removeAll":
					explosion();
					break;
				
			}
			
		}
		
		
		//****************** EVENT - INTERFACE  ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onMapGestureZoom(event:TransformGestureEvent):void {
			
			var myProxy:TweenProxy = TweenProxy.create(shapeContainer);	
			
			switch (event.phase) {
				
				case "begin":
					myProxy.registration = new Point(event.stageX, event.stageY);
					break;
				
				case "update":
					myProxy.scaleX *= event.scaleX;
					myProxy.scaleY *= event.scaleY;
					break;
				
				case "end":
					
					//prevent the map to be smaller then scale 1
					if (myProxy.scaleX < 1) {
						TweenMax.to(myProxy, 1, {scaleX:1, scaleY:1});
						TweenMax.to(shapeContainer, 1, {x:0, y:0});
					}
					break;
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onBlockClick(event:Event):void {
			
			if (event.target is BlockShape) {
				
				//remove selection from a selected shape
				if (selectedShape) selectedShape.selected = !selectedShape.selected;
				
				//new selected shape
				selectedShape = event.target as BlockShape;
				selectedShape.selected = !selectedShape.selected;
				
			} else {
				if (selectedShape) selectedShape.selected = false;
				selectedShape = null;
			}
			
			this.removeEventListener(MouseEvent.MOUSE_MOVE, dragMapMove);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function dragMap(event:MouseEvent):void {
			if (zoomControl.currentZoom > 1) this.addEventListener(MouseEvent.MOUSE_MOVE, dragMapMove);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function dragMapMove(event:MouseEvent):void {
			var bounds:Rectangle = new Rectangle();
			bounds.x = -shapeContainer.width + activeArea.width;
			bounds.y = -shapeContainer.height + activeArea.height;
			bounds.width = shapeContainer.width - activeArea.width;
			bounds.height = shapeContainer.height - activeArea.height;
			
			shapeContainer.startDrag(false,bounds);
			
			this.removeEventListener(MouseEvent.MOUSE_MOVE, dragMapMove);
			this.removeEventListener(MouseEvent.MOUSE_UP, onBlockClick);

			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragMap);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function stopDragMap(event:MouseEvent):void {
			shapeContainer.stopDrag();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragMap);
			
			this.addEventListener(MouseEvent.MOUSE_UP, onBlockClick);	
		}	
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function resize(event:Event):void {
			if (zoomControl) zoomControl.x = activeArea.width - zoomControl.width - 10;
			//shapeContainer.width = stage.stageWidth;
			//trace (shapeContainer.scaleX);
			//TweenMax.to(shapeContainer, 1, {x:0, y:0});
		}
		
		//****************** PUBLIC METHODS  ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param object
		 * 
		 */
		public function addListener(object:EventDispatcher):void {
			object.addEventListener(PipelineEvents.SELECT, explosionContentChange);
		}
		
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
				TweenMax.to(shapeCollection,1,{scaleX:1,scaleY:1, alpha: .6});
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
		public function sort(explode:Boolean, filtered:Boolean = false, by:String = "size"):void {
			
			TweenMax.killChildTweensOf(this);
			
			if (explode) {
				
				if (by == "size") {
					shapeCollection.sortOn("surface", Array.NUMERIC);
				}
				
				if (filtered) {
					filteredExplosion();
				} else {
					explosion();
				}
				
				exploded = true;
				
				
			} else {
				backToOrigin();	
			}
		}
		
	}
}