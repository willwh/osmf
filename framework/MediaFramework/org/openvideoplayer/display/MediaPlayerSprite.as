/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.display
{
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.events.MediaPlayerCapabilityChangeEvent;
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.MediaPlayer;
	
	/**
	 * The MediaPlaybackSprite is designed to allow a display object to beplaced on the Flash display list.  It inherits from the MediaElement sprite, but 
	 * provides many of the API's that the org.openvideoplayer.media.MediaPlayer class provides.
	 **/
	public class MediaPlayerSprite extends ScalableSprite
	{	
		/**
		 * Contructs a MediaPlaybackSprite 
		 **/
		public function MediaPlayerSprite(player:MediaPlayer = null)
		{
			super();	
			mediaPlayer = player ? player : new MediaPlayer(); 					
		}	
		
 		/**
		 * Source MediaElement displayed by this MediaPlayerSprite.  Setting the element will set
         * as the source on the mediaPlayer, if mediaPlayer is not null.
		 */
		public function set element(value:MediaElement):void
		{
			if(_player)
			{
				_player.source = value;
			}
		}
		
		public function get element():MediaElement
		{
			
			return _player ? _player.source : null;
		}
		
		/**
		 * The MediaPlayer that controls this media element.  defaults to org.openvideoplayer.MediaPlayer.  The _player needs to have it's source set either 
		 * on the MediaPlayer or after the MediaPlayer is set, the element must be set on the MediaPlayerSprite.
		 */ 
		public function get mediaPlayer():MediaPlayer
		{
			return _player;
		}	
			
		/**
		 * The MediaPlayer that controls this media element.
		 */ 
		public function set mediaPlayer(value:MediaPlayer):void
		{
			if (_player != null)
			{
				_player.removeEventListener(ViewChangeEvent.VIEW_CHANGE, onView);	
				_player.removeEventListener(MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE, onViewable);	
				_player.removeEventListener(DimensionChangeEvent.DIMENSION_CHANGE, onDimensions);	
				_player.removeEventListener(MediaPlayerCapabilityChangeEvent.SPATIAL_CHANGE, onSpatial);	
				view = null;
			}
			_player = value;
			if (_player != null)
			{
				_player.addEventListener(ViewChangeEvent.VIEW_CHANGE, onView);	
				_player.addEventListener(MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE, onViewable);	
				_player.addEventListener(DimensionChangeEvent.DIMENSION_CHANGE, onDimensions);	
				_player.addEventListener(MediaPlayerCapabilityChangeEvent.SPATIAL_CHANGE, onSpatial);	
				if (_player.viewable)
				{
					view = _player.view;		
				}
				if (_player.spatial)
				{
					setIntrinsicSize(_player.width, _player.height);
				}
			}
		}
						
		private function onView(event:ViewChangeEvent):void
		{	
			view = event.newView;				
		}
		
		private function onViewable(event:MediaPlayerCapabilityChangeEvent):void
		{	
			view = _player.view;				
		}
				
		private function onDimensions(event:DimensionChangeEvent):void
		{
			setIntrinsicSize(event.newWidth, event.newHeight);
		}
		
		private function onSpatial(event:MediaPlayerCapabilityChangeEvent):void
		{
			setIntrinsicSize(_player.width, _player.height);
		}
		
		
		/**
		 * The player class that exposes most of the MediaElement's interface, such as the viewable and dimensional 
		 * properties.
		 */ 
		private var _player:MediaPlayer ;
	}
}