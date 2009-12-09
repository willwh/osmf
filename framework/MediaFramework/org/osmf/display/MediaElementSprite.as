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
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.ViewEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.ViewTrait;

    /**
	 * Dispatched when the <code>width</code> and/or <code>height</code> property of the 
	 * source media has changed.
	 * 
	 * @eventType org.osmf.events.DimensionEvent.DIMENSION_CHANGE
	 */		
	 [Event(name="dimensionChange", type="org.osmf.events.DimensionEvent")]

	/**
	 * The MediaElementSprite class is designed to display media with IViewable and ISpatial properties.  It is based off
	 * of flash.display.Sprite to be both compatible with Flash and Flex workflows.   The IViewable and ISpatial events
	 * are adapted through this UI wrapper class. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class MediaElementSprite extends ScalableSprite
	{
		/**
		 * Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function MediaElementSprite()
		{
			super();				
		}
							
		/**
		 * Source MediaElement controlled by this MediaElementSprite.  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set element(value:MediaElement):void
		{
			if (_source)
			{
				_source.removeEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
				_source.removeEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);		
				if (_source.hasTrait(MediaTraitType.VIEW)) //Take care of event listeners
				{	
					onTraitRemove(new MediaElementEvent(MediaElementEvent.TRAIT_REMOVE, false, false, MediaTraitType.VIEW));
				}
			}
			_source = value;	
			if (_source)
			{	
				_source.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
				_source.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
				if (_source.hasTrait(MediaTraitType.VIEW)) 
				{					
					onTraitAdd(new MediaElementEvent(MediaElementEvent.TRAIT_ADD, false, false, MediaTraitType.VIEW));
				}
			}	
		}
		
		
		public function get element():MediaElement
		{
			return _source;
		}	
		
		private function onTraitAdd(event:MediaElementEvent):void
		{	
		 	switch (event.traitType)
		 	{
		 		case MediaTraitType.VIEW:
		 			var viewTrait:ViewTrait = _source.getTrait(MediaTraitType.VIEW) as ViewTrait;
		 		
		 			viewTrait.addEventListener(ViewEvent.VIEW_CHANGE, onView);
		 			viewTrait.addEventListener(ViewEvent.DIMENSION_CHANGE, onDimensions);
		 			
		 			view = viewTrait.view;
		 			setIntrinsicSize(viewTrait.mediaWidth, viewTrait.mediaHeight);		 			
		 			break;		 			
		 	}
		 }
		 
		 private function onTraitRemove(event:MediaElementEvent):void
		 {
		 	switch (event.traitType)
		 	{
		 		case MediaTraitType.VIEW:
		 			var viewTrait:ViewTrait = _source.getTrait(MediaTraitType.VIEW) as ViewTrait;
		 			
		 			viewTrait.removeEventListener(ViewEvent.DIMENSION_CHANGE, onDimensions);
		 			viewTrait.removeEventListener(ViewEvent.VIEW_CHANGE, onView);		 			

		 			view = null;
		 			break;		 			
		 	}
		 }
		 
		 private function onDimensions(event:ViewEvent):void
		 {
		 	setIntrinsicSize(event.newWidth, event.newHeight);	
		 	dispatchEvent(event.clone());	 	
		 }
		 
		 private function onView(event:ViewEvent):void
		 {
		 	view = event.newView;
		 }
		 
		 private var _source:MediaElement;
	}
}