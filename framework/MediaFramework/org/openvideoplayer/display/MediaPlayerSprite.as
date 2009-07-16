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
package org.openvideoplayer.display
{
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.events.MediaPlayerCapabilityChangeEvent;
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.MediaPlayer;
	
	/**
	 * The MediaPlaybackSprite is designed to allow a MediaElement with an IViewable trait to be placed on the display list.  
	 * It supports the scalemodes of the ScalableSprite sprite, as well as the creation of a  MediaPlayer controller class.
	 **/
	public class MediaPlayerSprite extends ScalableSprite
	{	
		/**
		 * Contructs a MediaPlayerSprite 
		 * @param player A custom MediaPlayer can be provided.
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
		 * The MediaPlayer that controls this media element.  Defaults to an instance of org.openvideoplayer.MediaPlayer.  The player needs to have it's source set either 
		 * on the MediaPlayer or on this object (see element) after this property is set.
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
		 
		public function get mediaPlayer():MediaPlayer
		{
			return _player;
		}				
						
		private function onView(event:ViewChangeEvent):void
		{	
			view = event.newView;				
		}
		
		private function onViewable(event:MediaPlayerCapabilityChangeEvent):void
		{	
			view = event.enabled ? _player.view : null;				
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