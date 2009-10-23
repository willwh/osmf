package adobeTV.flash.view 
{
	import adobeTV.flash.utils.Scrubs;
	
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Robert Colvin
	 */
	public class ScrubBar extends Scrubs
	{
		
		private var percentMark:Number=-1;								//used to keep the scrubbar from skipping when a new scrub point is selected.
		
		
		public function ScrubBar() 
		{
			super();
		}
		

		override public function updatedragable(current:Number, total:Number, isProgressive:Boolean=false):void {
			var percent:Number = current / total;	
			if (percentMark == -1) {
				super.updatedragable(current, total);
			}else {
				if (isProgressive) {
						super.updatedragable(current, total);
						percentMark = -1
				}else{
					if (percent>=percentMark-.004 && percent<=percentMark+.004) {
						super.updatedragable(current, total);
						percentMark = -1
					}
				}
			}
		}
		
		
		override protected function thumbDragHandler(percent:Number, valueS:String=null):void {
			super.thumbDragHandler(percent, ElapsedTime.convertTime(available*percent)	);
		}
		
		
		override protected function dragStop(e:MouseEvent):void {
			super.dragStop(e);
			percentMark = dragable.x / (bg.width - dragable.width);
			
		}
		
		override protected function barClicked(e:MouseEvent):void {
			super.barClicked(e);
			percentMark = dragable.x / (bg.width - dragable.width);
		}
		
		//END CLASS
	}	
}