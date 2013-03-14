package view.menu {
	
	//import
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import events.PipelineEvents;
	
	public class AbstractSubMenuContent extends Sprite {
		
		//properties
		protected var itemCollection:Array;
		protected var gapV:Number;
		protected var gapH:Number;
		protected var item:SubMenuItem;
		protected var hMax:Number;
		protected var data:Array;
		
		public function AbstractSubMenuContent(_data:Array, _h:Number) {
			super();
			
			data = _data;
			hMax = _h;
		}
		
		public function init():void {
			//override
		}
		
		/**
		 * CLICK HANDLE 
		 * @param event
		 * 
		 */
		protected function _itemClick(event:MouseEvent):void {
			
			
			item = event.currentTarget as SubMenuItem;
			item.toggle = !item.toggle;
			
			switch (item.type) {
				case "neighbourhood":
					
					break;
				
				case "period":
				
					break;
			}
			
			
			var data:Object = {type:item.type, action:item.toggle, param:item.title};	
			
			this.dispatchEvent(new PipelineEvents(PipelineEvents.SELECT, data));
			
		}
	}
}