package mvc {
	
	//imports
	import mvc.Observable;
	
	public interface IObserver {
		function update(o:Observable, infoObj:Object):void;
		function setReg(value:int):void;
		function getReg():int;
	}
}