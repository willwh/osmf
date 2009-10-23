package ui
{
	import adobeTV.flash.PlayerTvMain;
	
	import mx.core.UIComponent;
	
	import org.osmf.media.MediaPlayer;
	
	public class Controls extends UIComponent
	{
		private var player:PlayerTvMain
		
		public function set mediaPlayer(mp:MediaPlayer):void
		{
			player = new PlayerTvMain(mp);
			addChild(player);	
			invalidateDisplayList();
		}
		
		public function Controls()
		{
				
		}
			
		protected override function updateDisplayList(w:Number, h:Number):void
		{
			if(player)
			{
				player.setSize(w,h);
			}
		}

	}
}