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
		private var independentRows:Boolean = true;
		
		public function SubMenuContentNeighbourhood(_data:Array, _h:Number) {
			
			super(_data,_h);
			
			gapH = 5;
			gapV = 5;
			
		}
		
		override public function init():void {
			
			maxW = stage.stageWidth;
			itemCollection = new Array;
			
			if (independentRows) {
				buildMultipleRows();
			} else {
				buildOneRow();
			}
		}
		
		private function buildMultipleRows():void {
			
			var containerArray:Array = new Array(numRows);
			
			//set initial X position to X;
			//Set Y position
			var posX:Array = new Array(numRows);
			var posY:Array = new Array(numRows);
			
			
			for (var p:int = 0; p < numRows; p++) {
				posX[p] = 0;
				posY[p] = Math.round((p * hMax) / numRows);
				
				containerArray[p] = new Sprite();
				containerArray[p].name = "C" + p;
				addChild(containerArray[p])
			}
			
			var split:int = Math.round(data.length/numRows);
			var cNum:int = 0;
			var pos:int = 0;
			var posXX:Number = 0;
			var posYY:Number = 0;
			
			for (var i:int = 0; i < data.length; i++) {
				
				item = SubMenuItemFactory.addSubMenuItem("neighbourhood");
				
				item.init(data[i]);
				
				if (i % split == 0 && i != 0) {
					cNum++;
					posXX = 0;
					posYY += item.height + gapV;
					containerArray[cNum].y = posYY;
					
				}
		
				containerArray[cNum].addChild(item);
				
				item.x = posXX;
				
				posXX += item.width + gapH;
				
				item.addEventListener(MouseEvent.CLICK, _itemClick);
				itemCollection.push(item);
				
				TweenMax.from(item,.5,{alpha:0,delay:Math.random()});
				
			}
			
			
			//scroll
			for each (var cont:Sprite in containerArray) {
				testForScroll(cont);
			}
			
		}
		
		private function buildOneRow():void {
			
			//container
			container = new Sprite();
			addChild(container)
			
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
			
				item = new SubMenuItem("neighbourhood");
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
		}
		
		private function testForScroll(c:Sprite = null, contructor:Boolean = true, diff:Number = 0):void {
			
			var containerToScroll:Sprite;
			
			if (c != null) {
				containerToScroll = c;
			} else {
				containerToScroll = container;
			}
			
			if (containerToScroll.width + diff > maxW) {
				scrolling = true;
				
				//mask for container
				containerMask = new Sprite();
				containerMask.graphics.beginFill(0xFFFFFF,0);
				containerMask.graphics.drawRect(containerToScroll.x, containerToScroll.y, maxW, containerToScroll.height + gapV);
				this.addChild(containerMask);
				containerToScroll.mask = containerMask
				
				//add scroll system
				scroll = new Scroll();
				scroll.direction = "horizontal";
				scroll.target = containerToScroll;
				scroll.maskContainer = containerMask;
				scroll.color = 0xFFFFFF;
				this.addChild(scroll);
				scroll.init();
				
				if (independentRows) {
					scroll.rollVisible = false;
				}
			}
			
		}
	}
}