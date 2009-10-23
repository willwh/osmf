package adobeTV.flash.view
{
	import flash.display.Sprite;

	public class HitTestSprite extends Sprite
	{
		public function HitTestSprite()
		{
			super();
			graphics.lineStyle(1,0,0);
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,5,5);
		}
				
		
	}
}