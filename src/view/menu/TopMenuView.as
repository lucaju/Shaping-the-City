package view.menu {
	
	//imports
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import events.PipelineEvents;
	
	import mvc.IController;
	
	public class TopMenuView extends AbstractMenuView {
		
		//properties
		private var item:TopBarItem;
		
		/**
		 * CONTRUCTOR 
		 * @param c
		 * @param options
		 * 
		 */		
		public function TopMenuView(c:IController, options:Array = null) {
			super(c, options);
			
			//initials
			gap = 5;
		}
		
		/**
		 * Initiate: Build Menu Items 
		 * 
		 */
		override public function init():void {
			
			//create menu items
			var posX:Number = 0;
			
			if (optionCollection) {
				for each (var option:Object in optionCollection) {
					
					item = TopBarItemFactory.addTopBarItem(option.title);
					item.x = posX;
					this.addChild(item);
					
					item.addEventListener(MouseEvent.CLICK, _itemClick);
					
					itemCollection.push(item)
					
					posX += item.width + gap;
					item = null;
				
				}
			}
			
			
		}
		
		/**
		 * CLICK HANDLE 
		 * @param event
		 * 
		 */
		protected function _itemClick(event:MouseEvent):void {
			
			var data:Object;
			
			item = event.currentTarget as TopBarItem;
			
			if (item.toggle) {
				deselectAll();
				data = {label:""};
			} else {
				deselectAll();
				item.toggle = !item.toggle;
				data = {label:item.title};	
			}
			

			this.dispatchEvent(new PipelineEvents(PipelineEvents.SELECT, data));
		
		}
		
		protected function deselectAll():void {
			for each(var item:TopBarItem in itemCollection) {
				item.toggle = false;
			}
		}
	}
}