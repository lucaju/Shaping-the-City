package view.menu {
	import com.greensock.TweenMax;
	
	import flash.events.MouseEvent;
	
	public class SubMenuContentPeriod extends AbstractSubMenuContent {
		
		//properties
		private var dateGap:int = 10;
		
		public function SubMenuContentPeriod(_data:Array, _h:Number) {
			super(_data,_h);
			
			gapH = 10;
		}
		
		override public function init():void {
			
			
			
			itemCollection = new Array;
			
			var initDate:int = data[0];
			var endDate:int = data[data.length-1];
			
			var date:int = initDate;
			var label:String;
			var posX:Number = 0;
			
			while (date <= endDate) {
				
				label = date + " - " + (date + dateGap -1);
				
				item = SubMenuItemFactory.addSubMenuItem("period", hMax);
				
				this.addChild(item);
				item.init(label);
				item.x = posX;
				
				item.addEventListener(MouseEvent.CLICK, _itemClick);
				
				itemCollection.push(item);
				
				posX += item.width + gapH;
				
				TweenMax.from(item,.5,{alpha:0,y:-10,delay:Math.random()})
					
				date += dateGap;
			}
		}
	}
}