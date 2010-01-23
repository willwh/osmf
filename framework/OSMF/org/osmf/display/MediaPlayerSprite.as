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
	import org.osmf.layout.LayoutUtils;
	import org.osmf.layout.RegistrationPoint;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	
	/**
	 * <code>MediaPlayerSprite</code> allows a <code>MediaElement</code> with a ViewTrait to be placed on the display list.  
	 * It supports the <code>scaleMode</code> of the <code>ScalableSprite</code>, as well as the creation of a <code>MediaPlayer</code> controller class.
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
			_containerSprite = new MediaContainer();
			addChild(_containerSprite);			
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
			
			if (_element != value)
			{
				if (_element != null && _element.container)
				{
					_element.container.removeMediaElement(_element);
				}		
				_element = value;	
				if (_element != null)
				{
					LayoutUtils.setLayoutAttributes(_element.metadata, 	_scaleMode, RegistrationPoint.CENTER);
					LayoutUtils.setRelativeLayout(_element.metadata, 100, 100);
					_containerSprite.addMediaElement(_element);
				}
				_player.media = _element;
				
			}
		}
		
		public function get mediaElement():MediaElement
		{			
			return _element;
		}
		
		/**
		 * The MediaPlayer that controls this media element.  Defaults to an instance of org.osmf.MediaPlayer.  The player needs to have it's element set either 
		 * on the MediaPlayer or on this object (see element) after this property is set.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function set mediaPlayer(value:MediaPlayer):void
		{
			if (_player != value)
			{
				_player = value;
				_player.media = _element;
			}
			
		}		
		 
		public function get mediaPlayer():MediaPlayer
		{
			return _player;
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
			if(_scaleMode != value)
			{				
				_scaleMode = value;
				if (_element != null)
				{
					LayoutUtils.setLayoutAttributes(_element.metadata, value, RegistrationPoint.CENTER);
					_containerSprite.validateNow();
				}
			}
		}					
		
		/**
		 * @private
		 */ 
		override public function set width(value:Number):void
		{
			_containerSprite.width = value;
			if (_element != null)
			{
				LayoutUtils.setAbsoluteLayout(_containerSprite.metadata, value, height);
				_containerSprite.validateNow();
			}
		}
				
		/**
		 * @private
		 */ 
		override public function get width():Number
		{					
			return _containerSprite.width;
		}
		
		/**
		 * @private
		 */ 
		override public function set height(value:Number):void
		{
			_containerSprite.height = value;
			if (_element != null)
			{
				LayoutUtils.setAbsoluteLayout(_containerSprite.metadata, width, value);
				_containerSprite.validateNow();
			}
		}
				
		/**
		 * @private
		 */ 
		override public function get height():Number
		{					
			return _containerSprite.height;
		}
						
		private var _scaleMode:String = ScaleMode.LETTERBOX;
		private var _element:MediaElement;
		private var _containerSprite:MediaContainer;
		private var _player:MediaPlayer;
		
	}
}