package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import events.PipelineEvents;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import settings.Settings;
	
	import util.DeviceInfo;
	
	import view.assets.ShadowLine;
	import view.menu.TopMenu;
	import view.menu.submenu.SubMenu;
	import view.menu.submenu.SubMenuFactory;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class TopBar extends AbstractView {
		
		//****************** Properties ****************** ****************** ****************** 
		protected var bg							:Sprite;
		protected var cityName						:String;
		protected var h								:Number;			//Max Height
		
		protected var cityNameTF					:TextField;
		protected var style							:TextFormat;
		
		protected var menu							:TopMenu;
		protected var subMenu						:SubMenu;
		
				
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function TopBar(c:IController) {			
			super(c);
			
			style = new TextFormat();
			style.font = "Myriad Pro";
			style.color = 0xCCCCCC;
			
			if (DeviceInfo.os() == "iPhone") {
				h = 80;
				style.size = 42;
			} else {
				h = 40;
				style.size = 21;
			}
		}
		
		
		//****************** INITIALIZE ****************** ****************** ****************** 
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//1.background
			bg = new Sprite();
			bg.graphics.beginFill(0x000000,.9);
			bg.graphics.drawRect(0,0,stage.stageWidth,h);
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//1.2 Shadow
			var shadowLine:ShadowLine = new ShadowLine(stage.stageWidth);
			shadowLine.y = bg.height;
			bg.addChild(shadowLine);
			
			//2.City Name
			cityNameTF = new TextField();
			cityNameTF.selectable = false;
			cityNameTF.autoSize = "left";
			cityNameTF.text = "Shaping the City" + " | Edmonton";
			cityNameTF.setTextFormat(style);
			cityNameTF.x = bg.width - cityNameTF.width - 10;
			cityNameTF.y = 8;
			
			this.addChild(cityNameTF);
			
			//3.menu
			var options:Array = [
				{title:"Community"},
				{title:"Period"} //,
				//{title:"Filter"},
				//{title:"Group"},
				//{title:"Extra"}
			];
				
			menu = new TopMenu(this.getController(),options);
			menu.init();
			this.addChild(menu);
			
			//listeners
			menu.addEventListener(PipelineEvents.SELECT, topBarSelect);
			stage.addEventListener(Event.RESIZE, resize);
		}
		
		//****************** PRIVATE METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param value
		 * 
		 */
		private function killChild(value:DisplayObject):void {
			this.removeChild(value);
			
		}
		
		
		//****************** EVENTS - ACTIONS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function topBarSelect(event:PipelineEvents):void {
			
			var eventData:Object = new Object();
			var type:String = event.parameters.label;
			
			if (type == "") {
				
				switch (Settings.subMenuOrientation) {
					case "vertical":
						TweenMax.to(subMenu, .3, {x:-subMenu.width, onComplete:killChild, onCompleteParams:[subMenu]});
						break;
					
					case "horizontal":
						TweenMax.to(subMenu, .3, {y:bg.height -subMenu.height, onComplete:killChild, onCompleteParams:[subMenu]});
						break;
				}
				
				subMenu = null;
				
				//Send event
				
				eventData.action = "submenuClose";
				this.dispatchEvent(new PipelineEvents(PipelineEvents.RESIZE, eventData));
				
				
			} else if (!subMenu) {
				
				subMenu = SubMenuFactory.subMenu(this.getController(), type, Settings.subMenuOrientation);
				subMenu.setModel(this.getModel());
				
				subMenu.y = h;
				this.addChildAt(subMenu,0);
				subMenu.init();
				
				switch (Settings.subMenuOrientation) {
					case "vertical":
						TweenMax.from(subMenu, .3, {x: -subMenu.width});
						break;
					
					case "horizontal":
						TweenMax.from(subMenu, .3, {y: 0});
						break;
				}
				
				//Send event
				eventData.action = "submenuOpen";
				this.dispatchEvent(new PipelineEvents(PipelineEvents.RESIZE, eventData));
				
			} else {
				
				subMenu.changeContent(type)
			}
			
			type = null;
			
		}
		
		
		//****************** EVENTS - INTERFACE ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function resize(event:Event):void {
			bg.width = stage.stageWidth;
			cityNameTF.x = bg.width - cityNameTF.width - 10;
		}
	}
}