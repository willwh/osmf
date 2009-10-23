package adobeTV.flash.utils
{
		
	import adobeTV.flash.PlayerTvMain;
	import adobeTV.flash.events.ScrubEvent;
	import adobeTV.flash.view.ToolTip;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
		
	
	public class Scrubs extends Sprite
	{		
		private var marginBG:DisplayObject; 															//sprite to contain the bitmap created from the library bitmapdata.
		private var activeBar:Sprite;															//visual representation for the portion of the bg bar already used
		private var currentAvailable:Sprite;													//used only for feature will load infront of bar to show what can be used
		//private var bufferBar:Sprite;														
		
		private var containAll:Sprite;															//contains all controlls except the background
		private var containView:Sprite;   													//property to be masked
		
		private var tolerance:int = 4;															//tollerance for positioning
		
		private var masker:Sprite;																//mask for the existing scrub bar components																
		
		public var oldSize:Object = { w:11, h:11 };										//used to retain memory of old size during resize
		public var available:Number;															//number to keep the total possible scrub value (*for volume this would be 1)
		
		public var dragable:Sprite;																//thumb for the scrub bar
		public var bg:Sprite;																		//background for the scrubbable area
		
		private var dragging:Boolean;															//place holder to identify if the thumb/draggable is currently being dragged
		
		public var icon:DisplayObject = null;												//optional icon
		
		
		private var currentPercent:Number;												//current percent of thumb used when resizing and paused
		private var oldPercent:Number;														//current percent of thumb used when resizing and paused
		
		
		private var lastHint:ToolTip = null;													//used to keep reference to tooltip as changes are made
		
		
		override public function get width():Number { return  oldSize.w;	}
		
		/**
		 * constructor initializes setup for all controls
		 */	
		public function Scrubs() 
		{
			containAll = new Sprite();
						
			var main:PlayerTvMain; 
			marginBG = new (PlayerTvMain.btn_bg_UP)();
			marginBG.y = 1;
			
			bg = new Sprite();
			var ds:DropShadowFilter = new DropShadowFilter(2,45, 0x000000, .8, 2, 2, .6, 1, true);
			bg.filters = [ds];
						
			activeBar = new Sprite();
			
			currentAvailable = new Sprite();
			
			containView = new Sprite();
			
			dragable = new Sprite();
			PlayerTvMain.square(dragable.graphics, { x:0, y:0, width:Math.round(oldSize.h*1.5), height:oldSize.h }, 1, 0x686868, 1, 1, 0xE5E5E5);
			addControlListeners();
			
			containView.addChild(currentAvailable);
			containView.addChild(activeBar);
						
			containAll.addChild(bg);
			containAll.addChild(containView);
			containAll.addChild(dragable);
			
			this.addChild(marginBG);
			this.addChild(containAll);
		}
		
		/**
		 * adds listeners for the draggable areas
		 */
		private function addControlListeners():void
		{
			bg.addEventListener(MouseEvent.CLICK, barClicked, false, 0, true);
			activeBar.addEventListener(MouseEvent.CLICK, barClicked, false, 0, true);
			currentAvailable.addEventListener(MouseEvent.CLICK, barClicked, false, 0, true);
			dragable.addEventListener(MouseEvent.MOUSE_DOWN, dragStart, false, 0, true);
			dragable.addEventListener(MouseEvent.MOUSE_UP, dragStop, false, 0, true);
		}
		
		
		/**
		 * sets the size of the scrub bar with proper positioning
		 * */
		public function setSize(w:Number, h:Number):void 
		{
			h = 11;
			oldSize.w = w;
			oldSize.h = h;
			marginBG.width = w;
			marginBG.height = 21;
			if (icon) w = w - icon.width + tolerance * 2;
			
			PlayerTvMain.square(bg.graphics, { x:0, y:0, width:w-tolerance*4, height:h }, 1, 0x686868,1, 1, 0x8A8A8A);
			
			containAll.y = marginBG.y + tolerance * .5 + (marginBG.height - bg.height) * .5;
			containAll.x = (icon?icon.width: tolerance * 2);
			
			if (oldPercent == currentPercent) 
			{
				dragable.x = (bg.width-dragable.width) * currentPercent ;
				updateActiveBar(dragable.x, h);
			}
			oldPercent = currentPercent;
		}
		

		/**
		 * draw bagraound for currentAvailable sprite
		 */
		public function set totalAvailable(percent:Number):void 
		{
			if (isNaN(percent)) return;
			PlayerTvMain.square(currentAvailable.graphics, { x:0, y:0, width:bg.width*percent, height:11 }, 0, 0xFFFFFF,.3, 0, 0x16472F);
		}
		
		/**
		 * moves the thumb according to the percentage change relative to its background
		 * @param	current
		 * @param	total
		 */
		public function updatedragable(current:Number, total:Number, progressive:Boolean = false ):void {
			if (dragging) return;
			available = total;
			var percent:Number = current / total;
			currentPercent = percent;
			dragable.x = (bg.width-dragable.width) * percent ;
			updateActiveBar(dragable.x, oldSize.h);
		}
		
		/**
		 * triggered when draging has stopped, user let go of thumb/draggable
		 * @param	e
		 */
		protected function dragStop(e:MouseEvent):void 
		{
			dragable.stopDrag();		
			dragable.stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragableMove, false);
			dragable.stage.removeEventListener(MouseEvent.MOUSE_UP, dragStop, false);
			updateActiveBar(dragable.x, oldSize.h);
			lastHint = null;
			dragging = false;
			var sEvent:ScrubEvent = new ScrubEvent(ScrubEvent.SEEK_COMMITED);
			sEvent.percent = dragable.x / (bg.width - dragable.width);
			this.dispatchEvent(sEvent);
		}
		/**
		 * triggered when user has clicked on draggable/thumb to start dragging
		 * @param	e
		 */	
		protected function dragStart(e:MouseEvent):void 
		{
			dragging = true;
			var rect:Rectangle = new Rectangle(0, 0, bg.width-dragable.width, 0);
			dragable.startDrag(false, rect);		
			
			dragable.stage.addEventListener(MouseEvent.MOUSE_UP, dragStop, false, 0, true);
			dragable.stage.addEventListener(MouseEvent.MOUSE_MOVE, dragableMove, false, 0, true);
			
			var sEvent:ScrubEvent = new ScrubEvent(ScrubEvent.SEEK_START);
			this.dispatchEvent(sEvent);
		}
		
		/**
		 * triggered when user starts moving the draggable/thumb
		 * @param	e
		 */
		protected function dragableMove(e:MouseEvent):void 
		{
			
			updateActiveBar(dragable.x, bg.width);
			thumbDragHandler(dragable.x / (bg.width - dragable.width));
			var sEvent:ScrubEvent = new ScrubEvent(ScrubEvent.SEEK_CHANGING);
			sEvent.percent = dragable.x / (bg.width - dragable.width);
			this.dispatchEvent(sEvent);
		}
		
		/**
		 * redraws the activebar which shows what has already been used before the thumb/draggable
		 * @param	w
		 * @param	h
		 */
		private function updateActiveBar(w:Number, h:Number):void {
			PlayerTvMain.square(activeBar.graphics, { x:0, y:0, width:w, height:oldSize.h}, 1, 0x686868, 1, 1, 0xE9E9E9);
		}
		
		/**
		 * dispatch function to alert of the new percentage produced from the thumbs current position
		 * @param	event
		 * @param	percent
		 */
		private function dispatchScrubEvent(event:String,percent:Number=-1):void {
			var sEvent:ScrubEvent = new ScrubEvent(event);
			sEvent.percent = percent==-1?(dragable.x) / (bg.width-dragable.width) : percent;
		
		}
		
		/**
		 * triggered when any part of the scrub bar background is clicked
		 * @param	e
		 */
		protected function barClicked(e:MouseEvent):void 
		{
			//trace("bar clicked");
			
			var newX:Number=containAll.mouseX - (dragable.width * .5);
			dragable.x = newX<0?0:(newX>bg.width-dragable.width?bg.width-dragable.width:newX);
			
			updateActiveBar(dragable.x, oldSize.h);
			var sEvent:ScrubEvent = new ScrubEvent(ScrubEvent.SEEK_CHANGING);
			sEvent.percent = dragable.x / (bg.width - dragable.width);
			this.dispatchEvent(sEvent);
			
		}
			
		/**
		 * invoked while dragging occurs and percentages are updated accordingly
		 * @param	percent
		 * @param	valueS
		 */
		protected function thumbDragHandler(percent:Number, valueS:String=null):void 
		{
			//temp changes
			//trace(e.target.name);
			var value:int = percent * 100;
			var valueString:String =  (valueS==null?value + "%":valueS);
			if (lastHint == null) {
				var hint:ToolTip = PlayerTvMain.toolTipShow(this as DisplayObject, valueString,100,-1,-10,-20,null,true);
				lastHint = hint;
				hint.hook = true;
				hint.hookSize = 4;
			}else {
				lastHint.setContent(valueString);
			}
		}
		
		//END CLASS
	}
	
}
