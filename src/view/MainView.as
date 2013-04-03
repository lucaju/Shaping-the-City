package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import events.PipelineEvents;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.breadcrumb.Breadcrumb;
	
	public class MainView extends AbstractView {
		
		//properties
		
		protected var topBar:TopBar;
		protected var footer:Footer;
		protected var mapView:MapView;
		protected var breadcrumbView:Breadcrumb;
		
		protected var treesView:TreesView;
		
		
		protected var sMax:int = 0;
		protected var tint:Boolean = false;
		
		
		public function MainView(c:IController) {
			super(c);

		}
		
				
		public function init():void {
			

			//creting the interface
			//1. top bar
			topBar = new TopBar(this.getController());
			topBar.setModel(this.getModel());
			this.addChild(topBar);
			topBar.init();	
			
			topBar.addEventListener(PipelineEvents.RESIZE, topBarResizeHandle);
			
			//2. Footer
			footer = new Footer(this.getController());
			this.addChild(footer);
			footer.init();
			
			footer.addEventListener(PipelineEvents.CHANGE, footerHandle);
			
			
			
			//3. Start MapView

			
			mapView = new MapView(this.getController());
			this.addChildAt(mapView,0);
			mapView.setActiveArea(new Rectangle(0,topBar.height,stage.stageWidth,(stage.stageHeight-footer.height) - topBar.height))
			mapView.y = topBar.height;
			mapView.init();
			
			//mapView.x = this.stage.stageWidth/2;
			//mapView.y = this.stage.stageHeight/2;
			
			
			//Listen moodel
			this.getModel().addEventListener(PipelineEvents.CHANGE, onModelChange);
			
			
		}
		
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
		
		
		protected function footerHandle(event:PipelineEvents):void {
			
			switch (event.parameters.source) {
				case "Explode":
					mapView.sort(event.parameters.state)
					break;
				
				case "Animation":
					mapView.animation(event.parameters.state)
					break;
			}
			
		}
		
		
		
		
		protected function onModelChange(event:PipelineEvents):void {
			
			
			if (!breadcrumbView) {
				breadcrumbView = new Breadcrumb(this.getController());
				this.addChildAt(breadcrumbView,1);
				breadcrumbView.init(event.parameters.type);
				breadcrumbView.y = footer.y - breadcrumbView.height;
				this.addEventListener(PipelineEvents.COMPLETE, killBreadCrumb);
			}
			
			breadcrumbView.update(event.parameters.source, event.parameters.action, event.parameters.type);
			
		}
		
		protected function killBreadCrumb(event:Event):void {
			this.removeChild(breadcrumbView);
			breadcrumbView = null;
		}		
		
		
		
		
		
		
		private function _loadTrees(e:MouseEvent):void {
			/*
			var proportion:Object = PipelineController(this.getController()).getMapPropportions();
			
			treesView = new TreesView(this.getController());
			this.addChild(treesView);
			treesView.setProportion(proportion);
			treesView.init();
			
			treesView.scaleY *= -1;
			treesView.y = mapView.height + 100;
			*/
		}
		
		private function _treeCollision(e:MouseEvent):void {
			/*
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
			*/
		}
		
		private function tintShape(e:MouseEvent):void {
			/*
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
			*/
		}
	}
}