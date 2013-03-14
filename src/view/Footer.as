package view {
	
	//imports
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import events.PipelineEvents;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.assets.ShadowLine;
	import view.assets.Switcher;
	import view.menu.FooterMenuView;
	
	public class Footer extends AbstractView {
		
		//properties

		protected var sortBT:Switcher;
		protected var animationBT:Switcher;
		protected var style:TextFormat;
		protected var menu:FooterMenuView;
		
		private var h:Number;
		
		public function Footer(c:IController) {
			super(c);
			
			
			style = new TextFormat();
			style.font = "Myriad Pro";
			style.color = 0x999999;
			
			if (DeviceInfo.os() == "iPhone") {
				h = 80;
				style.size = 20;
			} else {
				h = 40;
				style.size = 10;
			}
		}
		
		public function init():void {
			
			//1.background
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0x333333);
			bg.graphics.drawRect(0,0,stage.stageWidth,h);
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//1.2 Shadow
			var shadowLine:ShadowLine = new ShadowLine(stage.stageWidth, 90);
			shadowLine.y = -shadowLine.height;
			this.addChild(shadowLine)
			
			//2.credits
			var credits:TextField = new TextField();
			credits.selectable = false;
			credits.autoSize = "left";
			credits.text = "Developed by Luciano Frizzera, Sâmia Pedraça, and Edmonton Pipeline Team";
			credits.setTextFormat(style);
			credits.x = 10;
			credits.y = (bg.height/2) - (credits.height/2);
			this.addChild(credits);
			
			//3.menu
			var options:Array = [
				{title:"Sort by Size"},
				{title:"Animation"}
			];
			
			menu = new FooterMenuView(this.getController(),options);
			menu.init();
			//menu.x = (this.width/2) - (menu.width/2); 
			menu.x = this.width - menu.width - 10;; 
			menu.y = (this.height/2) - (menu.height/2); 
			this.addChild(menu);
			
			this.y = stage.stageHeight - this.height + shadowLine.height;
			
		}
		
		protected function onSort(event:Event):void {
			var target:Switcher = event.target as Switcher;
			
			var obj:Object = {source:target.label, state:target.state};
			
			this.dispatchEvent(new PipelineEvents(PipelineEvents.CHANGE,obj));
			
		}
	}
}