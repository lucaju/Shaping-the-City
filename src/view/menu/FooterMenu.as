package view.menu {
	
	//imports
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import events.PipelineEvents;
	
	import mvc.IController;
	
	import settings.Settings;
	
	import util.DeviceInfo;
	
	import view.assets.Switcher;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FooterMenu extends AbstractMenu {
		
		//****************** Properties ****************** ****************** ****************** 
		
		private var item					:*;
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * CONTRUCTOR 
		 * @param c
		 * @param options
		 * 
		 */		
		public function FooterMenu(c:IController, options:Array = null) {
			super(c, options);
		}
		
		
		//****************** Initialize ****************** ****************** ****************** 
		
		/**
		 * Initiate: Build Menu Items 
		 * 
		 */
		override public function init():void {
			
			//create menu items
			var posX:Number = 0;
			
			if (optionCollection) {
				for each (var option:Object in optionCollection) {
					
					switch (Settings.footerMenuButton) {
						
						case "switcher":
							
							gap = 5;
							
							item = new Switcher();
							item.label = option.title;
							
							if (DeviceInfo.os() == "iPhone") {
								item.setSize(130,48);
							}
							
							item.init();
							
							item.addEventListener(Event.CHANGE, onSort);
							
							break;
						
						case "button":
							
							gap = 0;
							
							item = ButtonBarFactory.addButtonBar(option.title,"footer");
							
							item.addEventListener(MouseEvent.CLICK, _itemClick);
							break;
						
					}	
					
					item.x = posX;
					this.addChild(item);
					
					itemCollection.push(item)
					
					posX += item.width + gap;
					item = null;
				
				}
			}
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function _itemClick(event:MouseEvent):void {
			var target:ButtonBar = event.currentTarget as ButtonBar;
			
			target.toggle = !target.toggle;
			
			var obj:Object = {source:target.title, state:target.toggle};
			
			this.dispatchEvent(new PipelineEvents(PipelineEvents.CHANGE,obj));	
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