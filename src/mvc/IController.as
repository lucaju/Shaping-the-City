package mvc {
	
	//imports
	import mvc.*;
	
	/**
	 * Specifies the minimum services that the "controller" of
	 * a Model/View/Controller triad must provide.
	 */
	public interface IController {
		/**
		 * Sets the model for this controller.
		 */
		function setModel(m:Observable):void;
		
		/**
		 * Returns the model for this controller.
		 */
		function getModel(param:*):Observable;
		
		/**
		 * Sets the view this controller is servicing.
		 */
		function setView(v:IView):void;
		
		/**
		 * Returns this controller's view.
		 */
		function getView():IView;
	}
}