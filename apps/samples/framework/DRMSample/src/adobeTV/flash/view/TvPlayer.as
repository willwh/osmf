package adobeTV.flash.view 
{
	import adobeTV.flash.events.PlayerEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import org.osmf.display.MediaPlayerSprite;
	import org.osmf.display.ScaleMode;
	import org.osmf.events.DurationChangeEvent;
	import org.osmf.events.PlayheadChangeEvent;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoadedContext;
	import org.osmf.net.NetLoader;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.SpatialTrait;
	import org.osmf.utils.FMSURL;
	import org.osmf.video.VideoElement;
	//import org.osmf.video.VideoElement;
	
	/**
	 * ...
	 * @author Robert Colvin
	 */
	public class TvPlayer extends Sprite
	{
		private var mp:MediaPlayer;							//media player
				
		private var ws:URLLoader;								//webservice object to make call to akamai for server/app/path to flv
				
		private var init:Boolean;									//used to obtain duration of tracking open command
		private var oldSize:Point = new Point(0, 0);		//used to store last size width and height
		
		public function get currentSize():Object {return {width:oldSize.x,height:oldSize.y}}
		
		private var file:String;									//file name of flv to be played
		private var fileID:Number;								//file id of the above file / group being played
		
		private var environment:String						//defines where the player lives dev production or stage?
		private var playerName:String						//defines the name of this player
		
		
		private var _CC:ClosedCaptioning;					//reference to the closed caption instantiation
		
		private var pageName:String;							//page name for reference
		
		private var trackElapsed:String;						//variable to track offset
		
		private var trackID:String								//Omniture id for tracking 
		
		private var oldOffset:Number;							//old playhead offset for eliminate repeat operations on same time
		
		private var embedInit:Boolean						// property to determin if player is in embeded mode to avoid YuMe ads
		
		private var mainURL:String 							//mainURL for RTMP or HTTP streams
		
		private var _volume:Number;							//Reference to current volume 
		
		private var episodeURL:String;						//episode URL to be used when in embed mode so that click will return user to AdobeTV
		
		
		private var progressive:String;						//Progressive URL of video
		private var isProgressive:Boolean = false;		//determines if stream is currently progressive
		
		private var bufferChanges:int = 0;					//stores number of buffer changes (*indicative of problem connection)
		
		
		
		private var testStarted:Boolean = false;					//determins if test is curently occuring to prevent overlap
		private var maxBandWidth:Array=[];						//stores all bandwidth results and continually generates averages to compare
		private var gLastByteCount:Number;						//stores last byte ammount to compare with new amount over n seconds
		private var delayedSeconds:int = 3;						//number of seconds before calculating new bandwidth and average
		private var minimumBW:int =  250;//800					//minimum allowed kbps before logic to switch to progressive kicks in
		
		
		
		public function TvPlayer(mp:MediaPlayer, CC:ClosedCaptioning=null) 
		{
			this.mp = mp;
			if (CC) 
			{
				_CC = CC;
			}
						
			ws = new URLLoader();
			
		}	
			
		
		
		
		/**
		 * remoting result handler updates all needed configuration
		 * @param	e
		 */
		private function remoteResult(e:Object):void 
		{
			trace("AMF call success" );
			for (var i:String in e) {trace(i + "=" + e[i]);
				for (var j:String in e[i]) trace("   "+j+ "=" + e[i][j]);
			}
			//get vars and setup the omniture object
			var urlCDN:String = e.CDNURL as String;
			var title:String = e.TITLE as String;
			progressive = e.PROGRESSIVE as String;
			var logo:Boolean = e.LOGO as Boolean;
			var cdnType:String = e.CDNNAME as String;
			var mode:String = e.MODE as String;
			//episodeURL = environmentPaths(environment).raw+e.URL as String;
			//
			trackID = e.TRACKID as String;
			//var channel:String = e.channel as String;
			pageName = e.PAGENAME as String;
			
			_CC.loadSource(e.CAPTIONS);
			
					
			var eEvent:PlayerEvent = new PlayerEvent(PlayerEvent.PLAYER_LOGO);
			eEvent.enabled = logo;
			this.dispatchEvent(eEvent);
			
			
			//go ahead and play a video
			//make webservice call
			//urlCDN = "http://adobe.edgeboss.net/flash/adobe/adobetv2/taming_the_web/17_ttw_012.flv?rss_feedid=1481&xmlvers=2";
			ws.load(new URLRequest(urlCDN));
		
		}
		
	
		
					
		/**
		 * creates player
		 * @param	url
		 */
				
		private function initPlayer(url:String):void 
		{			
			mp.addEventListener(DurationChangeEvent.DURATION_CHANGE, initDuration);
			
			mp.autoRewind = true;
			mp.addEventListener(PlayheadChangeEvent.PLAYHEAD_CHANGE, go);
			
			init = false;
		}
		/**
		 * delete later
		 * @param	num
		 */
		private function getDivisibleNumber(num:Number):Number
		{ 
			return num + (num % 2); 
		}
				
		//TODO: duration should pull from mediaPlayer
		private function initDuration(e:DurationChangeEvent):void {
			trace("duration change event");
		}
		
			
		/**
		 * standard seek call
		 */
		public function set seek(offset:Number):void
		{ 
			mp.seek(offset);
		}
			
				
		/**
		 * playhead change event via mediaplayer 
		 * @param	e
		 */
		private function go(e:PlayheadChangeEvent):void 
		{
			var duration:Number = mp.duration;
			var time:Number = e.newPosition;
			var pEvent:PlayerEvent = new PlayerEvent(PlayerEvent.PLAYHEAD_UPDATE);
			
			pEvent.current =time;
			pEvent.total = duration;
			/*
			TODO:When we get IDataTransferable, add it here.
			var stream:NetStream = NetLoadedContext(ILoadable(VideoElement(mp.source).getTrait(MediaTraitType.LOADABLE))).stream;
			if (isProgressive)
			{				
				pEvent.available = stream.bytesLoaded / stream.bytesTotal;
			}
			else
			{
				pEvent.available = (time + stream.bufferLength)/duration;					
			}
			pEvent.isProgressive = isProgressive;
			*/
			
			//keep track of current state;
			
			
			oldOffset = time;
			dispatchEvent(pEvent);						
		}

			
		/**
		 * seek to a specific percent of the total duration
		 * @param	percent
		 */
		//TODO: change below to seek via the mediaPlayer
		public function seekHead(percent:Number):void
		{
			if (mp.seekable) 
			{			
				mp.seek(mp.duration * percent);
			}			
		}
		
		/**
		 * pause or resume playback
		 * @param	pause
		 */
		//TODO: change below to pause via mediaPlayer
		public function pauseHead(pause:Boolean):void
		{
			if(mp.paused && mp.playable)
			{
				mp.play();
			}
			else if(mp.pausable)
			{
				mp.pause();
			}
			
		}
				
		public function get spatialOut():SpatialTrait {
			return null;
		}
				
		/**
		 * change volume of the playing media
		 */
		public function set volume(v:Number):void
		{
			if (mp.audible)
			{				
				mp.volume = v;	
			}				
		}
		

		
		//END CLASS
	}
	
}