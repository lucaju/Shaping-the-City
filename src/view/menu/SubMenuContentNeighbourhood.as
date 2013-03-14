package view.menu {
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import view.util.scroll.Scroll;
	
	public class SubMenuContentNeighbourhood extends AbstractSubMenuContent {
		
		//properties
		private var scrolledArea:Sprite;
		private var container:Sprite;
		private var containerMask:Sprite;
		
		private var scroll:Scroll;
		private var scrolling:Boolean = false;
		
		private var maxW:Number;
		private var numRows:uint = 3;
		
		public function SubMenuContentNeighbourhood(_data:Array, _h:Number) {
			
			super(_data,_h);
			
			gapH = 5;
			gapV = 5;
			
		}
		
		override public function init():void {
			
			maxW = stage.stageWidth;
			
			//container
			container = new Sprite();
			addChild(container)
			
			itemCollection = new Array;
			
			//set initial X position to X;
			//Set Y position
			var posX:Array = new Array(numRows);
			var posY:Array = new Array(numRows);
			
			
			for (var p:int = 0; p < numRows; p++) {
				posX[p] = 0;
				posY[p] = Math.round((p * hMax) / numRows);
				
			}
			
			var i:int = 0;
			var pos:int = 0;
			
			for each(var n:String in data) {
				
				i++;
			
				item = new SubMenuItem();
				container.addChild(item);
				item.init(n);
				
				pos = i%numRows;
				item.x = posX[pos];
				
				item.y = gapV + (pos * (item.height + gapV));
				
				posX[pos] += item.width + gapH;
				
				item.addEventListener(MouseEvent.CLICK, _itemClick);
				itemCollection.push(item);
				
				TweenMax.from(item,.5,{alpha:0,delay:Math.random()});
				
			}
			
			//scroll?
			testForScroll();
			//teste
			
		}
		
		private function testForScroll(contructor:Boolean = true, diff:Number = 0):void {
			
			if (container.width + diff > maxW) {
				scrolling = true;
				
				//mask for container
				containerMask = new Sprite();
				containerMask.graphics.beginFill(0xFFFFFF,0);
				containerMask.graphics.drawRect(container.x, container.y, maxW, container.height + gapV);
				this.addChild(containerMask);
				container.mask = containerMask
				
				//add scroll system
				scroll = new Scroll();
				scroll.direction = "horizontal";
				scroll.target = container;
				scroll.maskContainer = containerMask;
				scroll.color = 0xFFFFFF;
				this.addChild(scroll);
				scroll.init();
			}
			
		}
	}
}