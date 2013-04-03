package view.menu {
	
	//imports
	import flash.events.MouseEvent;
	
	import events.PipelineEvents;
	
	import mvc.IController;
	
	public class TopMenu extends AbstractMenu {
		
		//properties
		private var item:ButtonBar;
		
		/**
		 * CONTRUCTOR 
		 * @param c
		 * @param options
		 * 
		 */		
		public function TopMenu (c:IController, options:Array = null) {
			super(c, options);
			
			//initials
			gap = 0;
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
					
					item = ButtonBarFactory.addButtonBar(option.title,"topBar");
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
			
			item = event.currentTarget as ButtonBar;
			
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
			for each(var item:ButtonBar in itemCollection) {
				item.toggle = false;
			}
		}
	}
}