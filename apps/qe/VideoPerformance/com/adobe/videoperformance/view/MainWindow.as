package com.adobe.videoperformance.view
{
	import com.adobe.videoperformance.control.VideoRunner;
	import com.adobe.videoperformance.events.StageDisplayEvent;
	import com.adobe.videoperformance.events.StageDisplayObjectEvent;
	import com.adobe.videoperformance.model.Model;
	
	import flash.display.DisplayObject;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class MainWindow extends MainWindowLayout
	{
		// Public Interface
		//
		
		public function MainWindow()
		{
			doubleClickEnabled = true;			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function run(model:Model):void
		{			
			runner = new VideoRunner(model);
			runner.addEventListener(StageDisplayObjectEvent.ADD_CHILD_REQUEST,onAddChildRequest);
			runner.addEventListener(StageDisplayEvent.STAGE_DISPLAY_EVENT, onStageDisplayState);
			runner.run();			
		}
		
		private function onAddedToStage(..._):void
		{
			stage.doubleClickEnabled = true;
			stage.displayState = lastStageDisplay;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
		} 
		
		private function onDoubleClick(event:MouseEvent):void
		{
			onStageDisplayState(new StageDisplayEvent(StageDisplayState.FULL_SCREEN, event.shiftKey, StageDisplayEvent.STAGE_DISPLAY_EVENT)); 
		}
		
		// Internals
		//
		
		private var model:Model;
		private var runner:VideoRunner;
		private var lastStageDisplay:String;
		private var displayChild:DisplayObject;
		private var hardwareScaled:Boolean;
			
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			if(displayChild)
			{
				if(stage.displayState == StageDisplayState.FULL_SCREEN && !hardwareScaled)
				{
					displayChild.width = w;
					displayChild.height = h;
				}
				else
				{
					displayChild.width = runner.width;
					displayChild.height = runner.height;
				}
			}
		}
				
		
		private function onAddChildRequest(event:StageDisplayObjectEvent):void
		{
			if (!rawChildren.contains(event.child))
			{				
				displayChild = rawChildren.addChild(event.child);
			}
		}
		
		private function onStageDisplayState(event:StageDisplayEvent):void
		{
			if(stage)
			{
				if(stage.displayState != event.newState)
				{	
					hardwareScaled = event.hardwareScaled;				
					if(event.hardwareScaled && displayChild)
					{	
						displayChild.width = runner.width;
						displayChild.height = runner.height;						
						stage.fullScreenSourceRect = new Rectangle(0,0,runner.width, runner.height);						
					}				
					
					stage.displayState = event.newState;				
				}	
			}	
			lastStageDisplay = event.newState;
		}
		
	}
}