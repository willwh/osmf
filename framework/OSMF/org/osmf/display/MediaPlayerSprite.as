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
	import flash.display.Sprite;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.LayoutRendererProperties;
	import org.osmf.layout.VerticalAlign;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	
	/**
	 * MediaPlayerSprite allows a MediaElement with a DisplayObjectTrait to be placed on the display list.  
	 * It supports the <code>scaleMode</code>, as well as the creation of a MediaPlayer controller class.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class MediaPlayerSprite extends Sprite
	{	
		/**
		 * Constructs a <code>MediaPlayerSprite</code>  
		 * @param player A custom MediaPlayer can be provided.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function MediaPlayerSprite(player:MediaPlayer = null)
		{
			super();	
			mediaPlayer = player != null ? player : new MediaPlayer(); 		
			mediaContainer = new MediaContainer();
			mediaContainer.clipChildren = true;
			addChild(mediaContainer);			
		}	
		
 		/**
		 * Source MediaElement displayed by this <code>MediaPlayerSprite</code> .  Setting the element will set
         * as the element on the mediaPlayer, if mediaPlayer is not null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set mediaElement(value:MediaElement):void
		{
			
			if (_mediaElement != value)
			{
				if (_mediaElement != null && _mediaElement.container)
				{
					_mediaElement.container.removeMediaElement(_mediaElement);
				}		
				
				_mediaElement = value;	
				
				if (_mediaElement != null)
				{
					mediaContainer.addMediaElement(_mediaElement);
					
					var layout:LayoutRendererProperties = new LayoutRendererProperties(_mediaElement);
					layout.scaleMode = _scaleMode;
					layout.verticalAlign = VerticalAlign.MIDDLE;
					layout.horizontalAlign = HorizontalAlign.CENTER;
				}
				
				_mediaPlayer.media = _mediaElement;
			}
		}
		
		public function get mediaElement():MediaElement
		{			
			return _mediaElement;
		}
		
		/**
		 * The MediaPlayer that controls this media element.  Defaults to an instance of org.osmf.MediaPlayer.  The player needs to have it's mediaElement set either 
		 * on the MediaPlayer or on this object (see mediaElement) after this property is set.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function set mediaPlayer(value:MediaPlayer):void
		{
			if (_mediaPlayer != value)
			{
				_mediaPlayer = value;
				_mediaPlayer.media = _mediaElement;
			}
			
		}		
		 
		public function get mediaPlayer():MediaPlayer
		{
			return _mediaPlayer;
		}
								
		/**
		 * The <code>scaleMode</code> property describes different ways of laying out the media content within a this sprite.
		 * <code>scaleMode</code> can be set to <code>none</code>, <code>straetch</code>, <code>letterbox</code> or <code>zoom</code>.
		 * <code>MediaElementSprite</code> uses the value to calculate the layout.  The default scale mode is LETTERBOX.
		 * @see org.osmf.display.ScaleMode for usage examples.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 			
		public function get scaleMode():String
		{
			return _scaleMode;
		}
		
		public function set scaleMode(value:String):void
		{
			if (_scaleMode != value)
			{				
				_scaleMode = value;
				if (_mediaElement != null)
				{
					var layout:LayoutRendererProperties = new LayoutRendererProperties(_mediaElement);
					layout.scaleMode = _scaleMode;
					layout.verticalAlign = VerticalAlign.MIDDLE;
					layout.horizontalAlign = HorizontalAlign.CENTER;
					
					mediaContainer.validateNow();
				}
			}
		}					
		
		/**
		 * @private
		 */ 
		override public function set width(value:Number):void
		{
			mediaContainer.width = value;
			mediaContainer.validateNow();
		}
				
		/**
		 * @private
		 */ 
		override public function get width():Number
		{					
			return mediaContainer.width;
		}
		
		/**
		 * @private
		 */ 
		override public function set height(value:Number):void
		{
			mediaContainer.height = value;
			mediaContainer.validateNow();
		}
				
		/**
		 * @private
		 */ 
		override public function get height():Number
		{					
			return mediaContainer.height;
		}
						
		private var mediaContainer:MediaContainer;
		
		private var _scaleMode:String = ScaleMode.LETTERBOX;
		private var _mediaElement:MediaElement;
		private var _mediaPlayer:MediaPlayer;
	}
}