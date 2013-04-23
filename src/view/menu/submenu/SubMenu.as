package view.menu.submenu {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	
	import controller.PipelineController;
	
	import events.PipelineEvents;
	
	import model.DataModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.assets.ShadowLine;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class SubMenu extends AbstractView {
		
		//****************** Properties ****************** ******************  ****************** 
		protected const HORIZONAL				:String = "horizontal";
		protected const VERTICAL				:String = "vertical";
		
		protected var _orientation				:String = this.VERTICAL;			//Menu Orientation
		protected var _rangeSize				:Number = 0;						//Maximum rangeSize. Height for Horizontal and Width for vertical
		protected var _contentType				:String;							//Content Type
		protected var data						:Array;								//Content Data
		
		protected var bg						:Sprite;							//Background
		protected var shadowLine				:ShadowLine;						//Shadow Line
		protected var contentContainer			:SubMenuContent;					//Content Container
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * Constructor. 
		 * <p>Submenu extends AbstractView. It requeires a controller and contentType</p>
		 * <p>The controller is the default app controller, in this case PipelineController.</p>
		 * <p>The Content Type define which content the subMenu will laod. It can be change on runtime.</p>
		 * 
		 * @param c:Icontroller
		 * @param type_:String
		 * 
		 */
		public function SubMenu(c:IController, type_:String, orient:String = this.VERTICAL) {
			
			super(c);
			_orientation = orient;
			contentType = type_;
		}
		
		
		//****************** INIT ****************** ****************** ****************** 
		
		/**
		 * INIT: Prepare the layout out and call getData to load the data according to the current Content Type
		 * 
		 */
		public function init():void {
			
			bg = new Sprite();
			bg.graphics.beginFill(0x333333);
			
			
			//orientation
			switch (orientation) {
				
				case this.HORIZONAL:
					
					bg.graphics.drawRect(0,0,stage.stageWidth,rangeSize);
					bg.graphics.endFill();
					
					shadowLine = new ShadowLine(stage.stageWidth, orientation, 90);
					shadowLine.y = bg.height - shadowLine.height;
					
					break;
				
				case this.VERTICAL:
					
					bg.graphics.drawRect(0,0,rangeSize,stage.stageHeight - 80);
					bg.graphics.endFill();
					
					shadowLine = new ShadowLine(bg.height, orientation, 0);
					shadowLine.x = bg.width - shadowLine.width;
					
					break;
				
			}
			
			this.addChild(bg);
			this.addChild(shadowLine);
			
			getData();
			
			this.getModel().addEventListener(PipelineEvents.CHANGE, onModelChange);
		}	
		
		
		//****************** GETTERS ****************** ****************** ****************** 
		
		/**
		 * orienteation. Return SubMenu Orientation.
		 * Valid values: "vertical" or "horizontal"
		 * @return value:String
		 * 
		 */
		public function get orientation():String{
			return _orientation;
		}
		
		/**
		 * rangeSize. Return Height for Horizontal and Width for vertical
		 * @return 
		 * 
		 */
		public function get rangeSize():Number {
			return _rangeSize;
		}
		
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
		 * orienteation. Set SubMenu Orientation.
		 * Valid values: "vertical" or "horizontal"
		 * @param value:String
		 * 
		 */
		public function set orientation(value:String):void {
			_orientation = value;
		}
		
		/**
		 * rangeSize. Set Height for Horizontal and Width for vertical
		 * @param value
		 * 
		 */
		public function set rangeSize(value:Number):void {
			_rangeSize = value;
		}
		
		/**
		 * ContentType: Set the content type hold by the submenu.
		 * 
		 * @param value: String
		 * 
		 */
		public function set contentType(value:String):void {
			_contentType = value;
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
			
			switch (contentType.toLowerCase()) {
				case "community":
					data = pController.getNeighbourhoodNames();
					break;
				
				case "period":
					data = pController.getPeriods();
					break
			}
			
			if (data) {
				
				contentContainer = new SubMenuContent(data,contentType.toLowerCase(), rangeSize);
				this.addChildAt(contentContainer,1);
				
				contentContainer.orientation = this.orientation;
				
				if (orientation == "horizontal") {
					contentContainer.scrollLimit = bg.width;
				} else if (orientation == "vertical") {
					contentContainer.scrollLimit = bg.height;
				}
				
				contentContainer.init();
				
				////check for highlighted data
				var highlightedType:String = PipelineController(this.getController()).getHighlightedContentType();
				if (highlightedType && highlightedType.toLowerCase() == contentType.toLowerCase()) {
					var highlightedData:Object = new Object();
					highlightedData.type = highlightedType;
					highlightedData.action = "add";
					highlightedData.source = PipelineController(this.getController()).getHighlightedContent(highlightedType);
					contentContainer.update(highlightedData);
				}
					
				///event
				contentContainer.addEventListener(PipelineEvents.SELECT, onSelect);
				
				if (rangeSize <= 1) resize();
			
			} else {
				var dataModel:DataModel = pController.getModel("DataModel") as DataModel;
				dataModel.addEventListener(PipelineEvents.COMPLETE, onDataLoad);
			}
		}
		
		
		/**
		 * RESIZE. It resizes the base layout.
		 * 
		 */
		protected function resize():void {
			
			switch (orientation) {
				
				case this.HORIZONAL:
					TweenMax.to(bg,.5,{height:contentContainer.height});
					TweenMax.to(shadowLine,.5,{y:contentContainer.height - shadowLine.height});
					break;
				
				case this.VERTICAL:
					TweenMax.to(bg,.5,{width:contentContainer.width});
					TweenMax.to(shadowLine,.5,{x:contentContainer.width - shadowLine.width});
					break;
				
			}
			
		}
		
		
		//****************** PRIVATE METHODS  ****************** ****************** ****************** 
		
		/**
		 * KillDisplayObject. It just remove whatever Sprite pass as parameter.
		 * 
		 * @param object:Sprite
		 * 
		 */
		private function killDisplayObject(object:Sprite):void {
			this.removeChild(object);
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
			data.param = event.parameters.param;
			
			var pController:PipelineController = this.getController() as PipelineController;
			
			pController.highlightShapes(data);
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onModelChange(event:PipelineEvents):void {
			contentContainer.update(event.parameters);
		}	

	}
}