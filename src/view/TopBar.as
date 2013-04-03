package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import controller.PipelineController;
	
	import events.PipelineEvents;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.assets.ShadowLine;
	import view.menu.TopMenu;
	import view.menu.submenu.SubMenu;
	import view.menu.submenu.SubMenuFactory;
	
	public class TopBar extends AbstractView {
		
		//properties
		protected var cityName:String;
		
		protected var cityNameTF:TextField;
		protected var menu:TopMenu;
		protected var style:TextFormat;
		protected var subMenu:SubMenu;
		
		private var h:Number;

		private var bg:Shape;
		
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
		
		public function init():void {
			
			//1.background
			bg = new Shape();
			bg.graphics.beginFill(0x000000,.9);
			bg.graphics.drawRect(0,0,stage.stageWidth,h);
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//1.2 Shadow
			var shadowLine:ShadowLine = new ShadowLine(stage.stageWidth);
			shadowLine.y = bg.height;
			this.addChild(shadowLine);
			
			//2.City Name
			cityNameTF = new TextField();
			cityNameTF.selectable = false;
			cityNameTF.autoSize = "left";
			cityNameTF.text = "Shaping the City" + " - " + DeviceInfo.os() + " | Edmonton";
			cityNameTF.setTextFormat(style);
			cityNameTF.x = this.width - cityNameTF.width - 10;
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
			
			menu.addEventListener(PipelineEvents.SELECT, _topBarSelect);
			
		}
		
		protected function _topBarSelect(event:PipelineEvents):void {
			
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
				
				subMenu.y = bg.height;
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
		
		private function killChild(value:DisplayObject):void {
			this.removeChild(value);
			
		}
	}
}