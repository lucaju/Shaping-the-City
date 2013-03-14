package view.menu {
	
	//imports
	import flash.events.Event;
	
	import events.PipelineEvents;
	
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.assets.Switcher;
	
	public class FooterMenuView extends AbstractMenuView {
		
		//properties
		private var item:Switcher;
		
		/**
		 * CONTRUCTOR 
		 * @param c
		 * @param options
		 * 
		 */		
		public function FooterMenuView(c:IController, options:Array = null) {
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
					
					item = new Switcher();
					item.label = option.title;
					
					if (DeviceInfo.os() == "iPhone") {
						item.setSize(130,48);
					}
					
					
					item.init();
					
					item.x = posX;
					this.addChild(item);
					
					
					item.addEventListener(Event.CHANGE, onSort);
					
					itemCollection.push(item)
					
					posX += item.width + gap;
					item = null;
				
				}
			}
			
			
		}

		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onSort(event:Event):void {
			var target:Switcher = event.target as Switcher;
			
			var obj:Object = {source:target.label, state:target.state};
			
			this.dispatchEvent(new PipelineEvents(PipelineEvents.CHANGE,obj));
			
		}
	}
}