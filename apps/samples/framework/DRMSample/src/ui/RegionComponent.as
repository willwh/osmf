package ui
{
	import mx.core.UIComponent;
	
	import org.osmf.display.MediaPlayerSprite;
	import org.osmf.layout.LayoutUtils;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;

	public class RegionComponent extends UIComponent
	{
		private var _mediaPlayerSprite:MediaPlayerSprite;
		
		public function RegionComponent()
		{
			super();		
			_mediaPlayerSprite = new MediaPlayerSprite();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			addChild(_mediaPlayerSprite);
		}
		
		[Bindable]
		public function set element(value:MediaElement):void
		{
			_mediaPlayerSprite.element = value;
		}
		
		public function get element():MediaElement
		{
			return _mediaPlayerSprite.element;
		}
				
		public function get mediaPlayer():MediaPlayer
		{
			return _mediaPlayerSprite.mediaPlayer;
		}
						
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w,h);
			_mediaPlayerSprite.setAvailableSize(w, h);			
		}
		
	}
}