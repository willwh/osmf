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
	import org.osmf.events.MediaElementChangeEvent;
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.LayoutMetadata;
	import org.osmf.layout.ScaleMode;
	import org.osmf.layout.VerticalAlign;
	
	/**
	 * <code>MediaPlayerSprite</code> provides MediaPlayer, MediaContainer, and MediaFactory
	 * capabilities all in one Sprite based class.  It also provides convenience methods to generate
	 * mediaElements from a resource, as well as a scaleMode setter. 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0	 	 
	 **/
	public class MediaPlayerSprite extends Sprite
	{	
		/**
		 * Constructor.
		 * 
		 * @param mediaPlayer A custom MediaPlayer can be provided. if null, defaults to new MediaPlayer
		 * @param mediaContainer A custom MediaContainer can be provided. if null defaults to a new MediaContainer
		 * @param mediaFactory A custom MediaFactory can be provided. if null defaults to a new DefaultMediaFactory
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0	 	 
		 **/
		public function MediaPlayerSprite(mediaPlayer:MediaPlayer = null, mediaContainer:MediaContainer = null, mediaFactory:MediaFactory = null)
		{
			_mediaPlayer = mediaPlayer ? mediaPlayer : new MediaPlayer();
			_mediaFactory = mediaFactory;
			_mediaContainer = mediaContainer ? mediaContainer : new MediaContainer();
			_mediaPlayer.addEventListener(MediaElementChangeEvent.MEDIA_ELEMENT_CHANGE, onMediaElementChange);
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
		 * both from the player and container.  Existing in properties, such as layout will be
		 * preserved on media.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get media():MediaElement
		{
			return _media;
		}

		public function set media(value:MediaElement):void
		{
			if (_media != value)
			{
				if (_media && _mediaContainer.containsMediaElement(_media))
				{
					_mediaContainer.removeMediaElement(_media);
				}
				_media = value;				
				if (_media && _media.getMetadata(LayoutMetadata.LAYOUT_NAMESPACE) == null)
				{
					var layout:LayoutMetadata = new LayoutMetadata();
					layout.scaleMode = _scaleMode;
					layout.verticalAlign = VerticalAlign.MIDDLE;
					layout.horizontalAlign = HorizontalAlign.CENTER;
					layout.percentWidth = 100;
					layout.percentHeight = 100;
					_media.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, layout);
				}				
				_mediaPlayer.media = value;
				if (value && !_mediaContainer.containsMediaElement(value) )
				{
					_mediaContainer.addMediaElement(value);
				}				
			}		
		}
					
		/**
		 * This function creates a new media element from the supplied
		 * media resource.  It uses the media factory, and sets the mediaElement
		 * property on this MediaPlayerSprite.  If null, it will remove the existing 
		 * mediaElement and resource from the player and container.  If the MediaFactory 
		 * can't create a MediaElement from the given resource, it will set the media 
		 * and resource to null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function get resource():MediaResourceBase
		{
			return _media ? _media.resource : null;
		}

		public function set resource(value:MediaResourceBase):void
		{
			media = value ? mediaFactory.createMediaElement(value) : null;			
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
			_mediaFactory = _mediaFactory ? _mediaFactory : new DefaultMediaFactory();
			return _mediaFactory;
		}
			
		/**
		 * The <code>scaleMode</code> property describes different ways of laying out the media content within this sprite.
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
			_scaleMode = value;
			if (_media)
			{
				var layout:LayoutMetadata = _media.getMetadata(LayoutMetadata.LAYOUT_NAMESPACE) as LayoutMetadata;
				layout.scaleMode = value;
			}		
		}
		
		/**
		 * @private
		 */ 
		override public function set width(value:Number):void
		{
			_mediaContainer.width = value;
		}
		
		/**
		 * @private
		 */ 
		override public function set height(value:Number):void
		{	
			_mediaContainer.height = value;			
			
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
		
		private function onMediaElementChange(event:MediaElementChangeEvent):void
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