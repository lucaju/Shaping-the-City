package mvc {
	
	//imports
	import mvc.*;
	
	/**
	 * Specifies the minimum services that the "view" 
	 * of a Model/View/Controller triad must provide.
	 */
	
	public interface IView {
		function setModel (m:Observable):void;
		function getModel ():Observable;
		
		function setController (c:IController):void;
		function getController ():IController;
		
		//function defaultController (model:Observable):IController;
	}
}