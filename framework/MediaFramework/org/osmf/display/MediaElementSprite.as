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
	import flash.events.Event;
	
	import org.osmf.events.DimensionEvent;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.ViewEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.ISpatial;
	import org.osmf.traits.IViewable;
	import org.osmf.traits.MediaTraitType;

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
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class MediaElementSprite extends ScalableSprite
	{
		/**
		 * Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function set element(value:MediaElement):void
		{
			if (_source)
			{
				_source.removeEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
				_source.removeEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);		
				if (_source.hasTrait(MediaTraitType.VIEWABLE)) //Take care of event listeners
				{	
					onTraitRemove(new MediaElementEvent(MediaElementEvent.TRAIT_REMOVE, false, false, MediaTraitType.VIEWABLE));
				}
				if (_source.hasTrait(MediaTraitType.SPATIAL))
				{	
					onTraitRemove(new MediaElementEvent(MediaElementEvent.TRAIT_REMOVE, false, false, MediaTraitType.SPATIAL));
				}
			}
			_source = value;	
			if (_source)
			{	
				_source.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
				_source.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
				if (_source.hasTrait(MediaTraitType.VIEWABLE)) 
				{					
					onTraitAdd(new MediaElementEvent(MediaElementEvent.TRAIT_ADD, false, false, MediaTraitType.VIEWABLE));
				}
				if (_source.hasTrait(MediaTraitType.SPATIAL))
				{
					onTraitAdd(new MediaElementEvent(MediaElementEvent.TRAIT_ADD, false, false, MediaTraitType.SPATIAL));
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
		 		case MediaTraitType.SPATIAL:
		 			_source.getTrait(MediaTraitType.SPATIAL).addEventListener(DimensionEvent.DIMENSION_CHANGE, onDimensions);
					setIntrinsicSize(ISpatial(_source.getTrait(MediaTraitType.SPATIAL)).width, ISpatial(_source.getTrait(MediaTraitType.SPATIAL)).height);
		 			break;
		 		case MediaTraitType.VIEWABLE:
		 			_source.getTrait(MediaTraitType.VIEWABLE).addEventListener(ViewEvent.VIEW_CHANGE, onView);
		 			view = (_source.getTrait(MediaTraitType.VIEWABLE) as IViewable).view;		 			
		 			break;		 			
		 	}
		 }
		 
		 private function onTraitRemove(event:MediaElementEvent):void
		 {
		 	switch (event.traitType)
		 	{
		 		case MediaTraitType.SPATIAL:
		 			_source.getTrait(MediaTraitType.SPATIAL).removeEventListener(DimensionEvent.DIMENSION_CHANGE, onDimensions);
		 			break;
		 		case MediaTraitType.VIEWABLE:
		 			view = null;
		 			_source.getTrait(MediaTraitType.VIEWABLE).removeEventListener(ViewEvent.VIEW_CHANGE, onView);		 			
		 			break;		 			
		 	}
		 }
		 
		 private function onDimensions(event:DimensionEvent):void
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