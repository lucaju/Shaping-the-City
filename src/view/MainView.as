package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import events.PipelineEvents;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.assets.Button;
	
	public class MainView extends AbstractView {
		
		//properties
		
		private var topBar:TopBar;
		private var footer:Footer;
		private var mapView:MapView;
		
		private var treesView:TreesView;
		
		private var alignBySize:Boolean = false;
		private var animationOn:Boolean = false;
		
		
		private var sMax:int = 0;
		private var tint:Boolean = false;
		
		
		public function MainView(c:IController) {
			super(c);

		}
		
				
		public function init():void {
			

			//creting the interface
			//1. top bar
			topBar = new TopBar(this.getController());
			this.addChild(topBar);
			topBar.init();
			
			
			
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
			
			
			
		}
		
		protected function footerHandle(event:PipelineEvents):void {
			
			switch (event.parameters.source) {
				case "Sort by Size":
					mapView.sort(event.parameters.state)
					break;
				
				case "Animation":
					mapView.animation(event.parameters.state)
					break;
			}
			
		}
		
		
		private function _animationSwitch(e:MouseEvent):void {
			animationOn = !animationOn;
			mapView.animation(animationOn);
		}
		
		
		private function _bySize(e:MouseEvent):void {
			alignBySize = !alignBySize;
			mapView.sort(alignBySize);
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
	}
}