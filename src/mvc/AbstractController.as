package mvc {
	
	//imports
	import mvc.*;
	import flash.events.EventDispatcher;
	
	/**
	 * Provides basic services for the "controller" of
	 * a Model/View/Controller triad.
	 */
	public class AbstractController extends EventDispatcher implements IController {
		
		//properties
		private var modelArray:Array;
		private var model:Observable;
		private var view:IView;
		
		/**
		 * Constructor
		 *
		 * @param   list   List of models this controller's view is observing.
		 */
		public function AbstractController(list:Array) {
			// Set the model.
			modelArray = new Array();
			
			//loop in the list suplied. test fot Obervables. Put on the list.
			for (var i:int = 0; i<list.length; i++) {
				if (list[i] is Observable) {
					setModel(list[i]);
				}
			}
		}
		
		/**
		 * Sets the model for this controller.
		 */
		public function setModel(m:Observable):void {
			//model = m;
		
			modelArray.push(m);
		}
		
		/**
		 * Returns the model for this controller.
		 */
		public function getModel(param:*):Observable {
			
			//test the parameters
			//If String than search by name
			//else, it is Number. Search by index position
			if(param is String) {
				var name:String = param;
				
				//loop
				for each(var m:Observable in modelArray) {
					if (m.name == name) {
						return m;
					}
				}
				
			} else {
				var index:int = param;
				return modelArray[index];
			}
			
			
			//if not found anything
			return null;
		}
		
		/**
		 * Sets the view that this controller is servicing.
		 */
		public function setView(v:IView):void {
			view = v;
		}
		
		/**
		 * Returns this controller's view.
		 */
		public function getView():IView {
			return view;
		}
	}
}