package org.openvideoplayer.application
{
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.Image;
	
	public class LogPanel extends LogPanelLayout
	{
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();

			clearBtn.addEventListener(MouseEvent.CLICK, onClearLogClick);
			logTrace.text = "";
		}
		
		public function onClearLogClick(event:MouseEvent):void
		{
				logTrace.text = "";
		}
	
		public function displayLogPanel():void 
		{
			this.visible = true;
		}
		
		/**
 		* Util function to trace debug information
 		*/
		public function log(p:Object, l:int):void
	   {
			if(this.visible) 
			{
			   if(parseInt(debugOption.selectedItem.data) >= l)
			   {
					logTrace.text += p + "\n";	
					logTrace.verticalScrollPosition = logTrace.maxVerticalScrollPosition;
					//return;
				}
			}
		}
	}
}