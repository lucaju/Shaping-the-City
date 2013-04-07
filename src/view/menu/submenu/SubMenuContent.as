package view.menu.submenu {
	
	//import
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import events.PipelineEvents;
	
	import view.util.scroll.Scroll;
	
	public class SubMenuContent extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		protected var data					:Array;						//Raw data
		protected var _type					:String;					//Content type
		protected var _orientation			:String = "horizontal";		//Layout Orientation
		protected var scrolling				:Boolean = false;
		protected var independentRows		:Boolean = true;
		
		protected var dateGap				:uint = 10;					//Date range in period content
		
		protected var itemCollection		:Array;						//Item Collection
		
		protected var numRows				:uint = 1;
		protected var gapV					:Number = 5;				//Vertical Gap between itens
		protected var gapH					:Number = 5;				//Horizontal Gap between itens
		protected var rangeSize				:Number;					//Range size. Height for Horizontal and Width for Vertical
		protected var _scrollLimit			:Number = 200;
	
		protected var item					:SubMenuItem;				//General SubMenu Item
		protected var scroll				:Scroll;
		
		protected var scrolledArea			:Sprite;
		protected var container				:Sprite;
		protected var containerMask			:Sprite;
		
		
		//****************** CONTRUCTOR ****************** ******************  ****************** 
		/**
		 * Contructor. Create the abstraction of SubMenu Content.
		 * <p>Define the data</p>
		 * <p>Define the contante type. If data is "period" it performs an aditional parsing.</p> 
		 * <p>Set the range size. Height for Horizontal and Width for Vertical</p>
		 * @param _data:Array
 		 * @param type_:String
		 * @param _range:Number
		 * 
		 */
		public function SubMenuContent(data_:Array, type_:String, range:Number) {
			type = type_;
			data = data_;
			
			if (type == "period") {
				data = getPeriodLabel();
			}
			
			rangeSize = range;
		}
		
		//****************** GETTERS ****************** ******************  ****************** 

		/**
		 * Type. Return content type. 
		 * @return 
		 * 
		 */
		public function get type():String {
			return _type;
		}
		
		/**
		 * Return current orientation. 
		 * @return:String
		 * 
		 */
		public function get orientation():String {
			return _orientation;
		}
		
		/**
		 * scrollLimit. Return the current scrollLimit 
		 * @return:Number
		 * 
		 */
		public function get scrollLimit():Number {
			return _scrollLimit;
		}
		
		//****************** SETTERS ****************** ******************  ****************** 
		
		/**
		 * type. Set content type 
		 * @param value:String
		 * 
		 */
		public function set type(value:String):void {
			_type = value;
		}
		
		/**
		 * Set orientation: "vertical" or "horizontal". 
		 * @param value:String
		 * 
		 */
		public function set orientation(value:String):void {
			_orientation = value;
		}
		
		/**
		 * scrollLimit. Set Scroll Limit. 
		 * @param value:Number
		 * 
		 */
		public function set scrollLimit(value:Number):void {
			_scrollLimit = value;
		}

		//****************** INITIALIZE ****************** ******************  ****************** 
		
		/**
		 * Initiate.
		 * 
		 */
		public function init():void {
			
			itemCollection = new Array;
			
			switch (orientation) {
				case "horizontal":
					buildHorizontalLayout();
					break;
				
				case "vertical":
					buildVerticalLayout();
					break;
			}
			
			//content
			this.graphics.beginFill(0xFFFFFF,0);
			this.graphics.drawRect(0,0,this.width,this.height);
			this.graphics.endFill();

		}
		
		//****************** PROTECTED METHODS ****************** ******************  ****************** 
		
		private function buildVerticalLayout():void {
			var containerArray:Array = new Array(numRows);
			
			//set initial X position to X;
			//Set Y position
			var posX:Array = new Array(numRows);
			var posY:Array = new Array(numRows);
			
			
			for (var p:int = 0; p < numRows; p++) {
				posX[p] = Math.round((p * rangeSize) / numRows);				
				posY[p] = 0;
				
				containerArray[p] = new Sprite();
				addChild(containerArray[p])
			}
			
			var split:int = Math.round(data.length/numRows);
			var cNum:int = 0;
			var pos:int = 0;
			var posXX:Number = 0;
			var posYY:Number = 0;
			
			for (var i:int = 0; i < data.length; i++) {
				
				item = SubMenuItemFactory.addSubMenuItem(type,rangeSize);
				item.fixedSize = true;
					
				item.init(data[i]);
				
				if (i % split == 0 && i != 0) {
					cNum++;
					
					posXX += item.width + gapH;
					posYY = 0;
					
					containerArray[cNum].x = posXX;
					
				}
				
				containerArray[cNum].addChild(item);
				
				item.y = posYY;
				
				//separation
				if (Settings.useSubMenuItemSeparator) {
					if (i < data.length - 1) {
						var sep:Sprite = addSeparator("horizontal",item.width);
						sep.y = posYY +  item.height + (gapH/2);
						containerArray[cNum].addChild(sep)
					}
				}
				
				posYY += item.height + gapV;
				
				item.addEventListener(MouseEvent.CLICK, _itemClick);
				itemCollection.push(item);
				
				//TweenMax.from(item,.5,{alpha:0,delay:Math.random()});
				
			}
			
			
			//scroll
			for each (var cont:Sprite in containerArray) {
				testForScroll(cont);
				
				//bg
				var bg:Sprite = new Sprite();
				bg.graphics.beginFill(0xFFFFFF,0);
				bg.graphics.drawRect(0,0,cont.width,cont.height);
				bg.graphics.endFill();
				cont.addChildAt(bg,0);
			}
			
		}
		
		private function addSeparator(side:String, size:Number = 100):Sprite {
			var line:Sprite = new Sprite;
			
			line.graphics.lineStyle(1,0x666666,.8);
			line.graphics.beginFill(0x000000, 0);
			
			switch(side) {
				case "horizontal":
					line.graphics.moveTo(size * .1, 0);
					line.graphics.lineTo(size * .8, 0)
					break;
				
				case "vertical":
					line.graphics.moveTo(0, size * .1);
					line.graphics.lineTo(0, size * .8)
					break;
					
			}
			
			line.graphics.endFill();
				
			return line;
			
		}		
		
		protected function buildHorizontalLayout():void {
			
			if (type == "community") {
				numRows = Settings.subMenuHorizontalRows;
			}
			
			var containerArray:Array = new Array(numRows);
			
			//set initial X position to X;
			//Set Y position
			var posX:Array = new Array(numRows);
			var posY:Array = new Array(numRows);
			
			
			for (var p:int = 0; p < numRows; p++) {
				posX[p] = 0;
				posY[p] = Math.round((p * rangeSize) / numRows);
				
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
				
				item = SubMenuItemFactory.addSubMenuItem(type);
				
				item.init(data[i]);
				
				if (i % split == 0 && i != 0) {
					cNum++;
					posXX = 0;
					posYY += item.height + gapV;
					containerArray[cNum].y = posYY;
					
				}
				
				containerArray[cNum].addChild(item);
				
				item.x = posXX;
				
				//separation
				if (Settings.useSubMenuItemSeparator) {
					if (i < data.length - 1) {
						var sep:Sprite = addSeparator("vertical",item.height);
						sep.x = posXX +  item.width + (gapV/2);
						containerArray[cNum].addChild(sep)
					}
				}
				
				posXX += item.width + gapH;
				
				item.addEventListener(MouseEvent.CLICK, _itemClick);
				itemCollection.push(item);
				
				TweenMax.from(item,.5,{alpha:0,delay:Math.random()});
				
			}
			
			//scroll
			for each (var cont:Sprite in containerArray) {
				testForScroll(cont);
				
				//bg
				var bg:Sprite = new Sprite();
				bg.graphics.beginFill(0xFFFFFF,0);
				bg.graphics.drawRect(0,0,cont.width,cont.height);
				bg.graphics.endFill();
				cont.addChildAt(bg,0);
			}
			
			//centralize
			if (type == "period") {
				containerArray[0].x = (this.parent.width/2) - (containerArray[0].width/2);
			}
			
		}
		
		/**
		 * 
		 * @param c
		 * @param contructor
		 * @param diff
		 * 
		 */
		protected function testForScroll(c:Sprite = null, contructor:Boolean = true, diff:Number = 0):void {
			
			var containerToScroll:Sprite;
			
			if (c != null) {
				containerToScroll = c;
			} else {
				containerToScroll = container;
			}
			
			switch (orientation) {
				case "horizontal":
					
					if (containerToScroll.width + diff > scrollLimit) {
						scrolling = true;
						
						//mask for container
						containerMask = new Sprite();
						containerMask.graphics.beginFill(0xFFFFFF,0);
						containerMask.graphics.drawRect(containerToScroll.x, containerToScroll.y, scrollLimit, containerToScroll.height + gapV);
						this.addChild(containerMask);
						containerToScroll.mask = containerMask
						
						//add scroll system
						scroll = new Scroll();
						scroll.direction = orientation;
						scroll.target = containerToScroll;
						scroll.maskContainer = containerMask;
						scroll.color = 0xFFFFFF;
						this.addChild(scroll);
						scroll.init();
						
						if (independentRows) {
							scroll.rollVisible = false;
						}
					}
					
					break;
				
				case "vertical":
					
					if (containerToScroll.height + diff > scrollLimit) {
						scrolling = true;
						
						//mask for container
						containerMask = new Sprite();
						containerMask.graphics.beginFill(0xFFFFFF,0);
						containerMask.graphics.drawRect(containerToScroll.x, containerToScroll.y, containerToScroll.width + gapH, scrollLimit);
						this.addChild(containerMask);
						containerToScroll.mask = containerMask
						
						//add scroll system
						scroll = new Scroll();
						scroll.direction = orientation;
						scroll.target = containerToScroll;
						scroll.maskContainer = containerMask;
						scroll.hasRoll = false;
						this.addChild(scroll);
						scroll.init();
						
					}
					
					break;
			}
			
		}
		
		
		//****************** PRIVATE METHOD ****************** ******************  ****************** 
		
		/**
		 * GetPeriodsLabels. Parse all dates in order to split in range of years according to dateGap
		 * @return 
		 * 
		 */
		private function getPeriodLabel():Array {
			
			var d:Array = new Array;
			
			var initDate:int = data[0];
			var endDate:int = data[data.length-1];
			
			var date:int = initDate;
			var label:String;
			var posX:Number = 0;
			
			while (date <= endDate) {
				
				label = date + " - " + (date + dateGap -1);
				
				d.push(label);
				
				date += dateGap;
			}
			
			return d;
			
		}
		
		protected function getItemByName(value:String):SubMenuItem {
			for each (var item:SubMenuItem in itemCollection) {
				if (value == item.title) {
					return item;
					break;
				}
			}
			
			return null;
		}
		
		//****************** PUBLIC METHOD ****************** ******************  ****************** 
		
		public function update(info:Object):void {
			
			var item:SubMenuItem;
			var toggleAction:Boolean;
			
			//action
			switch (info.action) {
				case "remove":
					toggleAction = false;
					break;
					
				case "add":
					toggleAction = true;
					break;
			}
			
			//type of information
			
			if (info.source is Array) {
				for each (var title:String in info.source) {
					item = getItemByName(title);
					item.toggle = toggleAction;
				}
			} else {
				item = getItemByName(info.source);
				item.toggle = toggleAction;
			}
				
		}
		
		
		//****************** EVENTS ****************** ******************  ****************** 
		/**
		 * CLICK HANDLE. 
		 * @param event
		 * 
		 */
		protected function _itemClick(event:MouseEvent):void {
			
			
			
			item = event.currentTarget as SubMenuItem;
			item.toggle = !item.toggle;
			
			var data:Object = {type:item.type, action:item.toggle, param:item.title};	
			
			this.dispatchEvent(new PipelineEvents(PipelineEvents.SELECT, data));
			
		}
	
	}
}