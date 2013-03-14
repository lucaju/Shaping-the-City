package view.menu {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import controller.PipelineController;
	
	import events.PipelineEvents;
	
	import model.DataModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.assets.ShadowLine;
	
	public class SubMenu extends AbstractView {
		
		//prperties
		protected var bg:Sprite;
		protected var h:Number;
		protected var _contentType:String;
		protected var data:Array;
		protected var contentContainer:AbstractSubMenuContent;
		private var shadowLine:ShadowLine;
		
		/**
		 * 
		 * @param c
		 * @param type_
		 * 
		 */
		public function SubMenu(c:IController, type_:String) {
			
			super(c);
			
			if (DeviceInfo.os() == "iPhone") {
				h = 80;
			} else {
				h = 40;
			}
			
			contentType = type_;
		}
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			//1.background
			bg = new Sprite();
			bg.graphics.beginFill(0x333333);
			bg.graphics.drawRect(0,0,stage.stageWidth,h);
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//1.2 Shadow
			shadowLine = new ShadowLine(stage.stageWidth,90);
			shadowLine.y = bg.height - shadowLine.height;
			this.addChild(shadowLine);
			
			getData();
		}
		
		
		
		/**
		 * 
		 * 
		 */
		protected function getData():void {
			var pController:PipelineController = this.getController() as PipelineController;
			data = pController.getNeighbourhoodInfo(contentType.toLowerCase());
			
			if (data != null) {
			
				switch(contentType.toLowerCase()) {
					
					case "community":
						contentContainer = new SubMenuContentNeighbourhood(data,h);
						this.addChildAt(contentContainer,1);
						contentContainer.init();
						resize();
						break;
					
					case "period":
						
						contentContainer = new SubMenuContentPeriod(data,h);
						this.addChildAt(contentContainer,1);
						contentContainer.init();
						contentContainer.x = (stage.stageWidth/2) - (contentContainer.width/2);
						resize();
						break;
					
				}
				
				
			
			} else {
				var dataModel:DataModel = pController.getModel("DataModel") as DataModel;
				dataModel.addEventListener(PipelineEvents.COMPLETE, onDataLoad);
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		private function onDataLoad(event:PipelineEvents):void {
			if (event.parameters.type == "neighbourhoods") {
				getData();
			}
		}
		
		/**
		 * 
		 * @param label
		 * 
		 */
		public function changeContent(type:String):void {
			TweenMax.to(contentContainer,.5,{alpha:0,onComplete:killDisplayObject, onCompleteParams:[contentContainer]})
			
			contentContainer = null;
			data = null;
			
			contentType = type;
			
			getData();
		}
		
		private function killDisplayObject(object:Sprite):void {
			this.removeChild(object);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get contentType():String {
			return _contentType;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set contentType(value:String):void {
			_contentType = value;
		}
		
		private function resize():void {
			trace (contentContainer.height)
			
			h = contentContainer.height;
			TweenMax.to(bg,.5,{height:contentContainer.height});
			TweenMax.to(shadowLine,.5,{y:contentContainer.height - shadowLine.height});
		}

	}
}