package org.openvideoplayer.application
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	
	import org.openvideoplayer.audio.AudioElement;
	import org.openvideoplayer.composition.ParallelElement;
	import org.openvideoplayer.composition.SerialElement;
	import org.openvideoplayer.events.PlayheadChangeEvent;
	import org.openvideoplayer.events.VolumeChangeEvent;
	import org.openvideoplayer.image.*;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.CompositionMediaFactory;
	import org.openvideoplayer.video.VideoElement;
	import org.openvideoplayer.display.ScaleMode;
	
	public class PlaylistPanel extends PlaylistPanelLayout
	{
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			logPanel = new LogPanel();	
			
			
			compositionMedia.addEventListener(Event.CLOSE, onCompositionSelected);
			compositionMedia.dataProvider = compositeMediaArray;
			
			playlistsComboBox.addEventListener(Event.CLOSE, onPlaylistsSelected);
			playlistsComboBox.dataProvider = playlistsArray;
			
			mediaControlPanel.loadBtn.addEventListener(MouseEvent.CLICK, onLoad);		
					
			mediaControlPanel.mediaBtns.playBtn.addEventListener(MouseEvent.CLICK, onPlayBtn);
			mediaControlPanel.mediaBtns.pauseBtn.addEventListener(MouseEvent.CLICK, onPauseBtn);

			mediaControlPanel.mediaBtns.stopBtn.addEventListener(MouseEvent.CLICK, onStopBtn);
			mediaControlPanel.mediaBtns.resumeBtn.addEventListener(MouseEvent.CLICK, onResumeBtn);
			
			mediaControlPanel.mediaBtns.volumeBar.addEventListener(Event.CHANGE, onVolume);
			mediaControlPanel.mediaBtns.muteToggleBtn.addEventListener(MouseEvent.CLICK, onMuteToggleBtn);
			
			mediaControlPanel.progressBars.seekBar.addEventListener(Event.CHANGE, onSeekBarChange);
			mediaControlPanel.progressBars.seekBar.dataTipFormatFunction = displaySeekToolTip;
				
			mediaControlPanel.viewableControlPanel.scaleModeCombo.addEventListener(Event.CLOSE, onScaleMode);
			wrapperQplayer.scaleMode = ScaleMode.NONE;
			
			mediaControlPanel.unloadBtn.addEventListener(MouseEvent.CLICK, onUnloadBtn);
						
		
			this.addEventListener(CloseEvent.CLOSE, onPanelWindowClose);	
		}
		
		 public function displayPlaylistPanel():void 
		{
				this.visible = true;
		}
		
		/**
		 * Read a playlist(xml) and parse the xml to populate dataProvider for playlist test media list.
		 * This is the example of an xml format.
		 * <DataRoot>
		   <MediaList url="http://flipside.corp.adobe.com/test_assets/sounds/">
              <Playlist label="http_mp3">
	            <Media stream="mp3/Beat%20Creatures.mp3" />
			    <Media stream="mp3/Batman_Superman_Adventures.mp3" />
  			  </Playlist>
 			  <Playlist label="http_bigmp3">
			  <Media stream="mp3/big.mp3" />
  			</Playlist>
		   </MediaList>
           </DataRoot>
		 */ 
	
		public function onLoadXMLForPlaylist(ev:Event):void
	   {
	   	
	   	try{
	   		
	        XML.ignoreWhitespace = true;
			var xmlList:XML = new XML(ev.target.data);
			var _playlistListDP:ArrayCollection = new ArrayCollection();
			
			var xmlMediaList:XML = xmlList.MediaList[0];
			
			//Set the base url of server (MediaList @url)
			if(xmlMediaList.@url != null)
			{
				playlistServerUrl = xmlMediaList.@url;
			}
			
			//Read each <Playlist> and push them to an playlist array.		
			for(var j:int=0; j<xmlMediaList.Playlist.length(); j++)
		    {
				var mo:Object = new Object();
				mo.label = (j+1) + ":" + xmlMediaList.Playlist[j].@label;
				var moList:Array = new Array();
				for(var k:int=0; k<xmlMediaList.Playlist[j].Media.length(); k++) 
				{
					var moListObj:Object = new Object();
					moListObj.streamName = xmlMediaList.Playlist[j].Media[k].@stream;
					moList.push(moListObj);
				}
				
				mo.data = moList;
				_playlistListDP.addItem(mo);
			}
			
			playlistList.dataProvider = _playlistListDP;
			playlistList.addEventListener(Event.CLOSE, onPlaylistSelected);
			
			//Display playlist to text field.
			currentPlaylistMsg = _playlistListDP.length + " playlists loaded";
			currentPlaylistStatus.text = currentPlaylistMsg;
			
			currentMediaPlaylist.addEventListener(ListEvent.ITEM_CLICK, onPlaylistItemClick);
			
		  } 
		  catch (e:TypeError)
		  {
	        logPanel.log("** Could not parse the XML", LOG_INFO)
	        logPanel.log(e.message, LOG_DEBUG)
		  }
	    }
	    
		/**
		 * Read a selected url from a playlist and set it to urlString for playback.
		 */ 

	    public function setPlaylistUrl():void 
	   {
			currentPlaylistIndex = 0;
			fullPlayStreamCount = new Array();
			currentPlaylistArrayCollection = new ArrayCollection();
			
			var mediaArray:Array = playlistList.selectedItem.data;
			var mediaPlaylistDuration:Number = 0;
			
			for(var i:int = 0; i<mediaArray.length; i++) 
			{
				var mediaObj:Object = mediaArray[i];
				var streamName:String = mediaObj.streamName;
					
				mediaObj.label = (i+1) + ":" + streamName;
				currentPlaylistArrayCollection.addItem(mediaObj);
			}
			
			currentMediaPlaylist.dataProvider = currentPlaylistArrayCollection;
			currentMediaPlaylist.selectedIndex = currentPlaylistIndex;
			
			_urlString = playlistServerUrl + "/" + currentMediaPlaylist.selectedItem.streamName;
			
			currentPlaylistMsg = "["+(playlistList.selectedIndex+1)+"/"+ currentPlaylistArrayCollection.length+"]"
								+ " " + mediaArray.length + " media in this list";
			currentPlaylistStatus.text = currentPlaylistMsg;
		}
		
		private function onPlaylistSelected(event:Event):void
		{
			setPlaylistUrl();
		
			wrapperQplayer.autoPlay = false;
			
			mediaControlPanel.mediaBtns.visible = true;
			mediaControlPanel.progressBars.visible = true;
			mediaControlPanel.viewableControlPanel.visible = true;
			
			
			if(_urlString != null)
			{
				var mediaType:String = _playlistMediaListXmlUrl.toLowerCase();
				mediaType = mediaType.slice(0,5);
				switch(mediaType)
				{
					// use constant
					case AUDIO:
						wrapperQplayer.element = new AudioElement(new NetLoader(), new URLResource(_urlString));
						break;
					case IMAGE:
						wrapperQplayer.element = new ImageElement(new ImageLoader(), new URLResource(_urlString));
						break;
					default:
						wrapperQplayer.element = new VideoElement(new NetLoader(), new URLResource(_urlString));									
				}
				
			}
			else
			{
				wrapperQplayer.element = new VideoElement(new NetLoader(), new URLResource(mediaControlPanel.urlInput.text));
			}
		}

		private function onPlaylistItemClick(event:ListEvent):void
		{
			_urlString = playlistServerUrl + String(event.target.selectedItem.streamName);
			logPanel.log(" url : " + _urlString.toString(), LOG_INFO);
		}
		
		public function get urlString():String
		{
			return _urlString;
		}
		
		private function onPlaylistsSelected(event:Event):void
		{
			
			var loader:URLLoader = new URLLoader();				
			var playlistSelection:String = event.target.selectedItem.label.toString();
			
			switch(playlistSelection)
			{
				case RTMP:
					_playlistMediaListXmlUrl = "playlist_media.xml";
					break;
				case HTTP_VIDEO:
					_playlistMediaListXmlUrl = "videoHttpPlaylist_media.xml";
					break;
				case HTTP_AUDIO:
					_playlistMediaListXmlUrl = "audioPlaylist_media.xml";
					break;
				case HTTP_IMAGE:
					_playlistMediaListXmlUrl = "imagePlaylist_media.xml";
					break;	
				default:
					_playlistMediaListXmlUrl = "playlist_media.xml";
					 trace("default");															
					_playlistMediaListXmlUrl = "playlist_media.xml";															
					_playlistMediaListXmlUrl = "playlist_media.xml";														
			}
			
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onLoadXMLForPlaylist);
			loader.load(new URLRequest(_playlistMediaListXmlUrl));
		}
		
		private function onCompositionSelected(event:Event):void
		{
			  if(event.target.selectedItem.label == " ")
			  {
			  	mLabel.text = "select composition test case from combo box";
			  }
			  else
			  {
				mLabel.text = "composition " +  event.target.selectedItem.label + " selected.";
				mediaControlPanel.mediaBtns.visible = true;
				mediaControlPanel.progressBars.visible = true;
				mediaControlPanel.viewableControlPanel.visible = true;
			  }
			 			 
			 var compMediaSelection:String = event.target.selectedItem.label.toString();			
			 
			 switch(compMediaSelection)
			 {			
					case PARALLEL:
					   loadCompositionMedia(0);		
					    break;
					case SEQUENCE:
						loadCompositionMedia(1);
					 	break;
					case COMPOSITE1:
						loadCompositionMedia(2);		
					 	break;
					case COMPOSITE2:
						loadCompositionMedia(3);
						break;
					case COMPOSITE3:
						loadCompositionMedia(4);
						break;
					case COMPOSITE4:
						loadCompositionMedia(5);
						break;						
					default:
					 	trace("default");		 
					 	 logPanel.log("composition combo box default", LOG_INFO);		 
 						break;
			 }
		}
		
		public function loadCompositionMedia(n:int=0):void
		{
			var compFactory:CompositionMediaFactory = new CompositionMediaFactory();
			var compMedia:MediaElement;
			compMedia = compFactory.createCompositionElement(n);

			wrapperQplayer.autoPlay = false;
			wrapperQplayer.element = compMedia;
			if(compMedia is ParallelElement || compMedia is SerialElement )
			{
				wrapperQplayer.traverseElement(compMedia);
			}		
		}
		

		
		private function onVolumeChanged(event:VolumeChangeEvent):void
		{
			wrapperQplayer.volume = event.newVolume;
			mediaControlPanel.mediaBtns.volumeBar.value = event.newVolume;
			 logPanel.log("** onVolumeChanged", LOG_INFO)
		}
		
		private function onLoad(event:MouseEvent):void
		{

			wrapperQplayer.autoPlay = false;
			
			if(_urlString == null)
			{
				_urlString = mediaControlPanel.urlInput.text;
			}

			wrapperQplayer.element = new VideoElement(new NetLoader(), new URLResource(_urlString));
	
		}
	
		
		private function onUnloadBtn(event:MouseEvent):void
		{
			wrapperQplayer.element = null;
		}
		
		private function onPlayBtn(event:MouseEvent):void
		{
			wrapperQplayer.addEventListener(PlayheadChangeEvent.PLAYHEAD_CHANGE, checkprogress);
			wrapperQplayer.play();
		}
	
		
		private function onPauseBtn(event:MouseEvent):void
		{
			wrapperQplayer.pause();
		}
		
		private function onStopBtn(event:MouseEvent):void
		{
			if(wrapperQplayer.element != null)
			{
			    if(wrapperQplayer.element.hasTrait(MediaTraitType.PAUSIBLE))
			    {
	
			    	wrapperQplayer.pause();
			    }
			}
		}
		
		private function onResumeBtn(event:MouseEvent):void
		{
			if(wrapperQplayer.element != null)
			{
				if(wrapperQplayer.element.hasTrait(MediaTraitType.PLAYABLE))
				{
					wrapperQplayer.play();
				}				
			}
		}
	

		public function onSeekBarChange(event:Event):void
		{
			var pos:Number = event.target.value;
			wrapperQplayer.seek(mediaControlPanel.progressBars.progressBar.maximum*pos/100);
			 logPanel.log("** onSeekBarChange", LOG_INFO)	
		}
		
		private function onVolume(event:Event):void
		{
			if(wrapperQplayer.audible)
			{
				wrapperQplayer.volume = event.target.value;
			}
			
			mediaControlPanel.mediaBtns.volumeTxt.text = event.target.value.toFixed(2);			
		}
		
		private function onMuteToggleBtn(event:MouseEvent):void
		{
			if(wrapperQplayer.audible)
			{
				wrapperQplayer.muted = !wrapperQplayer.muted;
			}
		}

		private function onPan(event:Event):void
		{	
			if(wrapperQplayer.audible)
			{
				wrapperQplayer.pan = event.target.value;
			}
		}
		
		
		
		private function onScaleMode(event:Event):void
		{
			var scaleMode:String = event.target.selectedItem.toString();
			
			switch(scaleMode)
			{
				case "LETTERBOX":
					wrapperQplayer.scaleMode = ScaleMode.LETTERBOX;
					break;
				case "STRETCH":
					wrapperQplayer.scaleMode = ScaleMode.STRETCH;
					break;
				case "CROP":
					wrapperQplayer.scaleMode = ScaleMode.CROP;
					break;
				case "NONE":
					wrapperQplayer.scaleMode = ScaleMode.NONE;
					break;					
			}
		
			mediaControlPanel.viewableControlPanel.screenWidth.text = wrapperQplayer.width.toString();
			mediaControlPanel.viewableControlPanel.screenHeight.text = wrapperQplayer.height.toString();
		}
		
		private function displaySeekToolTip(value:Number):String
		{
			return numberFormatter.format(mediaControlPanel.progressBars.progressBar.maximum*value/100);
		}
			
			
		public function checkprogress(event:PlayheadChangeEvent):void
		{
			  mediaControlPanel.progressBars.durationTxt.text = wrapperQplayer.duration.toString();
			  mediaControlPanel.progressBars.playHeadTxt.text = wrapperQplayer.playhead.toString();
			  
			  mediaControlPanel.progressBars.progressBar.maximum = wrapperQplayer.duration;
			  
			  mediaControlPanel.progressBars.scrubBar.maximum = wrapperQplayer.duration;
			  mediaControlPanel.progressBars.scrubBar.value   = wrapperQplayer.playhead;
			  
			  if(wrapperQplayer.playhead)
			  {
				mediaControlPanel.progressBars.progressBar.setProgress(wrapperQplayer.playhead, mediaControlPanel.progressBars.progressBar.maximum);
				if(wrapperQplayer.bufferable)
				{
					mediaControlPanel.progressBars.progressBar.label = "Playing %3%%: position at "+ numberFormatter.format(wrapperQplayer.playhead) 
						+ " bufferLength:" + numberFormatter.format(wrapperQplayer.bufferLength);
				}
			  }
		}
		
		

		
		private function onPanelWindowClose(event:CloseEvent):void
		{
			
			if(wrapperQplayer.element)
			{
				wrapperQplayer.element = null;
			}
			
			this.visible = false;
			
		}
	

		private var compositionNumber:int;	
		[Bindable]
		public var compositeMediaArray:ArrayCollection = new ArrayCollection(
			[ {label:"Parallel1"}, {label:"Sequence1"},{label:"http1+http2"},{label:"httpRtmp+rtmp"}, {label:"rtmpAudiohttp+rtmp"}, {label:"rtmpAudiortmp+rtmp"}]
		);
		
		[Bindable]
		public var playlistsArray:ArrayCollection = new ArrayCollection (
				[ {label:"RTMPplaylist"}, {label:"HTTPVideoplaylist"},{label:"AudioPlaylist"},{label:"ImagePlaylist"} ]
		);
		

		[Bindable]
		private var currentPlaylistArrayCollection:ArrayCollection;
		private var _playlistMediaListXmlUrl:String = "playlist_media.xml";
		private var playlistServerUrl:String = "";
		private var currentPlaylistIndex:int = 0;
		private var currentPlaylistMsg:String = "";
		private var fullPlayStreamCount:Array;

		private var _urlString:String;
		private var logPanel:LogPanel;
		
		/**
 		* Defining Media Types
		*/
		private static const AUDIO:String = "audio";
		private static const IMAGE:String = "image";
		
		
		/**
 		* Defining Composition Test Constants
		*/
		private static const PARALLEL:String = "Parallel1";
		private static const SEQUENCE:String = "Sequence1";
		private static const COMPOSITE1:String = "http1+http2";
		private static const COMPOSITE2:String = "httpRtmp+rtmp";
		private static const COMPOSITE3:String = "rtmpAudiohttp+rtmp";
		private static const COMPOSITE4:String = "rtmpAudiortmp+rtmp";		
		
		
		/**
 		* Defining Playlist files Constants
		*/
		private static const RTMP:String = "RTMPplaylist";
		private static const HTTP_VIDEO:String = "HTTPVideoplaylist";
		private static const HTTP_AUDIO:String = "AudioPlaylist";
		private static const HTTP_IMAGE:String = "ImagePlaylist";
		

		/**
 		* Defining log level constant
		 */
		private const LOG_NONE:int = 0;
		private const LOG_INFO:int = 1;
		private const LOG_DEBUG:int = 2; 
	}
}


