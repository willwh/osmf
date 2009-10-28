package adobeTV.flash
{

	import adobeTV.flash.events.BufferEvent;
	import adobeTV.flash.events.CCEvent;
	import adobeTV.flash.events.PlayerEvent;
	import adobeTV.flash.events.ScreenDimensionEvent;
	import adobeTV.flash.events.ScrubEvent;
	import adobeTV.flash.view.Button;
	import adobeTV.flash.view.ClosedCaptioning;
	import adobeTV.flash.view.ElapsedTime;
	import adobeTV.flash.view.ScreenDimension;
	import adobeTV.flash.view.ScrubBar;
	import adobeTV.flash.view.ToolTip;
	import adobeTV.flash.view.TvPlayer;
	import adobeTV.flash.view.VolumeBar;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.PlayheadChangeEvent;
	import org.osmf.events.PlayingChangeEvent;
	import org.osmf.media.MediaPlayer;
	
	/**
	 * ...
	 * @author Robert Colvin
	 */
	public class PlayerTvMain extends Sprite
	{
		
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="dimON")]
		public static var dimON:Class;
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="dimOFF")]
		public static var dimOFF:Class;
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="popOut")]
		public static var popOut:Class;
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="maximize")]
		public static var maximize:Class;
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="restore")]
		public static var restore:Class;
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="pause_icon")]
		public static var pause_icon:Class;
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="play_icon")]
		public static var play_icon:Class;
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="ClosedCap")]
		public static var ClosedCap:Class;
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="rwd_icon")]
		public static var rwd_icon:Class;
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="BG_up")]
		public static var BG_up:Class;
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="btn_bg_UP")]
		public static var btn_bg_UP:Class;
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="BG_over")]
		public static var BG_over:Class;
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="vOFF")]
		public static var vOFF:Class;		
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="vLOW")]
		public static var vLOW:Class;	
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="vMID")]
		public static var vMID:Class;	
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="vHI")]
		public static var vHI:Class;	
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="playBTN")]
		public static var playBTN:Class;	
		[Embed(source="../../../assets/adobeTV_v2.swf", symbol="fs01")]
		public static var fs01:Class;			
			
		
		
		private var tolerance:int = 4;
		//
		//
		
		private var closedCapTxt:ClosedCaptioning;     //closed captioning object holding text and bg etc...
		private var closedCaption:Button;					//closed captioning button inside containRight container
		private var mp:MediaPlayer;
		
		private var logo:Sprite;									//simple sprite to contain logo overlay
		
		private var bg:Sprite;										//background for entire player
		private var containControls:Sprite					//controls container holds all including  controls background, play,rewind , scrub bar etc...
		private var controlBG:Sprite;							//background for playback controls
		
		private var rwd_btn:Button;		
		private var play_btn:Button;
		private var containScrub:ScrubBar;					//scrub bar with all controls
		private var containLeft:Sprite;							//contains all controls to the left of the scrub bar
		
		//right controls
		private var containRight:Sprite;						//contains all controls to the right of the scrub bar
		
		private var volumeBar:VolumeBar;					//volumebar controller
		private var elapsed:ElapsedTime;					//elapsed object holds elapses/duration
		private var screenDimension:ScreenDimension;//screenDimension  button with window of options
		
		private var containVideo:Sprite;						//container for TvPlayer which uses strobe
		
		private var tvMediaPlayer:TvPlayer;				//where the video will be pulled via the strobe framework (see TODOs)
		
		private var isPaused:Boolean							//keeps state of current pause to  not cause issues when scrubbing
		
		private var aDividers:Array;							//holds reference to all dividers needed in the view to seperate controls
						
		private var masker:Sprite;								//masks video to allow borders to show
		
		private var cover:Sprite;								//is used when in embeded mode for single click to enable playback
		
		private var embedPlay:Sprite;						//holds the play image for view when in embeded mode
			
		private var fs:ContextMenuItem						//fullscrean button in context menu
		private var xfs:ContextMenuItem					//exit full screen button in context menu
		
		/**
		 * updates the buffer for the current track being played
		 * @param	e
		 */
		private function updateBuffer(e:BufferEvent):void {
			containScrub.totalAvailable = e.available;	
		}
		/**
		 * TvPlayer event everytime the playhead changes
		 * updates the scrubbar and the elapsed time objects.
		 * @param	e
		 */
		private function updatePlayHead(event:PlayheadChangeEvent):void
		{
			if (cover.parent) 
			{
				cover.removeEventListener(MouseEvent.CLICK, clicked);
				cover.parent.removeChild(cover);
				var pe:PlayerEvent = new PlayerEvent(PlayerEvent.PLAYER_LOGO);
				pe.enabled = true;
				insertLogo(pe);
			}
			containScrub.updatedragable(event.newPosition, mp.duration, false);
			
			elapsed.setTime(event.newPosition, mp.duration);
		}

		
		/**
		 * called when seek is made
		 * @param	e ScrubEvent
		 */
		private function playheadScrubbed(e:ScrubEvent):void
		{
			mp.seek(e.percent * mp.duration);
			
		}
		/**
		 * invokes seek on netstream via TvPlayer object's method seekHead
		 * @param	percent a number from 0 to 1;
		 */
		private function playSeek(percent:Number):void
		{
			tvMediaPlayer.seekHead(percent);
		}
		/**
		 * sets size for this component when stage size changes
		 * @param	e Event
		 */
		private function resizeComponent(e:Event):void 
		{
			setSize(stage.stageWidth-1, stage.stageHeight-2);
		}
	
		/**
		 * add the logo or removes it from the screen
		 * @param	e:PlayerEvent
		 */
		private function insertLogo(e:PlayerEvent):void 
		{
			if (e.enabled) 
			{
				if (logo.parent == null)
				{
					containVideo.addChild(logo);
				}
				else
				{
					if (logo.parent != null)
					{
						containVideo.removeChild(logo);
					}
				}
			}
		}
			
		/**
		 * enable and disable buttons in view when commercial is playing or ends playing
		 */
		private function set buttonsEnable(isEnabled:Boolean):void 
		{
			play_btn.enabled = isEnabled;
			rwd_btn.enabled = isEnabled;
			if(closedCapTxt.isCCavailable)
			{
				closedCaption.enabled = isEnabled;
			}
			screenDimension.enabled = isEnabled;
			
			containScrub.visible = isEnabled;
			tvMediaPlayer.visible = isEnabled;
			elapsed.enabledTime = isEnabled;
			if (!isEnabled) 
			{			
				var bf:DropShadowFilter = new DropShadowFilter(40);
				bf.inner = true;
				bf.alpha = .3;
				play_btn.filters = [bf];
					play_btn.alpha = .5;
				rwd_btn.filters = [bf];
					rwd_btn.alpha = .5;
				screenDimension.filters = [bf];
					screenDimension.alpha = .5;
				if (closedCapTxt.isCCavailable) 
				{
					closedCaption.filters = [bf];
					closedCaption.alpha = .5;
				}
				//remove filters from controls
			}
			else
			{
				
				play_btn.filters = [];
					play_btn.alpha = 1;
				rwd_btn.filters = [];
					rwd_btn.alpha = 1;
				screenDimension.filters = [];
					screenDimension.alpha = 1;
				if (closedCapTxt.isCCavailable) {
					closedCaption.filters = [];
					closedCaption.alpha = 1;
				}
				//add filter to controls
							
			}
		}
		
		
		
		/**
		 * handler for fullscreen when going in or out of fullscreen
		 * repositions controls
		 * updates right click options
		 * and updates screendimension menu
		 * @param	e  FullScreenEvent
		 */
		private function fullScreenRedraw(e:FullScreenEvent):void 
		{
			var w:Number;
			var h:Number;
			if (e.fullScreen) 
			{ 
				w = Capabilities.screenResolutionX;
				h = Capabilities.screenResolutionY;
				setSize(w, h, true);		
			} 
			else 
			{ 
				stage.displayState = StageDisplayState.NORMAL;
				w = stage.stageWidth-1 //638;
				h= stage.stageHeight-1 //385;
				setSize(w, h, false);
				screenDimension.restore();	
			}
			if (fs)
			{
				fs.enabled = false;
				xfs.enabled = true;
			}
		}
	
		/**
		 * handler for when a screendimension menu option is selected popout,maximize,dim,fullscreen
		 * @param	e ScreenDimensionEvent
		 */
		private function dimentionChange(e:ScreenDimensionEvent):void 
		{
			var jsMethod:String;		
			switch(e.mode) 
			{
				case ScreenDimension.POPOUT:					
					pauseStream();
					break;
				case ScreenDimension.MAXIMIZE:
					jsMethod = "atv.episode.player.maximize";
					break;
				case ScreenDimension.DIM:
					jsMethod = "atv.episode.player.dim";
					if (ExternalInterface.available && jsMethod!=null) ExternalInterface.call(jsMethod,e.enabled);	
					return;
				case ScreenDimension.FULLSCREEN://change the size in the player and then remove and add children again
					var hwAcceleration:Boolean = false;//controls do not show correctly
					if (hwAcceleration) 
					{
						stage.scaleMode = StageScaleMode.SHOW_ALL;
						stage.fullScreenSourceRect = new Rectangle(tvMediaPlayer.x, tvMediaPlayer.y, 
																			tvMediaPlayer.currentSize.width, tvMediaPlayer.currentSize.height);
					}
					stage.displayState = StageDisplayState.FULL_SCREEN;
					return;
				case ScreenDimension.ORIGINAL://change the size in the player and then remove and add children again
					if(screenDimension.currentMode==ScreenDimension.FULLSCREEN)
					{
						stage.displayState = StageDisplayState.NORMAL;
						return;
					}
					else 
					{
						jsMethod = "atv.episode.player.restore";
					}
				}
			
			 if (ExternalInterface.available && jsMethod!=null) ExternalInterface.call(jsMethod);				
			}
	
			
			/**
			 * creates the context menu options including fullscreen, and versioning
			 * TODO:: menu items selected do not always fire. Possible stop propagation event block??
			 */
			private function createContextMenu():void {
				var  mc:Stage = stage;
				if(mc)
				{
					// create the context menu, remove the built-in items,
					// and add our custom items
					var fullscreenCM:ContextMenu = new ContextMenu();
					
					fullscreenCM.hideBuiltInItems();
	
					 fs = new ContextMenuItem("Go Full Screen" );
					fs.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, changeScreen);
					fullscreenCM.customItems.push( fs );
	
					 xfs = new ContextMenuItem("Exit Full Screen");
						
					xfs.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, changeScreen);
					fullscreenCM.customItems.push( xfs );
					xfs.enabled = false;
					
					var vs:ContextMenuItem = new ContextMenuItem("OSMFplayer  v. " + 1.0);
					fullscreenCM.customItems.push( vs );
	
					// finally, attach the context menu to a movieclip
					mc.contextMenu = fullscreenCM;
				}
			}
			
			/**
			 * context menu slot for versioning
			 * @param	mc
			 */
			private function contextVersion(mc:Stage):void 
			{
				var fullscreenCM:ContextMenu = new ContextMenu();
				var vs:ContextMenuItem = new ContextMenuItem("OSMFplayer  v. " + 1.0);
				
				fullscreenCM.customItems.push( vs );
				mc.contextMenu = fullscreenCM;
			}
		
			
			/**
			 * context menu click handler for options fullscreen or not
			 * @param	e ContextMenuEvent
			 */
			private function changeScreen(e:ContextMenuEvent):void 
			{
				switch((e.target as ContextMenuItem).caption) 
				{
					 case "Go Full Screen":
						stage.displayState = StageDisplayState.FULL_SCREEN;
					 break;
					 case "Exit Full Screen":
						stage.displayState = StageDisplayState.NORMAL;
					 break;
				}
			}
			

		/**
		 * constructor
		 * creates all necissary visual components left|scrub|right video|logo|CC|Yume area and options within
		 */	
		public function PlayerTvMain(mp:MediaPlayer) 
		{
			mp.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayChanged);
			this.mp = mp;
			
			aDividers = [];
			
			volumeBar = new VolumeBar();
			
			closedCapTxt = new ClosedCaptioning();
			closedCapTxt.x = 2;
			closedCapTxt.addEventListener(CCEvent.URL_MISSING, disableCCBtn);
			
			masker = new Sprite();
		
			tvMediaPlayer = new TvPlayer(mp, closedCapTxt);
			
			mp.addEventListener(PlayheadChangeEvent.PLAYHEAD_CHANGE, updatePlayHead);
			mp.addEventListener(BufferEvent.BUFFER_CHANGE, updateBuffer);
			
			containControls = new Sprite();
			containVideo = new Sprite();
			bg = new Sprite();
			
			containVideo.mask = masker;
			
			addMainControls()
			
			containVideo.addChild(tvMediaPlayer);

			addChild(bg);
			addChild(containVideo);
			addChild(masker);						
			addChild(containControls);
			
			cover = new Sprite();
						
			mp.addEventListener(MediaPlayerCapabilityChangeEvent.AUDIBLE_CHANGE, onAudible);
			if(mp.audible)
			{
				volumeBar.volume = mp.volume;
			}
					
		}
		
		
		private function onAudible(event:MediaPlayerCapabilityChangeEvent):void
		{
			volumeBar.volume = mp.volume;
		}
		
		/**
		 * no ads event to setup the correct context menu buttons
		 * @param	e
		 */
		private function initNoAds(e:PlayerEvent):void 
		{			
			createContextMenu();
		}
		
		/**
		 * closed caption event to remove button if cc file doesn't exist
		 * @param	e CCEvent
		 */
		private function disableCCBtn(e:CCEvent):void 
		{
			if (closedCaption.parent)	
			{
				closedCaption.parent.removeChild(closedCaption);
			}
			setSize( stage.stageWidth-1, stage.stageHeight-1, false);
		}
			
		
		/**
		 * invokes volume via TvPlayer object's public setter volume
		 * @param	e
		 */
		private function volumeChanged(e:ScrubEvent):void 
		{
				mp.volume = e.percent;
		}
		
		/**
		 * create and add all controls to the view
		 */
		private function addMainControls():void 
		{
			controlBG = new Sprite();
			containRight = new Sprite();
			containScrub = new ScrubBar();
					
			containScrub.addEventListener(ScrubEvent.SEEK_CHANGING, playheadScrubbed);
			
			containLeft = new Sprite();

			createLeft();
			createRight();
			
			containControls.addChild(controlBG);
			containControls.addChild(containLeft);
			containScrub.x = containLeft.x + containLeft.width + tolerance*1.5;
			containRight.x = containScrub.x + containScrub.width + tolerance;
			containControls.addChild(containScrub);
			containControls.addChild(containRight);	
			createDividers();
		}
		
		/**
		 * creates all dividers for the view to seperate buttons scrub bar and volume
		 */
		private function createDividers():void 
		{
			for (var i:int = 0; i < 6;++i) 
			{
				var bar:Sprite = new Sprite();
				bar.graphics.lineStyle(1, 0x686868);
				bar.graphics.moveTo(0, 0);
				bar.graphics.lineTo(0, 25);
				aDividers.push(bar);
				containControls.addChild(bar);
			}			
		}	
		
		/**
		 * moves dividers between controls
		 * */
		private function moveDividers(points:Vector.<Number>):void 
		{
			for (var i:int = 0; i < 6;++i) aDividers[i].x = points[i];
		}
		
		/**
		 * creates right control 
		 * volumebar/closed captioning/screendimension options
		 */
		private function createRight():void
		{
			var ypos:Number = 2;
			
			volumeBar.addEventListener(ScrubEvent.SEEK_COMMITED, volumeChanged);
			volumeBar.addEventListener(ScrubEvent.SEEK_CHANGING, volumeChanged);
			screenDimension = new ScreenDimension();
			screenDimension.addEventListener(ScreenDimensionEvent.SCREEN_MODE_UPDATE, dimentionChange);
			var  newX:Number = tolerance;
			if(closedCapTxt.isCCavailable){
				closedCaption = PlayerTvMain.buttonCreate("ClosedCaption", "cc", 22, "ClosedCap", containRight, ypos, clicked);
				closedCaption.x = newX;
				newX = closedCaption.x + closedCaption.width + tolerance;
			}
			volumeBar.x = newX;
			
			screenDimension.x = volumeBar.x + volumeBar.width + tolerance;
			screenDimension.setSize(36, 22);
			
			if(closedCapTxt.isCCavailable)containRight.addChild(closedCaption);
			containRight.addChild(volumeBar);
			containRight.addChild(screenDimension);
		}
			
		/**
		 * creates left control
		 * rewind button play button and elapsed time all members of the left control
		 */
		private function createLeft():void
		{
			var ypos:Number = 2;
			rwd_btn  = PlayerTvMain.buttonCreate("Rewind", "rwd",22, "rwd_icon" ,containLeft, ypos,onRewind);
			play_btn  = PlayerTvMain.buttonCreate("Play", "play", 40, "play_icon", containLeft, ypos, playPauseClicked);
			play_btn.label = "";
			elapsed = new ElapsedTime();	

			rwd_btn.x = 2;
			play_btn.x = rwd_btn.x + rwd_btn.width + tolerance;		
			elapsed.x = play_btn.x + play_btn.width + tolerance;			
			elapsed.y = 2;	
			elapsed.setSize(90, 21);
			containLeft.addChild(elapsed);							
		}
			
		/**
		 * provides a more accurate number for the right containers width
		 */
		private function get containRightWidth():Number
		{
			return volumeBar.width +(closedCapTxt.isCCavailable? closedCaption.width:0) + screenDimension.width;
		}
		
		/**
		 * set size for this component and pass on to scrub bar to resize
		 * @param	w
		 * @param	h
		 */
		public function setSize(w:Number, h:Number, fullscreen:Boolean = false):void
		{		
			if (cover.parent) {
				PlayerTvMain.square(cover.graphics, { x:1, y:1, width:w, height:h }, 0, 0x000000, 1, 0, 0x000000, true);
				if (embedPlay.parent) {
					embedPlay.x = (w - embedPlay.width) * .5;
					embedPlay.y = (h - embedPlay.height) * .5 - 25;
					}
			}
			var tol:Number = tolerance * .5;
			containScrub.setSize(w - (containLeft.width + containRightWidth + tolerance + 2), 28);	
			
						
			PlayerTvMain.square(bg.graphics, { x:0, y:0, width:w, height:h }, 1, 0x686868, 1, 1, 0x7B7B7B);
			PlayerTvMain.square(bg.graphics, { x:1, y:1, width:w - 2, height:h - 4 }, 0, 0x000000, 1, 0, 0x000000, false);
			PlayerTvMain.square(masker.graphics, { x:1, y:1, width:w - 2, height:h - 4 }, 0, 0x000000, 1, 0, 0x000000, true);
			
			containControls.y = h - 15;
			
			if(closedCapTxt.isCCavailable)
			{
				closedCapTxt.setSize(w - 4, 0);
				closedCapTxt.y = containControls.y - closedCapTxt.height;
			}
			
			containRight.x = w - containRightWidth-(closedCapTxt.isCCavailable? 0:24);//TODO::should not be hard coded
			
			PlayerTvMain.square(controlBG.graphics, { x:0, y:0, width:w, height:25 }, 1, 0x686868, 1, 1, 0xEFEFEF);
			moveDividers(Vector.<Number>([rwd_btn.width + rwd_btn.x + tol, 
																play_btn.width + play_btn.x + tol, 
																elapsed.x + elapsed.width + tol, 
																containScrub.x + containScrub.width + tol, 
																(closedCapTxt.isCCavailable? containRight.x + closedCaption.width + tolerance + tol: -1), 
																containRight.x+volumeBar.x + volumeBar.width + tol   ])	
											);
		}
			
		/**
		 * generic method for button creation
		 * @param	label
		 * @param	name
		 * @param	w
		 * @param	icon
		 * @param	owner
		 * @param	y
		 * @param	handler
		 * @param	toolTip
		 * @param	toolTipFunction
		 * @return     Button
		 */
		public static function buttonCreate(label:String, name:String, w:int, icon:String, owner:Sprite, y:Number,handler:Function,toolTip:Boolean=false,toolTipFunction:Function=null):Button 
		{
			var btn:Button = new Button(convert2Class("BG_up"), convert2Class("BG_over"), convert2Class("BG_emphasized"),  convert2Class("BG_emphasized"));
			
			btn.name = name;
			btn.icon =  convert2Class(icon);
			btn.setSize(w, 21);
				
			btn.addEventListener(MouseEvent.CLICK, handler);
		
			btn.y = y;
			owner.addChild(btn);
			if (toolTip) 
			{
				btn.label = label;
				btn.addEventListener(MouseEvent.MOUSE_OVER, (toolTipFunction!=null?toolTipFunction:hint), false,0, true);
			}
			return btn;
		}
		
		
		/**
		 * tooltip event for mouse over
		 * @param	e
		 */
		private static function hint(e:MouseEvent):void 
		{
			var btn:Button = e.target as Button;
			var toolTip:ToolTip = PlayerTvMain.toolTipShow(btn, btn.label, 200,-1,10);
			//trace(' 2 tooltip fired');
		}
		
		private function playPauseClicked(event:Event):void
		{
			if(mp.playing && mp.pausable)
			{
				mp.pause();
			}
			else if(mp.playable)
			{
				mp.play();
			}
		}
		
		private function onPlayChanged(event:PlayingChangeEvent):void
		{		
			if (play_btn)
			{
				if (event.playing)
				{
					play_btn.icon =  convert2Class("pause_icon");
					isPaused = false;
					play_btn.name = "pause";
				}
				else
				{
					play_btn.name = "play"
					play_btn.icon =  convert2Class("play_icon") ;				
					isPaused = true;				
				}
			}
		}
		
		
		/**
		 * click event switch for all created buttons
		 * @param	e
		 */
		private function clicked(e:MouseEvent):void 
		{
			var btn:Button = e.target  as Button;
						
			var show:Boolean = false;
			switch (btn.name) 
			{
				case "cc":
					btn.name = "cc2";
					var index:int=containVideo.getChildIndex(tvMediaPlayer)+1;
					if (closedCapTxt.parent == null)
					{
						containVideo.addChildAt(closedCapTxt,index);
					}
					break
				case "cc2":
					btn.name = "cc";
					if(closedCapTxt.parent!=null)
					{
						containVideo.removeChild(closedCapTxt);
					}
				break;
								
			}
			
		}
		
		private function onRewind(event:Event):void
		{
			playSeek(0);
		}
		
		/**
		 *  change the button style and pause the stream
		 * 
		 */
		private function pauseStream():void
		{
			mp.pause();			
		}
		
		/**
		 * factory for library items
		 * @param	name
		 * @return
		 */
		public static function convert2Class(name:String):DisplayObject
		{
			switch (name) 
			{
				case "fs01":
					return new fs01();
				case "dimON":
					return new dimON();
				case "dimOFF":
					return new dimOFF();
				case "popOut":
					return new popOut();
				case "maximize":
					return new maximize();
				case "restore":
					return new restore();
				case "pause_icon":
					return new pause_icon();
				case "play_icon":
					return new play_icon();
				case "ClosedCap":
					return new ClosedCap();
				case "rwd_icon":
					return new rwd_icon();
				case "BG_up":
					return new BG_over();
				case "BG_over":
					return new BG_over();
				case "vOFF":
					return new vOFF();
				case "vLOW":
					return new vLOW();
				case "vMID":
					return new vMID()
				case "vHI":
					return new vHI();
			}
			return null;
		}	
			
		/**
		 * create square
		 * @param	MC
		 * @param	sPos
		 * @param	weight
		 * @param	linecolor
		 * @param	alpha
		 * @param	lineAlpha
		 * @param	color
		 * @param	clear
		 */
		public static function square(MC:Graphics, sPos:Object, weight:int,linecolor:uint,alpha:Number,lineAlpha:Number, color:uint,clear:Boolean=true):void
		{
			if(clear)MC.clear();
			if (sPos==null)return;
						
			MC.lineStyle(weight,linecolor,lineAlpha);
			MC.beginFill(color, alpha);
			MC.drawRect(sPos.x,sPos.y,sPos.width,sPos.height);
			MC.endFill();                      
		}
		
		/**
		 * create rounded square
		 * @param	round
		 * @param	MC
		 * @param	sPos
		 * @param	weight
		 * @param	linecolor
		 * @param	alpha
		 * @param	lineAlpha
		 * @param	color
		 */
		 public static function squareRound(round:int,MC:Graphics, sPos:Object, weight:int,linecolor:uint,alpha:Number,lineAlpha:Number, color:uint):void
		 {
			MC.clear();
			if (sPos==null)return;
			MC.lineStyle(weight,linecolor,lineAlpha);
			MC.beginFill(color, alpha);
			MC.drawRoundRect(sPos.x,sPos.y,sPos.width,sPos.height,round,round);
			MC.endFill();                      
		}
		
		/**
		 * create tooltip for all buttons
		 * @param	btn
		 * @param	content
		 * @param	delay
		 * @param	absX
		 * @param	absY
		 * @param	distance
		 * @param	title
		 * @param	onUP
		 * @param	isHook
		 * @param	hookSize
		 * @return  	ToolTip
		 */
		public static function toolTipShow(btn:DisplayObject, content:String, delay:int = 1500, 
													absX:Number = -1, absY:Number = -1, distance:Number = -1, title:String = null, onUP:Boolean = false,
													isHook:Boolean=false, hookSize:Number=-1
													):ToolTip  
		{
			if (title == null) 
			{
				title = content;
				content = null;
			}
			
			var tf:TextFormat = new TextFormat();
			tf.size = 11;
			tf.color = 0x000000;
						
			var tt:ToolTip = new ToolTip();
			if (isHook) 
			{
				tt.hook = true;
				if (hookSize != -1) 
				{
					tt.hookSize = hookSize;
				}
			}
			
			tt.delay = delay;
			tt.titleFormat = tf;
			tt.autoSize = true;
			tt.tipHeight = 18;
			tt.border = 0x000000;
			
			tt.colors = [ 0xF7F7F7,0xCDCDCD ];
			tt.relativeYabove = false;
			tt.cornerRadius = 0;
			tt.show(btn, title, content,onUP,absX,absY,distance );
			return tt;
		}
		
		//end class
	}
	
}