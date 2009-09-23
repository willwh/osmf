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
package com.adobe.strobe.players
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import org.openvideoplayer.gateways.RegionSprite;
	import org.openvideoplayer.layout.LayoutUtils;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.MediaPlayer;
	
	/**
	 * Defines a Flex wrapper class for the MediaPlayerSprite class.
	 */	
	public class MediaPlayerWrapper extends UIComponent
	{		
		// Public API
		//
		
		public function set element(value:MediaElement):void
		{
			mediaPlayer.source = value;					
			_playerSprite.addElement(value);		
		}
		
		public function get element():MediaElement
		{
			return mediaPlayer.source;
		}	
		
		[ChangeEvent('mediaPlayerChange')]
		public function get mediaPlayer():MediaPlayer
		{
			return _mediaPlayer;
		}
				
		// Overrides
		//
		
		override protected function createChildren():void
		{
			super.createChildren();
			_mediaPlayer = new MediaPlayer();
			
			_playerSprite = new RegionSprite();				
			addChild(_playerSprite);
			
			dispatchEvent(new Event("mediaPlayerChange"));
		}
			
		override protected function updateDisplayList(w:Number, h:Number):void
		{	
			super.updateDisplayList(w,h);	
			_playerSprite.projectedWidth = w;
			_playerSprite.projectedHeight = h;
			if(element != null)
			{
				LayoutUtils.setAbsoluteLayout(element.metadata, w, h,0,0);
			}				
		}
			
		protected var _mediaPlayer:MediaPlayer;			
		protected var _playerSprite:RegionSprite;
	}
}
