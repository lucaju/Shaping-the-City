package view.breadcrumb {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Expo;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import controller.PipelineController;
	
	import events.PipelineEvents;
	
	import mvc.IController;
	
	import settings.Settings;
	
	import util.DeviceInfo;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Breadcrumb extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var _contentType		:String;					//Hold the content type of the breadcrumb
		protected var gap				:Number = 5;				//Gap between crumbs. Default = 5;
		
		protected var bg				:Sprite;
		protected var titleBG			:Sprite;
		protected var typeTF			:TextField
		protected var style				:TextFormat;
		
		protected var crumbCollection	:Array;						//Crumbs list
		protected var crumbContainer	:Sprite;					//Crumbs container
		
		protected var pController		:PipelineController;		//Controller
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function Breadcrumb(c:IController) {
			
			pController = PipelineController(c);		//Controller
			
			style = new TextFormat();
			style.font = "Myriad Pro";
			style.color = 0xCCCCCC;
			
			typeTF = new TextField();
			typeTF.selectable = false;
			typeTF.mouseEnabled = false;
			typeTF.autoSize = "left";
			
			//OS Settings
			if (Settings.subMenuOrientation == "vertical") {
				if (DeviceInfo.os() == "iPhone") {
					this.x = 328;
					style.size = 22;
				} else {
					this.x = 164;
					style.size = 11;
				}
			}
		}
		
		
		//****************** INITIALIZE ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param type
		 * 
		 */
		public function init(type:String):void {
			
			contentType = type;
			
			//bg
			bg = new Sprite();
			bg.graphics.beginFill(0x000000,.5);
			
			//OS setings
			if (DeviceInfo.os() == "iPhone") {
				bg.graphics.drawRect(0,0,stage.stageWidth,40);
			} else {
				bg.graphics.drawRect(0,0,stage.stageWidth,20);
			}
			
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//type
			
			var value:String = capitalizeFirstChar(contentType);
			
			typeTF.text = value + " : : ";
			typeTF.setTextFormat(style);
			typeTF.y = (this.height/2) - (typeTF.height/2);
			this.addChild(typeTF);
			
			//title bg
			titleBG = new Sprite();
			titleBG.graphics.beginFill(0x333333,.5);
			titleBG.graphics.drawRect(0,0,typeTF.width + gap,20);
			titleBG.graphics.endFill();
			
			this.addChildAt(titleBG,1);
			
			//Container
			crumbContainer = new Sprite();
			crumbContainer.x = titleBG.width + gap;
			this.addChild(crumbContainer);
			
			//Array
			crumbCollection = new Array();
			
			//listener
			stage.addEventListener(Event.RESIZE, resize);
		}
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get contentType():String {
			return _contentType;
		}
		
		
		//****************** SETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set contentType(value:String):void {
			_contentType = value;
		}
		
		
		//****************** PROTECTED METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param title
		 * 
		 */
		protected function addCrumb(title:String):void {
			
			//create new crumb
			var crumb:Crumb = CrumbFactory.addCrumb(title);
			
			//positioning
			var posX:Number = 0;
			
			for each(var c:Crumb in crumbCollection) {
				posX += c.width + gap;
			}
			
			crumb.x = posX;
			
			//array and container
			crumbCollection.push(crumb);
			crumbContainer.addChild(crumb);
			
			//Animation
			TweenMax.from(crumb,2,{x:this.width,ease:Expo.easeOut,delay:1});
			
			//listener
			crumb.addEventListener(MouseEvent.CLICK, _onClick);
			
			crumb = null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		protected function getCrumbByTitle(value:String):Crumb {
			for each (var crumb:Crumb in crumbCollection) {
				if (crumb.title == value) {
					return crumb;
					break;
				}
			}
			
			return null;
		}
		
		/**
		 * 
		 * @param crumb
		 * @param clean
		 * 
		 */
		protected function removeCrumb(crumb:Crumb, clear:Boolean = false):void {
			crumbContainer.removeChild(crumb);
			if (!clear) {
				reorganize();
			}
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		protected function changeContentType(value:String):Boolean {
			
			if (contentType != value) {
				contentType = value;
				
				value = capitalizeFirstChar(value);
				
				typeTF.text = value + " : : ";
				typeTF.setTextFormat(style);
				
				titleBG.width = typeTF.width;
				crumbContainer.x = titleBG.width + gap;
				
				return true;
			}
			
			return false;
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function reorganize():void {
			
			var prev:int = 0;
			var posX:Number = 0;
			
			var newPosX:Array = new Array();
			
			for (var i:int = 0; i < crumbCollection.length; i++) {
				
				var prevPos:Number = crumbCollection[i].x;
				
				if (i == 0) {
					posX = 0;
				} else {
					posX += crumbCollection[i-1].width + gap;
				}
				
				newPosX.push(posX);
				
				TweenMax.to(crumbCollection[i],1,{x:posX,ease:Bounce.easeOut,delay:i/10});
			}
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function clean():void {
			
			//remove all crumbs
			for each (var crumb:Crumb in crumbCollection) {
				TweenMax.to(crumb,.5,{alpha:0, onComplete:removeCrumb, onCompleteParams:[crumb,clean]});
			}
			
			//empty array
			crumbCollection = [];
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeBreadCrumb():void {
			TweenMax.to(this,.5,{y:stage.stageHeight, onComplete:killBreadCrumb});
		}
		
		/**
		 * 
		 * 
		 */
		protected function killBreadCrumb():void {
			this.dispatchEvent(new PipelineEvents(PipelineEvents.COMPLETE));
		}

		
		//****************** PUBLIC METHODS ****************** ******************  ******************
		
		/**
		 * 
		 * @param source
		 * @param action
		 * @param type
		 * 
		 */
		public function update(source:String, action:String, type:String):void {
			
			//Check Content type. If it is different, change it and clean up for new content type.
			if (changeContentType(type)) clean();
			
			//action Check
			switch (action) {
				
				case "remove":
					
					var crumb:Crumb = getCrumbByTitle(source);
					if (crumb) {
						TweenMax.to(crumb,.5,{alpha:0, onComplete:removeCrumb, onCompleteParams:[crumb]});
						crumbCollection.splice(crumbCollection.indexOf(crumb),1);
					}
					break;
				
				case "add":
					
					//check to not add a duplicate
					if (!getCrumbByTitle(source)) {
						addCrumb(source);
					}
					break;
				
			}
			
			//remove BreadCrumb if it is empty
			if (crumbCollection.length == 0) {
				removeBreadCrumb();
			}
				
		}
		
		
		//****************** PRIVATE METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		private function capitalizeFirstChar(value:String):String {
			var fisrtChar:String = value.charAt(0);
			fisrtChar = fisrtChar.toUpperCase();
			value = value.substr(1);
			
			value = fisrtChar+value;
			
			return value;
		}
		
		
		//****************** EVENT METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function _onClick(event:MouseEvent):void {
			
			var crumb:Crumb = event.currentTarget as Crumb;
			
			var data:Object = new Object();
			data.action = false;
			data.type = contentType;
			data.param = crumb.title;
			
			//Send data to Model via Controller
			pController.highlightShapes(data);
			
			//dispatch event to SumbMenu
			this.dispatchEvent(new PipelineEvents(PipelineEvents.SELECT, data));
			
			crumb = null;
			data = null;
		}
		
		
		//****************** EVENTS - INTERFACE ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function resize(event:Event):void {
			if (stage) bg.width = stage.stageWidth;
		}
		
	}
}