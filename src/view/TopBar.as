package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import events.PipelineEvents;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.assets.ShadowLine;
	import view.menu.SubMenu;
	import view.menu.TopMenuView;
	
	public class TopBar extends AbstractView {
		
		//properties
		protected var cityName:String;
		
		protected var cityNameTF:TextField;
		protected var menu:TopMenuView;
		protected var style:TextFormat;
		protected var subMenu:SubMenu;
		
		private var h:Number;

		private var bg:Shape;
		
		public function TopBar(c:IController) {			
			super(c);
			
			style = new TextFormat();
			style.font = "Myriad Pro";
			style.bold = true;
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
			
			//2.title
			var title:TextField = new TextField();
			title.selectable = false;
			title.autoSize = "left";
			title.text = "Shaping the City" + " - " + DeviceInfo.os();
			title.setTextFormat(style);
			title.x = 10;
			title.y = 8;
			
			this.addChild(title);
			
			//3.City Name
			cityNameTF = new TextField();
			cityNameTF.selectable = false;
			cityNameTF.autoSize = "left";
			cityNameTF.text = "Edmonton";
			cityNameTF.setTextFormat(style);
			cityNameTF.x = this.width - cityNameTF.width - 10;
			cityNameTF.y = 8;
			
			this.addChild(cityNameTF);
			
			//4.menu
			var options:Array = [
				{title:"Community"},
				{title:"Period"} //,
				//{title:"Filter"},
				//{title:"Group"},
				//{title:"Extra"}
			];
				
			menu = new TopMenuView(this.getController(),options);
			menu.init();
			menu.x = (this.width/2) - (menu.width/2); 
			this.addChild(menu);
			
			menu.addEventListener(PipelineEvents.SELECT, _topBarSelect);
		}
		
		protected function _topBarSelect(event:PipelineEvents):void {
			
			var type:String = event.parameters.label;
			
			if (type == "") {
				TweenMax.to(subMenu, .3, {y:bg.height -subMenu.height, onComplete:killChild, onCompleteParams:[subMenu]});
				subMenu = null;
				
			} else if (!subMenu) {
				subMenu = new SubMenu(this.getController(), type);
				subMenu.y = bg.height;
				this.addChildAt(subMenu,0);
				subMenu.init();
				TweenMax.from(subMenu, .3, {y: 0});
				
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