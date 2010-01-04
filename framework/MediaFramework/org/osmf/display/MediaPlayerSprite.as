/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.display
{
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	
	/**
	 * <code>MediaPlayerSprite</code> allows a <code>MediaElement</code> with a DisplayObjectTrait to be placed
	 * on the display list. It supports the <code>scaleMode</code> of the <code>ScalableSprite</code>, as well
	 * as the creation of a <code>MediaPlayer</code> controller class.
	 **/
	public class MediaPlayerSprite extends ScalableSprite
	{	
		/**
		 * Constructs a <code>MediaPlayerSprite</code>  
		 * @param player A custom MediaPlayer can be provided.
		 **/
		public function MediaPlayerSprite(player:MediaPlayer = null)
		{
			super();	
			mediaPlayer = player ? player : new MediaPlayer(); 					
		}	
		
 		/**
		 * Source MediaElement displayed by this <code>MediaPlayerSprite</code>. Setting the media will set
         * as the media on the mediaPlayer, if mediaPlayer is not null.
		 */
		public function set media(value:MediaElement):void
		{
			if (_player)
			{
				_player.media = value;
			}
		}
		
		public function get media():MediaElement
		{			
			return _player ? _player.media : null;
		}
		
		/**
		 * The MediaPlayer that controls this media element.  Defaults to an instance of org.osmf.MediaPlayer.
		 * The player needs to have it's element set either on the MediaPlayer or on this object (see element)
		 * after this property is set.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function set mediaPlayer(value:MediaPlayer):void
		{
			if (_player != null)
			{
				_player.removeEventListener(DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, onView);	
				_player.removeEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, onMediaSize);	
				displayObject = null;
			}
			_player = value;
			if (_player != null)
			{
				_player.addEventListener(DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, onView);	
				_player.addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, onMediaSize);	
				displayObject = _player.displayObject;		
				setIntrinsicSize(_player.mediaWidth, _player.mediaHeight);
			}
		}		
		 
		public function get mediaPlayer():MediaPlayer
		{
			return _player;
		}				
						
		private function onView(event:DisplayObjectEvent):void
		{	
			displayObject = event.newDisplayObject;				
		}
		
		private function onMediaSize(event:DisplayObjectEvent):void
		{
			setIntrinsicSize(event.newWidth, event.newHeight);
		}
		
		/**
		 * The player class that exposes most of the MediaElement's interface, such as the viewable and dimensional 
		 * properties.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		private var _player:MediaPlayer;
	}
}