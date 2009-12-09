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
	import org.osmf.media.IMediaTrait;
	
	/**
	 * Dispatched when the ISpatial trait's width and/or height property has changed.
	 * 
	 * @eventType org.osmf.events.DimensionEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.osmf.events.DimensionEvent")]
	
	/**
	 * ISpatial defines the trait interface for media that expose intrinsic dimensions.
	 * The intrinsic dimensions of a piece of media refer to the its dimensions without
	 * regard to those observed when it is projected onto the stage.
	 * <p>For an image, for example, the intrinsic dimensions are the height and 
	 * width of the image as it is stored.</p>
	 * 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.SPATIAL)</code> method to query
	 * whether a media element has a trait that implements this interface. 
	 * If <code>hasTrait(MediaTraitType.SPATIAL)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.SPATIAL)</code> method
	 * to get an object that is guaranteed to implement the ISpatial interface.</p>
	 * <p>Through its MediaElement, an ISpatial trait can participate in media compositions.
	 * See the applicable class in the composition package for details about its behavior
	 * in this context.</p>
	 * 
	 * @see org.osmf.composition
	 * @see org.osmf.media.MediaElement
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public interface ISpatial extends IMediaTrait
	{
		/**
		 * Intrinsic width of the spatial media in pixels.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get width():Number;
		
		/**
		 * Intrinsic height of the spatial media in pixels.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get height():Number;
	}
}