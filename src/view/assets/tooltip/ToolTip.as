package view.assets.tooltip {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import view.style.TXTFormat;
	
	public class ToolTip extends Sprite{	
		
		// properties
		private var _id:int;							// Article's id

		private var maxWidth:Number = 150;				// Balloon max width
		private var minHeight:Number = 20;				// Balloom min height
		private var round:Number = 10;					// Round corners
		private var margin:Number = 2;					// Margin size
		private var _arrowDirection:String = "bottom";	// Arrow point direction

		private var shapeBox:Balloon;					//Shape of the balloon;
		
		private var titleTF:TextField;					// Title Textfield
		private var titleStyle:TextFormat = new TextFormat("Arial Narrow", 12, 0x646363,true,null,null,null,null,"center");
		
		
		//Constructor
		public function ToolTip(idValue:int = 0) {
			
			//save properties
			_id = idValue;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function initialize(data:Object):void {
			
			var target:Sprite = data.target;
			
			//set position
			var targetPoint:Point = new Point(this.x, this.y)
			var targetGlobalPos:Point = target.localToGlobal(targetPoint);

			this.x = targetGlobalPos.x + (target.width/2)			
			
			switch (_arrowDirection) {
				case "top":
					this.y = targetGlobalPos.y + target.height;
					break;
				
				default:
					this.y = targetGlobalPos.y;
					break;
			}
			
			
			
			//----------title
			titleTF = new TextField();
			titleTF.selectable = false;
			titleTF.autoSize = "center";
			titleTF.text = " " + data.title + " ";
			titleTF.setTextFormat(TXTFormat.getStyle("General Label"));
			
			titleTF.x = margin;
			titleTF.y = margin;
			
			addChild(titleTF);
			
			//shape
			shapeBox = new Balloon(titleTF.width + (2 * margin), titleTF.height + (1 * margin));
			addChildAt(shapeBox,0);
			
			//elements Position
			shapeBox.x = -shapeBox.width/2;
			shapeBox.y = -shapeBox.height;
			
			titleTF.x = shapeBox.x + margin;
			titleTF.y = shapeBox.y + margin;
			
			TweenMax.from(this,.5,{autoAlpha:0, y:this.y + 5, delay:2});
		}
		
		private function _closebutton(e:MouseEvent):void {
			//workflowController.killBalloon(id)
		}
		
		
		//------- gets
		
		public function get id():int {	
			return _id;
		}

		public function get arrowDirection():String {
			return _arrowDirection;
		}


	}
}