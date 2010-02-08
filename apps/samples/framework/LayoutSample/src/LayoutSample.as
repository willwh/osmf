package 
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.composition.ParallelElement;
	import org.osmf.containers.MediaContainer;
	import org.osmf.display.ScaleMode;
	import org.osmf.image.ImageElement;
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.LayoutRendererProperties;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.utils.URL;
	import org.osmf.video.VideoElement;

	[SWF(backgroundColor="0x000000", frameRate="25", width="640", height="360")]
	public class LayoutSample extends Sprite
	{
		public function LayoutSample()
		{
			// Contstruct and image element:
			var logo:ImageElement = new ImageElement(new URLResource(LOGO_PNG));
			logo.smoothing = true;

			// Construct a layout properties object for the logo:			
			var logoLayout:LayoutRendererProperties = new LayoutRendererProperties(logo);
			
			// Set the image to take 30% of its parent's width and height: 
			logoLayout.percentWidth = 30;
			logoLayout.percentHeight = 30;
			
			// Position the image's bottom-right corner 20 pixels away from
			// the container's bottom-right corner:
			logoLayout.bottom = 20;
			logoLayout.right = 20;
			
			// Set the image to scale, keeping aspect ratio:
			logoLayout.scaleMode = ScaleMode.LETTERBOX;
			
			// Instruct the image to be moved to the right hand side, should
			// any surplus horizontal space be available after scaling:
			logoLayout.horizontalAlignment = HorizontalAlign.RIGHT;
			
			// Set an order value for the image: elements with the highest
			// order appear on top in the display stack:
			logoLayout.order = 1;
			
			// Construct a video element:
			var video:MediaElement = new VideoElement(new URLResource(LOGO_VID));
			
			// If no layout properties have been set on an element when it gets
			// added to a parent, then the the parent will set the target to
			// scale letter-box mode, vertical alignment to center, horizontal
			// alignment to middle, and set width and height to 100% of the
			// parent. This is fine for the video element at hand, so no additional
			// layout properties are set for it.		
			
			// Construct a parallel element that holds both the video and the
			// logo still:
			var parallel:ParallelElement = new ParallelElement();
			MetadataUtils.setElementId(parallel.metadata, "parallel");
			parallel.addChild(video);
			parallel.addChild(logo);
			
			// Construct a container that will display the parallel media
			// element:
			var container:MediaContainer = new MediaContainer()
			MetadataUtils.setElementId(container.metadata, "container");
			container.width = stage.stageWidth
			container.height = stage.stageHeight;
			container.addMediaElement(parallel);
			addChild(container);
			
			// Construct a player to load and play the parallel element:
			var player:MediaPlayer = new MediaPlayer(parallel);
			player.loop = true;
		}
		
		private static const LOGO_PNG:URL = new URL("http://dl.dropbox.com/u/2980264/OSMF/logo_white.png");
		private static const LOGO_VID:URL = new URL("http://dl.dropbox.com/u/2980264/OSMF/logo_animated.flv");
	}
}
