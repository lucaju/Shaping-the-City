package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import controller.PipelineController;
	
	import events.PipelineEvents;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.breadcrumb.Breadcrumb;
	import view.explode.ExplodeInfoView;
	import view.tooltip.ToolTipManager;
	import view.util.preloader.Preloader;
	import view.util.scroll.ScrollEvent;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class MainView extends AbstractView {
		
		//****************** Properties ****************** ****************** ****************** 
		
		//protected var mapExploded			:Boolean = false;
		
		protected var topBar				:TopBar;
		protected var footer				:Footer;
		protected var mapView				:MapView;
		protected var breadcrumbView		:Breadcrumb;
		protected var explodeInfoView		:ExplodeInfoView;
		protected var toolTipManager		:ToolTipManager;
		
		protected var splash				:Sprite;
		protected var preloader				:Preloader;
		
		//protected var treesView				:TreesView;
		//protected var sMax					:int = 0;
		//protected var tint					:Boolean = false;
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function MainView(c:IController) {
			super(c);
			
			//background
			splash = new Sprite();
			this.addChildAt(splash,0);
			
			var loaderimageLoader:Loader = new Loader();
			var img:String;
			switch (DeviceInfo.os()) {
				
				case "iPhone":
					img = "images/splash_2048_1536.png";
					break;
				
				default:
					img = "images/splash_1280_752.png";
					break;
				
			}
			
			loaderimageLoader.load(new URLRequest(img));
			splash.alpha = .8
			splash.addChild(loaderimageLoader);

		}
		
		
		//****************** INITIALIZE ****************** ****************** ****************** 
		
		/**
		 * 
		 * 
		 */
		public function init():void {

			
			//1. top bar
			topBar = new TopBar(this.getController());
			topBar.setModel(this.getModel());
			this.addChild(topBar);
			topBar.init();	
			topBar.visible = false;
			topBar.addEventListener(PipelineEvents.RESIZE, topBarResizeHandle);
			
			//2. Footer
			footer = new Footer(this.getController());
			this.addChild(footer);
			footer.visible = false;
			footer.init();
			footer.addEventListener(PipelineEvents.CHANGE, footerHandle);
			
			//3. Start MapView
			mapView = new MapView(this.getController());
			this.addChildAt(mapView,0);
			mapView.setActiveArea(new Rectangle(0,topBar.height,stage.stageWidth,(stage.stageHeight-footer.height) - topBar.height + 11))
			mapView.init();
			
			mapView.addEventListener(MouseEvent.CLICK, onMapClick);
			mapView.addEventListener(ScrollEvent.SCROLL, onMapScroll);
			mapView.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onMapGestureZoom);
			mapView.addEventListener(Event.COMPLETE, onMapLoad);
			
			//preloader
			if (DeviceInfo.os() != "iPhone") {
				preloader = new Preloader(this);
				preloader.postition(stage.stageWidth/2, 3 * (stage.stageHeight/4));
				preloader.scale = .1;
				preloader.start();
			}
				
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * 
		 */
		protected function addBreadCrumb(type:String):Breadcrumb {
			
			if (breadcrumbView) {
			
				return breadcrumbView;
			
			} else {
				breadcrumbView = new Breadcrumb(this.getController());
				this.addChildAt(breadcrumbView,1);
				breadcrumbView.init(type);
				breadcrumbView.y = footer.y - breadcrumbView.height;
				this.addEventListener(PipelineEvents.COMPLETE, killBreadCrumb);
				
				return breadcrumbView;
			}
			
		}
		
		/**
		 * 
		 * @param params
		 * 
		 */
		protected function manageBreadCrumb(params:Object):void {
			
			//create breadcrumb
			if (!breadcrumbView) addBreadCrumb(params.type);
			
			//update
			breadcrumbView.update(params.source, params.action, params.type);
		}
		
		/**
		 * 
		 * 
		 */
		protected function addExplodeInfoView():void {
			
			explodeInfoView = new ExplodeInfoView(this.getController());
			explodeInfoView.y = mapView.y + 10;
			this.addChildAt(explodeInfoView,1);
			
			explodeInfoView.init();
			
			mapView.addListener(explodeInfoView);
		}
		
		/**
		 * 
		 * @param explode
		 * @param chunk
		 * @param action
		 * 
		 */
		protected function ManageExplodeInfoOverlay(explode:Boolean):void {
			
			//check if it is filtered
			var filtered:Boolean = false;
			var HighlightedContentType:String = PipelineController(this.getController()).getHighlightedContentType();
			
			if (HighlightedContentType) {
				filtered = true;
			}
			
			//create explodeInfoView
			if (!explodeInfoView) addExplodeInfoView();
			
			//add explodeInfoView if Filtered
			if (filtered) {
				
				if (explodeInfoView.numGroups == 0) explodeInfoView.addBulk();
				if (!explode) {
					explodeInfoView.clear("all");
				}
			}
			
			mapView.sort(explode, filtered);
			
		}
		
		protected function removeObject(obj:Sprite):void {
			this.removeChild(obj);
		}
		
		
		//****************** EVENTS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onMapLoad(event:Event):void {
			//creating the interface
			
			//1.topbar
			topBar.visible = true;
			
			//2. Footer
			footer.visible = true;
			
			//3. MapView
			mapView.y = topBar.height - 5;
			mapView.removeEventListener(Event.COMPLETE, onMapLoad);
			
			//4. ToolTip Manager
			toolTipManager = new ToolTipManager(this.stage);
			
			//5. Listen moodel
			this.getModel().addEventListener(PipelineEvents.CHANGE, onModelChange);
			
			//6. remove splash
			
			//remove preloader
			if (preloader) {
				preloader.stop();
				preloader = null;
			}
			//remove splash
			TweenMax.to(splash,.5,{alpha:0, onComplete:removeObject, onCompleteParams:[splash]});
			splash = null;	
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function topBarResizeHandle(event:PipelineEvents):void {
			switch (event.parameters.action) {
				
				case "submenuOpen":
					if (Settings.subMenuOrientation == "vertical") {
						if (breadcrumbView) TweenMax.to(breadcrumbView,.3,{x:164});	
					}
					break;
				
				
				case "submenuClose":
					if (Settings.subMenuOrientation == "vertical") {
						if (breadcrumbView) TweenMax.to(breadcrumbView,.3,{x:0});
					}
					break;
				
			}
			
		}		
			
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function footerHandle(event:PipelineEvents):void {
			
			switch (event.parameters.source) {
				case "Explode":
					ManageExplodeInfoOverlay(event.parameters.state);
					break;
				
				case "Animation":
					mapView.animation(event.parameters.state);
					break;
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onModelChange(event:PipelineEvents):void {
			
			manageBreadCrumb(event.parameters)
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function killBreadCrumb(event:Event):void {
			this.removeChild(breadcrumbView);
			breadcrumbView = null;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onMapClick(event:Event):void {
			
			if (event.target is BlockShape) {
				
				var block:BlockShape = event.target as BlockShape;
				
				if (block.dimed != "out") {
					//registration point
					var targetLocation:Point = block.parent.localToGlobal(new Point(block.x, block.y));
					
					var tipLocation:Point = new Point();
					tipLocation.x = targetLocation.x + block.registrationTL.x;
					tipLocation.y = targetLocation.y + block.registrationTL.y;
					
					//get shape info
					var shapeInfo:Object = PipelineController(this.getController()).getShapeInfo(block.id);
					
					var blockInfo:Object = new Object();
					blockInfo.id  = block.id;
					blockInfo.position = tipLocation;
					blockInfo.dimension = new Point(block.width, block.height);
					
					//year
					var year:String = shapeInfo.period.toString();
					if (year == "0") {
						year = "--";
					}
					
					var info:String = "Community:<br/><b>" + shapeInfo.neighbourhood + "</b><br/>" + "Year:<br/><b>" + year + "</b>";
					
					blockInfo.info = info;
					
					//add tooltip	
					ToolTipManager.addToolTip(blockInfo);
					
					shapeInfo = null;
					blockInfo = null;
				}
				
				event.stopPropagation()
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onMapGestureZoom(event:TransformGestureEvent):void {
			ToolTipManager.removeToolTip();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onMapScroll(event:ScrollEvent):void {
			if (event.phase == "begin") {
				ToolTipManager.removeToolTip();
			}
		}
		
		
		//****************** TREES ****************** ****************** ****************** 
		
		/*
		
		private function _loadTrees(e:MouseEvent):void {
			
			var proportion:Object = PipelineController(this.getController()).getMapPropportions();
			
			treesView = new TreesView(this.getController());
			this.addChild(treesView);
			treesView.setProportion(proportion);
			treesView.init();
			
			treesView.scaleY *= -1;
			treesView.y = mapView.height + 100;
			
		}
		
		private function _treeCollision(e:MouseEvent):void {
			
			var shapes:Array = mapView.getShapes();
			var trees:Array = treesView.getShapes();
			
			var numTrees:int = 0;
			
			trace (shapes.length)
			
			//var i:int = 0;
			
			//for each (var block:BlockShape in shapes) {
			for (var k:int = 0; k < shapes.length; k++) {
				//if (k < 17)	{
			
				
					
					
					
					for each (var tree:Tree in trees) {
						if (shapes[k].hitTestObject(tree)) {
							trace ("------------------------------------aeeeeee");
							numTrees++;
						}
						trace ("!!!!!!!!!");
					}
					
					trace ("-----------------------------------------------------");
					trace (numTrees)
					
					shapes[k].numTrees = numTrees;
					numTrees = 0;
					
					
					
					
					//i++;
					
				
				//}
			}
			
			for each (var block:BlockShape in shapes) {
				if (sMax == 0) {
					sMax = block.numTrees;
				}
				
				if (block.numTrees > sMax) {
					sMax = block.numTrees;
				}
			}
			
			//collision
			var colissionTintBT:Button = new Button("Tint Shape");
			colissionTintBT.x = 500;
			colissionTintBT.addEventListener(MouseEvent.CLICK, tintShape);
			colissionTintBT.border = true;
			this.addChild(colissionTintBT);
			
		}
		
		private function tintShape(e:MouseEvent):void {
			
			var shapes:Array = mapView.getShapes();
				
			if (tint == false) {
				
				tint = true;
				
				for each (var block:BlockShape in shapes) {	
					
					trace ("----> " + block.numTrees)
					if (block.numTrees > 0) {
						TweenMax.to(block,2,{tint:0x78AB46,alpha:block.numTrees / sMax});
					} else {
						TweenMax.to(block,2,{alpha:0.1});
					}
					
				}
				
			} else {
				tint = false;
				for each (block in shapes) {
					TweenMax.to(block,2,{tint:0x000000,alpha:.2});
				}
			}
			
		}
		*/
	}
}