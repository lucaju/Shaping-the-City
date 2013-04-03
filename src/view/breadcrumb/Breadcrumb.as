package view.breadcrumb {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Expo;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import controller.PipelineController;
	
	import events.PipelineEvents;
	
	import mvc.IController;
	
	import util.DeviceInfo;
	
	public class Breadcrumb extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		protected var bg				:Sprite
		protected var titleBG			:Sprite
		protected var typeTF			:TextField
		protected var _type				:String;
		protected var style				:TextFormat;			//Text style
		protected var crumbCollection	:Array
		protected var crumbContainer	:Sprite
		protected var gap				:Number = 5;
		protected var pController		:PipelineController;
		
		public function Breadcrumb(c:IController) {
			
			pController = PipelineController(c);
			
			style = new TextFormat();
			style.font = "Myriad Pro";
			style.color = 0xCCCCCC;
			
			typeTF = new TextField();
			typeTF.selectable = false;
			typeTF.mouseEnabled = false;
			typeTF.autoSize = "left";
			
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
		
		public function get type():String {
			return _type;
		}
		
		public function set type(value:String):void {
			_type = value;
		}
		
		protected function changeType(value:String):Boolean {
			
			if (type != value) {
				type = value;
				
				value = capitalizeFirstChar(value);
				
				typeTF.text = value + " : : ";
				typeTF.setTextFormat(style);
				
				titleBG.width = typeTF.width;
				crumbContainer.x = titleBG.width + gap;
				return true;
			}
			
			return false;
			
		}
		
		
		
		public function init(type_:String):void {
			
			type = type_;
			
			//bg
			bg = new Sprite();
			bg.graphics.beginFill(0x000000,.5);
			
			if (DeviceInfo.os() == "iPhone") {
				bg.graphics.drawRect(0,0,stage.stageWidth,40);
			} else {
				bg.graphics.drawRect(0,0,stage.stageWidth,20);
			}
			
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//type
			
			var value:String = capitalizeFirstChar(type);
			
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
			
			crumbContainer = new Sprite();
			crumbContainer.x = titleBG.width + gap;
			this.addChild(crumbContainer);
			
			crumbCollection = new Array();
		}
		
		public function update(source:String, action:String, type_:String):void {
			
			
			if (changeType(type_)) {
				clean();
			}
			
			var crumb:Crumb
			var hasCrumb:Boolean;
			
			switch (action) {
				
				case "remove":
					hasCrumb = false;
					
					for each (crumb in crumbCollection) {
					
						if (crumb.title == source) {
							TweenMax.to(crumb,.5,{alpha:0, onComplete:removeObject, onCompleteParams:[crumb]});
							crumbCollection.splice(crumbCollection.indexOf(crumb),1);
							break;
						}
					}
					
					break;
				
				case "add":
					hasCrumb = false;
					
					for each (crumb in crumbCollection) {
					
						if (crumb.title == source) {
							hasCrumb = true;
							break;
						}
					}
					
					if (!hasCrumb) {
						addCrumb(source);
					}
					
					break;
				
			}
			
			//remove if it is empty
			if (crumbCollection.length == 0) {
				
				removeBreadCrumb();
				
			}
				
			
			
		}
		
		private function removeBreadCrumb():void {
			TweenMax.to(this,.5,{y:stage.stageHeight, onComplete:killBreadCrumb});
		}		
		
		private function killBreadCrumb():void {
			this.dispatchEvent(new PipelineEvents(PipelineEvents.COMPLETE));
		}
		
		
		protected function clean():void {
			for each (var crumb:Crumb in crumbCollection) {
				TweenMax.to(crumb,.5,{alpha:0, onComplete:removeObject, onCompleteParams:[crumb,clean]});
			}
			
			crumbCollection = new Array();
		}
		
		protected function addCrumb(title:String):void {

			var crumb:Crumb = CrumbFactory.addCrumb(title);
		
			var posX:Number = 0;
			
			for each(var c:Crumb in crumbCollection) {
				posX += c.width + gap;
			}
			
			crumb.x = posX;
			
			crumbCollection.push(crumb);
			crumbContainer.addChild(crumb);
			
			TweenMax.from(crumb,2,{x:this.width,ease:Expo.easeOut,delay:1});
			
			
			crumb.addEventListener(MouseEvent.CLICK, _onClick);
		}
		
		protected function _onClick(event:MouseEvent):void {
			
			var crub:Crumb = event.currentTarget as Crumb;
			
			var data:Object = new Object();
			data.action = false;
			data.type = type;
			data.param = crub.title;
			
			pController.highlightShapes(data);
			
			this.dispatchEvent(new PipelineEvents(PipelineEvents.SELECT, data));
			
		}
		
		protected function removeObject(crumb:Crumb, clean:Boolean = false):void {
			
			crumbContainer.removeChild(crumb);
			
			if (!clean) {
				reorganize();
			}
		}
		
		protected function reorganize():void {
			
			var prev:int = 0;
			var posX:Number = 0;
			
			var newPosX:Array = new Array();
			
			for (var i:int = 0; i < crumbCollection.length; i++) {
				
				var prevPos:Number = crumbCollection[i].x;
				
				if (i==0) {
					posX = 0;
				} else {
					posX += crumbCollection[i-1].width + gap;
				}
				
				newPosX.push(posX);
				
				TweenMax.to(crumbCollection[i],1,{x:posX,ease:Bounce.easeOut,delay:i/10});
			}
			
			for (i = 0; i < crumbCollection.length; i++) {
				
			}
		}
		
		private function capitalizeFirstChar(value:String):String {
			var fisrtChar:String = value.charAt(0);
			fisrtChar = fisrtChar.toUpperCase();
			value = value.substr(1);
			
			value = fisrtChar+value;
			
			return value;
		}
		
	}
}