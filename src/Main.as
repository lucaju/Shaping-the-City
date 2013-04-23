package {
	
	//imports
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import controller.PipelineController;
	
	import model.DataModel;
	
	import settings.Settings;
	
	import util.DeviceInfo;
	
	import view.MainView;

	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	[SWF(width="1280", height="752", backgroundColor="#ffffff", frameRate="60")]
	//[SWF(width="1024", height="752", backgroundColor="#ffffff", frameRate="30")]
	public class Main extends Sprite {	
		
		//****************** Properties ****************** ****************** ****************** 
		private var dataModel						:DataModel;
		private var pipelineController				:PipelineController
		private var mainView						:MainView;
		private var background						:Sprite
		
		private var airSettings						:Settings
		
		//private var dataTreesModel:DataTreesModel;
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * 
		 * 
		 */
		public function Main() {
			
			//settings
			setting();
			
			//align
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//Models
			dataModel = new DataModel();
			
			//Controler
			pipelineController = new PipelineController([dataModel]);
			
			//View
			mainView = new MainView(pipelineController);
			mainView.setModel(dataModel);
			addChild(mainView);
			mainView.init();
			
			//background
			background = new Sprite();
			this.addChildAt(background,0);
			
			var loaderimageLoader:Loader = new Loader();
			
			loaderimageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImage)
			loaderimageLoader.load(new URLRequest("images/background2.png"));
			background.addChild(loaderimageLoader);
			
			//listener
			stage.addEventListener(Event.RESIZE, resize);
			
			//trace
			if (Settings.debug) {
				output();
			}
		}
		
		
		//****************** PRIVATE METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * 
		 */
		private function setting():void {
			airSettings = new Settings();
			//default values
			Settings.server = "local";
			Settings.platformTarget = "air";
			Settings.debug = false;
			Settings.projectPhase = "1";
		}		
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function loadImage(event:Event):void {
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;	
		}
		
		//****************** EVENTS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function resize(event:Event):void {
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;	
			
		}
		
		//****************** DEBUG ****************** ****************** ****************** 
		
		/**
		 * 
		 * 
		 */
		protected function output():void {
			trace ('{"server:""'+ Settings.server+'","platform:""'+Settings.platformTarget+'","phase":"'+Settings.projectPhase+'"}');
			trace (DeviceInfo.metrics());
		}
	}
}