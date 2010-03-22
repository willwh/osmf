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
package org.osmf.media
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.layout.LayoutMetadata;
	import org.osmf.layout.ScaleMode;
	
	/**
	 * <code>MediaPlayerSprite</code> provides MediaPlayer, MediaContainer, and MediaFactory
	 * capabilities all in one Sprite based class.  It also provides convenience methods to generate
	 * mediaElements from a resource, as well as a scaleMode setter. 
	 **/
	public class MediaPlayerSprite extends Sprite
	{	
		/**
		 * Constructs a <code>MediaPlayerSprite</code>  
		 * @param player A custom MediaPlayer can be provided. if null, defaults to new MediaPlayer
		 * @param container A custom MediaContainer can be provided. if null defaults to a new MediaContainer
		 * @param factory A custom MediaFactory can be provided. if null defaults to a new DefaultMediaFactory
		 **/
		public function MediaPlayerSprite(mediaPlayer:MediaPlayer = null, mediaContainer:MediaContainer = null, mediaFactory:MediaFactory = null)
		{
			_mediaPlayer = mediaPlayer ? mediaPlayer : new MediaPlayer();
			_mediaFactory = mediaFactory ? mediaFactory : new DefaultMediaFactory();
			_mediaContainer = mediaContainer ? mediaContainer : new MediaContainer();
			_mediaPlayer.addEventListener("mediaChange", onMediaElementChange);
			addChild(_mediaContainer);
			
			if (_mediaPlayer.media != null)
			{
				media = _mediaPlayer.media;
			}			
		}
		
		/**
		 * Source MediaElement displayed by this <code>MediaPlayerSprite</code> .  
		 * Setting the element will set it as the media on the mediaPlayer, 
		 * and add it to the media container.  Setting this property to null will remove it
		 * both from the player and container.
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set media(value:MediaElement):void
		{
			if (_media != value)
			{
				if (_media)
				{
					_mediaContainer.removeMediaElement(_media);
				}
				_media = value;				
				_mediaPlayer.media = value;
				if (value && !_mediaContainer.containsMediaElement(value) )
				{
					_mediaContainer.addMediaElement(value);
				}
				scaleMode = _scaleMode;
			}		
		}
		
		public function get media():MediaElement
		{
			return _media
		}
			
		/**
		 * This function creates a new media element from the supplied
		 * media resource.  It uses the media factory, and sets the mediaElement
		 * property on this MediaPlayerSprite.  If null, it will remove the existing 
		 * mediaElement and resource from the player and container.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function set resource(value:MediaResourceBase):void
		{
			media = _mediaFactory.createMediaElement(value);			
		}
		
		public function get resource():MediaResourceBase
		{
			return _media ? _media.resource : null;
		}
			
		/**
		 * The MediaPlayer that controls this media element.  Defaults to an instance of org.osmf.media.MediaPlayer. 
		 * When an element is set directly on the mediaPlayer, the media element is propogated to the MediaPlayerSprite,
		 * and the MediaContainer.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function get mediaPlayer():MediaPlayer
		{
			return _mediaPlayer;
		}
		
		/**
		 * The MediaContainer that is used with this class.  Defaults to an instance of 
		 * org.osmf.MediaContainer.  Any media elements added or removed through 
		 * addMediaElement() or removeMediaElement() are not propagated to the mediaPlayer
		 * In order to set the mediaElement, use the setter on the MediaPlayerSprite.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function get mediaContainer():MediaContainer
		{
			return _mediaContainer;
		}
		
		/**
		 * The MediaFactory that is used with this class.  Defaults to an instance of 
		 * org.osmf.DefaultMediaFactory.  Plugins should be loaded through this media 
		 * factory.  Media elements created through this factory aren't added
		 * to the mediaPlayer or mediaContainer.  To associate a new element, set the element 
		 * property on this class.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function get mediaFactory():MediaFactory
		{
			return _mediaFactory;
		}
			
		/**
		 * The <code>scaleMode</code> property describes different ways of laying out the media content within a this sprite.
		 * <code>scaleMode</code> can be set to <code>none</code>, <code>stretch</code>, <code>letterbox</code> or <code>zoom</code>.
		 * <code>MediaElementSprite</code> uses the value to calculate the layout.   This property is persistent between media element.
		 * By default the MediaContainer sets the layout to be 100% width, 100% height , and centered.  
		 * The default value is <code>letterbox</code>.
		 * @see org.osmf.layout.ScaleMode for usage examples.
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
			if (_media)
			{
				var layout:LayoutMetadata = _media.getMetadata(LayoutMetadata.LAYOUT_NAMESPACE) as LayoutMetadata;
				if (!layout)
				{
					layout = new LayoutMetadata();
					_media.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, layout);
				}
				_scaleMode = layout.scaleMode = value;
			}			
		}
		
		/**
		 * @private
		 */ 
		override public function set width(value:Number):void
		{
			_mediaContainer.layout(value, height);
		}
		
		/**
		 * @private
		 */ 
		override public function set height(value:Number):void
		{
			_mediaContainer.layout(width, value);
		}
		
		/**
		 * @private
		 */ 
		override public function get width():Number
		{
			return _mediaContainer.width;
		}
		
		/**
		 * @private
		 */ 
		override public function get height():Number
		{
			return _mediaContainer.height;
		}
		
		private function onMediaElementChange(event:Event):void
		{
			media = _mediaPlayer.media;
		}
		
		private var _scaleMode:String = ScaleMode.LETTERBOX;
		private var _media:MediaElement;
		private var _mediaPlayer:MediaPlayer;
		private var _mediaFactory:MediaFactory;
		private var _mediaContainer:MediaContainer;
		
								
	}
}