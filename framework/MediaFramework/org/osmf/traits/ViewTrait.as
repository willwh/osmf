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
package org.osmf.traits
{
	import flash.display.DisplayObject;
	
	import org.osmf.events.ViewEvent;

	/**
	 * Dispatched when the trait's <code>view</code> property has changed.
	 * This occurs when a different DisplayObject is assigned to represent the media.
	 * 
	 * @eventType org.osmf.events.ViewEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.osmf.events.ViewEvent")]

	/**
	 * Dispatched when the trait's mediaWidth and/or mediaHeight property has changed.
	 * 
	 * @eventType org.osmf.events.ViewEvent.MEDIA_SIZE_CHANGE
	 */	
	[Event(name="mediaSizeChange",type="org.osmf.events.ViewEvent")]

	/**
	 * ViewTrait defines the trait interface for media that expose a DisplayObject,
	 * and which may have intrinsic dimensions.  The intrinsic dimensions of a piece of
	 * media refer to its dimensions without regard to those observed when it is projected
	 * onto the stage.
	 * 
	 * <p>For an image, for example, the intrinsic dimensions are the height and 
	 * width of the image as it is stored.</p>
	 * 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.VIEW)</code> method to query
	 * whether a media element has a trait of this type.
	 * If <code>hasTrait(MediaTraitType.VIEW)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.VIEW)</code> method
	 * to get an object that is of this type.</p>
	 * <p>Through its MediaElement, a ViewTrait can participate in media compositions.
	 * See the applicable class in the composition package for details about its behavior
	 * in this context.</p>
	 * 
	 * @see org.osmf.composition
	 * @see org.osmf.media.MediaElement
	 * @see flash.display.DisplayObject
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class ViewTrait extends MediaTraitBase
	{
		/**
		 * Constructor.
		 **/
		public function ViewTrait(view:DisplayObject, mediaWidth:Number=0, mediaHeight:Number=0)
		{
			super(MediaTraitType.VIEW);
			
			_view = view;
			_mediaWidth = mediaWidth;
			_mediaHeight = mediaHeight;
		}
		
		/**
		 * DisplayObject representing the media's view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get view():DisplayObject
		{
			return _view;
		}
		
		/**
		 * The intrinsic width of the media.
		 **/
		public function get mediaWidth():Number
		{
			return _mediaWidth;
		}
		
		/**
		 * The intrinsic height of the media.
		 **/
		public function get mediaHeight():Number
		{
			return _mediaHeight;
		}
		
		// Internals
		//
		
		/**
		 * Defines the trait's view. If the view is different from the one
		 * that is currently set, a viewChange event will be dispatched.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected final function setView(value:DisplayObject):void
		{
			if (_view != value)
			{
				viewChangeStart(value);
				
				var oldView:DisplayObject = _view;
				_view = value;
				
				viewChangeEnd(oldView);
			}
		}

		/**
		 * Sets the trait's width and height.
		 * 
		 * <p>Forces non numerical and negative values to zero.</p>
		 * 
		 * <p>If the either the width or the height differs from the
		 * previous width or height, dispatches a mediaSizeChange event.</p>
		 * 
		 * @param width The new width.
		 * @param height The new height.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected final function setMediaSize(mediaWidth:Number, mediaHeight:Number):void
		{
			if	(	mediaWidth != _mediaWidth
				||	mediaHeight != _mediaHeight
				)
			{
				mediaSizeChangeStart(mediaWidth, mediaHeight);
				
				var oldMediaWidth:Number = _mediaWidth;
				var oldMediaHeight:Number = _mediaHeight;
				
				_mediaWidth = mediaWidth;
				_mediaHeight = mediaHeight;
				
				mediaSizeChangeEnd(oldMediaWidth, oldMediaHeight);
			}
		}
				
		/**
		 * Called immediately before the <code>view</code> property is changed. 
		 * <p>Subclasses can override this method to communicate the change to the media.</p>
		 * @param newView New <code>view</code> value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function viewChangeStart(newView:DisplayObject):void
		{
		}
		
		/**
		 * Called just after the <code>view</code> property has changed.
		 * Dispatches the change event.
		 * <p>Subclasses that override should call this method to
		 * dispatch the viewChange event.</p>
		 *  
		 * @param oldView Previous <code>view</code> value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function viewChangeEnd(oldView:DisplayObject):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.VIEW_CHANGE, false, false, oldView, _view));
		}
				
		/**
		 * Called just before a call to <code>setMediaSize()</code>. 
		 * Subclasses can override this method to communicate the change to the media.
		 * @param newMediaWidth New <code>mediaWidth</code> value.
		 * @param newMediaHeight New <code>mediaHeight</code> value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function mediaSizeChangeStart(newMediaWidth:Number, newMediaHeight:Number):void
		{
		}
		
		/**
		 * Called just after <code>setMediaSize()</code> has applied new mediaWidth
		 * and/or mediaHeight values. Dispatches the change event.
		 * 
		 * <p>Subclasses that override should call this method 
		 * to dispatch the mediaSizeChange event.</p>
		 *  
		 * @param oldMediaWidth Previous <code>mediaWidth</code> value.
		 * @param oldMediaHeight Previous <code>mediaHeight</code> value.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function mediaSizeChangeEnd(oldMediaWidth:Number, oldMediaHeight:Number):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.MEDIA_SIZE_CHANGE, false, false, null, null, oldMediaWidth, oldMediaHeight, _mediaWidth, _mediaHeight));
		}

		private var _view:DisplayObject;
		private var _mediaWidth:Number = 0;
		private var _mediaHeight:Number = 0;
	}
}