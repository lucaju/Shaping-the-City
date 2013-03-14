package view.menu {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import controller.PipelineController;
	
	import events.PipelineEvents;
	
	import model.DataModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.assets.ShadowLine;
	
	public class SubMenu extends AbstractView {
		
		//****************** properties ****************** ******************  ****************** 
		protected var h					:Number;
		protected var _contentType		:String;
		protected var data				:Array;
		protected var bg				:Sprite;
		protected var shadowLine		:ShadowLine;
		protected var contentContainer	:AbstractSubMenuContent;
		
		
		/**
		 * Constructor. 
		 * <p>Submenu extends AbstractView. It requeires a controller and contentType</p>
		 * <p>The controller is the default controller for the app, in this case PipelineController.</p>
		 * <p>The Content Type define which content the subMenu will laod. It can be change on runtime.</p>
		 * 
		 * @param c:Icontroller
		 * @param type_:String
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
		
		//****************** GETTERS ****************** ****************** ****************** 
		
		/**
		 * ContentType: Returns the current content type hold by the submenu.
		 * 
		 * @return String
		 * 
		 */
		public function get contentType():String {
			return _contentType;
		}
		
		//****************** SETTERS ****************** ****************** ****************** 
		/**
		 * ContentType: Set the content type hold by the submenu.
		 * 
		 * @param value: String
		 * 
		 */
		public function set contentType(value:String):void {
			_contentType = value;
		}
		
		//****************** INIT ****************** ****************** ****************** 
		
		/**
		 * INIT: Prepare the layout out and call getData to load the data according to the current Content Type
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
		
		
		//****************** PRIVATE METHODS ****************** ****************** ****************** 
		
		
		/**
		 * RESIZE. It resizes the base layout.
		 * 
		 */
		private function resize():void {
			
			h = contentContainer.height;
			TweenMax.to(bg,.5,{height:contentContainer.height});
			TweenMax.to(shadowLine,.5,{y:contentContainer.height - shadowLine.height});
		}
		
		/**
		 * KillDisplayObject. It just remove whatever Sprite pass as parameter.
		 * 
		 * @param object:Sprite
		 * 
		 */
		private function killDisplayObject(object:Sprite):void {
			this.removeChild(object);
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ****************** 
		
		/**
		 * GetData. Send a request to Controller to get teh current type data.
		 * <p>If the data is not available, it adds a eventlistener to wait for the content.</p>
		 * <p>Add subMenuContent and start a listener to wait for selection.</p>
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
						break;
					
					case "period":
						contentContainer = new SubMenuContentPeriod(data,h);
						this.addChildAt(contentContainer,1);
						contentContainer.init();
						contentContainer.x = (stage.stageWidth/2) - (contentContainer.width/2);
						break;
					
				}
				
				
				contentContainer.addEventListener(PipelineEvents.SELECT, onSelect);
				resize();
			
			} else {
				var dataModel:DataModel = pController.getModel("DataModel") as DataModel;
				dataModel.addEventListener(PipelineEvents.COMPLETE, onDataLoad);
			}
		}
		
		
		//****************** PUBLIC METHODS  ****************** ****************** ****************** 
		/**
		 * ChangeContent. The submemnu content can be changed from outside.
		 * <p>This methods clean submenu conten and calls for the new data</p>
		 * 
		 * @param label:String
		 * 
		 */
		public function changeContent(type:String):void {
			TweenMax.to(contentContainer,.5,{alpha:0,onComplete:killDisplayObject, onCompleteParams:[contentContainer]})
			
			contentContainer = null;
			data = null;
			
			contentType = type;
			
			getData();
		}
		
		
		//****************** EVENT HANDLES  ****************** ****************** ****************** 
		
		/**
		 * onDataLoad. It calls for load data whenever the data is ready.
		 * 
		 * @param event:PipelineEvents
		 * 
		 */
		private function onDataLoad(event:PipelineEvents):void {
			if (event.parameters.type == "neighbourhoods") {
				getData();
				event.target.removeEventListener(PipelineEvents.COMPLETE, onDataLoad);
			}
		}
		
		/**
		 * OnSelect. Treeat the data from selected submenu item.
		 * 
		 * @param event:PipelineEvents
		 * 
		 */
		protected function onSelect(event:PipelineEvents):void {
			var data:Object = new Object();
			data.action = event.parameters.action;
			data.type = event.parameters.type;
			
			var pController:PipelineController = this.getController() as PipelineController;
			
			
			switch(event.parameters.type) {
				
				case "neighbourhood":
					data.param = pController.getNeighbourhoodIDByName(event.parameters.param);
					break;
				
				case "period":
					var st:String = event.parameters.param;
					var ar:Array = st.split(" - ");
					
					var pStart:int = ar[0];
					var pEnd:int = ar[1];
					
					data.param = pController.getNeighbourhoodIDsByPeriod(pStart,pEnd);
					
					st = null;
					ar = null;
					
					break;
			}
			
			//action
			pController.highlightShapes(data);
		}

	}
}