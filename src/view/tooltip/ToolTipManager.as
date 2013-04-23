package view.tooltip {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	public class ToolTipManager{	
		
		//****************** Properties ****************** ******************  ****************** 
		
		static protected var _toolTipBaseColor				:uint 	= 0xFFFFFF;			//Balloon Color
		static protected var _toolTipBaseAlpha				:Number = 1;				//Balloon Alpha
		static protected var _toolTiptextColor				:uint	= 0x000000;			//Text Color
		
		static protected var target							:Stage;
		static protected var toolTip						:ToolTip;
		static protected var toolTipCollection				:Array;
		
		
		//****************** Contructor ****************** ******************  ****************** 
		
		public function ToolTipManager(target_:Stage) {
			target = target_;
		
			_toolTipBaseColor = 0x000000;
			_toolTipBaseAlpha = .6;
			_toolTiptextColor = 0xFFFFFF;
			
			toolTipCollection = new Array();
			
			target.stage.addEventListener(MouseEvent.CLICK, removeToolTip);
		}
		
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get hasTootlTip():Boolean {
			
			if (toolTip) {
				return true;	
			}
			
			return false;
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  *****************
		
		/**
		 * 
		 * @param data
		 * 
		 */
		static public function addToolTip(data:Object, direction:String = "bottom"):void {
			if (hasTootlTip) {
				removeToolTip();	
			}
			
			toolTip = ToolTipFactory.addToolTip();
			toolTip.balloonColor = _toolTipBaseColor;
			toolTip.balloonAlpha = _toolTipBaseAlpha;
			toolTip.textColor = _toolTiptextColor;
			toolTip.arrowDirection = direction;
			toolTip.init(data, toolTipCollection.length);
			target.addChild(toolTip);
			
			toolTipCollection.push();
			
			//set position
			toolTip.x = data.position.x + (data.dimension.x/2)			
			
			switch (direction) {
				case "top":
					toolTip.y = data.position.y + data.dimension.y + toolTip.height + 5;
					break;
				
				case "bottom":
					toolTip.y = data.position.y + (data.dimension.y/4);
					break;
			}
			
			TweenMax.from(toolTip,.5,{autoAlpha:0, y:toolTip.y + 5});
			
		}
		
		/**
		 * 
		 * @param speedX
		 * @param speedY
		 * 
		 */
		static public function moveToolTip(speedX:Number, speedY:Number):void {
			if (toolTip) {
				toolTip.x += speedX;
				toolTip.y += speedY;
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		static public function removeToolTip(event:MouseEvent = null):void {
			if (hasTootlTip) {
				target.removeChild(toolTip);
				toolTip = null;
			}
		}
		
	}
}