package view.util.zoom {
	
	//umports
	import com.greensock.TweenMax;
	import com.greensock.TweenProxy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ZoomModule extends AbstractView {
		
		//****************** Properties ****************** ****************** ****************** 
		
		protected var target						:Sprite;
		
		protected var zoomInBT						:ZoomBt;
		protected var zoomOutBT						:ZoomBt;
		
		protected var _currentZoom					:uint = 1;
		protected var minZoom						:uint = 1;
		protected var maxZoom						:uint = 8;
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param c
		 * @param _target
		 * 
		 */
		public function ZoomModule(c:IController, _target:Sprite) {
			super(c);
			
			target = _target;
			
			//Zoom +
			zoomInBT = new ZoomBt("plus");
			this.addChild(zoomInBT);
			
			//Zoom -
			zoomOutBT = new ZoomBt("minus");
			zoomOutBT.y = zoomInBT.height - 1;
			zoomOutBT.alpha = .7;
			this.addChild(zoomOutBT);
			
			//listener
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		
		//****************** GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentZoom():uint {
			return _currentZoom;
		}
		
		
		//****************** SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set currentZoom(value:uint):void {
			_currentZoom = value;
		}
		
		
		//****************** EVENTS ****************** ****************** ******************

		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseDown(event:MouseEvent):void {
			event.stopPropagation();
			event.stopImmediatePropagation();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function mouseUp(event:MouseEvent):void {
			
			var myProxy:TweenProxy = TweenProxy.create(target);
			myProxy.registration = myProxy.getCenter();
			
			switch (event.target.label) {
				
				case "plus":
					if (currentZoom < 1) currentZoom = 1;
					currentZoom = currentZoom*2;
					if (currentZoom >= maxZoom) {
						currentZoom = maxZoom;
						zoomInBT.alpha = .7;
					}
					
					TweenMax.to(myProxy, 1, {scaleX:currentZoom, scaleY:currentZoom});
					
					zoomOutBT.alpha = 1;
					break;
				
				case "minus":
					currentZoom = currentZoom/2;
					if (currentZoom <= minZoom) currentZoom = minZoom;
					TweenMax.to(myProxy, 1, {scaleX:currentZoom, scaleY:currentZoom});
					if (currentZoom == 1){
						
						zoomOutBT.alpha = .7;
						TweenMax.to(target, 1, {x:0, y:0});
					}
					
					zoomInBT.alpha = 1;
					break;
				
			}
			
			event.stopPropagation();
			event.stopImmediatePropagation();
			
		}		
		
		
	}
}