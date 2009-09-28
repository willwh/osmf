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
	
	import org.openvideoplayer.display.ScaleMode;
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.gateways.RegionSprite;
	import org.openvideoplayer.layout.LayoutAttributesFacet;
	import org.openvideoplayer.layout.LayoutUtils;
	import org.openvideoplayer.layout.RegistrationPoint;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.MediaPlayer;
	import org.openvideoplayer.metadata.MetadataNamespaces;
	
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
			scaleMode = _scaleMode;	
			invalidateDisplayList();	
		}
		
		public function get element():MediaElement
		{
			return _mediaPlayer.source;
		}	
		
		[ChangeEvent('mediaPlayerChange')]
		public function get mediaPlayer():MediaPlayer
		{
			return _mediaPlayer;
		}
		
		public function set scaleMode(value:ScaleMode):void
		{
			_scaleMode = value;
			if(element != null)
			{
				LayoutUtils.setLayoutAttributes(element.metadata, value, RegistrationPoint.CENTER);
			}
		}
		
		public function get scaleMode():ScaleMode
		{
			return _scaleMode;
		}
		
		// Overrides
		//
		
		override protected function createChildren():void
		{
			super.createChildren();
			_playerSprite = new RegionSprite();				
			addChild(_playerSprite);
		}
			
		override protected function updateDisplayList(w:Number, h:Number):void
		{	
			super.updateDisplayList(w,h);
			if (element != null)
			{
				LayoutUtils.setAbsoluteLayout(element.metadata, w, h, 0, 0);
			}
		}
			
		private var _scaleMode:ScaleMode = ScaleMode.NONE;		
		private var _mediaPlayer:MediaPlayer = new MediaPlayer();			
		private var _playerSprite:RegionSprite;
	}
}
