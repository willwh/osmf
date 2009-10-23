package adobeTV.flash.view 
{
	import adobeTV.flash.PlayerTvMain;
	import adobeTV.flash.events.ScrubEvent;
	import adobeTV.flash.utils.Scrubs;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Robert Colvin
	 */
	public class VolumeBar extends Scrubs
	{
		private var isVertical:Boolean = true;				//currently not used but could permit UI to become vertical
		
		private var volume_btn:Button;						//mute, unmute option
		
		private var volume_last:Number = -1;				//last volume property used to restore last value when unmuted
		private var mTimer:Timer;								//timer to set volume to last set using Local shared object
		
		/**
		 * getter to obtain current volume if not found it pulls from sharedObject
		 * using the getStoredVolume method
		 */
		public function get volume():Number 
		{			
			return volume_last
		}
		
		public function set volume(value:Number):void
		{
			this.updatedragable(value, 1);			
			volume_last = value;
		}
			
		public function VolumeBar() 
		{			
			super();	
			mTimer = new Timer(900,3);
			
			
			volume_btn = PlayerTvMain.buttonCreate("", "volume", 22, "vLOW", this, 3, clicked);
			volume_btn.y = 2;
			this.icon = volume_btn;
			
			this.setSize(90, 22);
			scrubReturn();
			
			mTimer.start();
		}
			
		
		/**
		 * dispatches even for current percent only upon initialization
		 */
		private function scrubReturn():void
		{
			updatedragable(volume, 1);
			var sEvent:ScrubEvent = new ScrubEvent(ScrubEvent.SEEK_COMMITED);
			sEvent.percent =volume;
			this.dispatchEvent(sEvent);
			updateIcon(volume);
		}
		
		/**
		 * direction the slider should slide
		 * vertical direction is considered compact with mouse over required to make component visible
		 */
		public function set layoutDirection(_isVertical:Boolean):void
		{
			isVertical = _isVertical;	
		}
		
		/**
		 * sets the size of the volume bar based on the width and height given
		 * @param	w
		 * @param	h
		 */
		override public function setSize(w:Number, h:Number):void 
		{
			super.setSize(w, h);
		}
				
		/**
		 * handler for when the volumeMute button is toggled
		 * @param	e
		 */
		private function clicked(e:MouseEvent):void 
		{
			var percent:Number;
			if (volume_btn.name == "volume"){
				volume_btn.name = "volume2";
				percent = 0;
			}else {
				percent = volume;
				volume_btn.name = "volume";				
			}
			updatedragable(percent, 1);
			updateIcon(percent);
			var sEvent:ScrubEvent = new ScrubEvent(ScrubEvent.SEEK_COMMITED);
			sEvent.percent =percent
			this.dispatchEvent(sEvent);
		}
		
		/**
		 * when bar is selected
		 * updates volume local shared object based on current value
		 * @param	e
		 */	
		override protected function barClicked(e:MouseEvent):void 
		{
			super.barClicked(e);
			updateVolume();
		}
		
		/**
		 * when thumb is moved
		 * updates volume local shared object based on current value
		 * @param	e
		 */
		override protected function dragableMove(e:MouseEvent):void 
		{
			super.dragableMove(e);
			updateVolume();
		}
		
		/**
		 * updates shared object data for volume
		 */
		private function updateVolume():void 
		{
			var percent:Number = dragable.x / (bg.width - dragable.width);
			updateIcon(percent);
			
			volume_last = percent;
		}
		
		/**
		 * changes icon in button based on current volume percentage
		 * @param	percent
		 */
		private function updateIcon(percent:Number):void 
		{
			if(percent>0 && percent<=.30) {
				volume_btn.icon =  PlayerTvMain.convert2Class("vLOW") ;	
			}else if (percent>.30 && percent <= .60) {
				volume_btn.icon =  PlayerTvMain.convert2Class("vMID") ;	
			}else if (percent > .60) {
				volume_btn.icon =  PlayerTvMain.convert2Class("vHI") ;	
			}else {
				volume_btn.icon =  PlayerTvMain.convert2Class("vOFF") ;	
			}
		}
		
		
	}
	
}