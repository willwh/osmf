/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/

package org.osmf.traits
{
	import org.osmf.media.IMediaTrait;

	/**
	 * Dispatched when a stream switch is requested, completed, or failed.
	 * 
	 * @eventType org.osmf.events.SwitchEvent.SWITCHING_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	[Event(name="switchingChange",type="org.osmf.events.SwitchEvent")]
	
	/**
	 * Dispatched when the number of indices or associated bitrates have changed.
	 * 
	 * @eventType org.osmf.events.SwitchEvent.INDICES_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	[Event(name="indicesChange",type="org.osmf.events.SwitchEvent")]

	
	/**
	 * ISwitchable defines the trait interface for media supporting dynamic stream switching.
	 * 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.SWITCHABLE)</code> method to query
	 * whether a media element has a trait that implements this interface. 
	 * If <code>hasTrait(MediaTraitType.SWITCHABLE)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.SWITCHABLE)</code> method
	 * to get an object that is guaranteed to implement the ISwitchable interface.</p>
	 * <p>Through its MediaElement, an ISwitchable trait can participate in media compositions.
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
	public interface ISwitchable extends IMediaTrait
	{
		/**
		 * Defines whether or not the ISwitchable trait should be in manual 
		 * or autoswitch mode. If in manual mode the <code>switchTo</code>
		 * method can be used to manually switch to a specific stream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get autoSwitch():Boolean;
		function set autoSwitch(value:Boolean):void;
		
		/**
		 * The index of the item currently rendering. Uses a zero-based index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get currentIndex():int;
		
		/**
		 * Gets the associated bitrate, in kilobits per second for the specified index.
		 * 
		 * @throws RangeError If the specified index is less than zero or
		 * greater than the highest index available.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		function getBitrateForIndex(index:int):Number
		
		/**
		 * The maximum available index. This can be set at run-time to 
		 * provide a ceiling for your switching profile. For example,
		 * to keep from switching up to a higher quality stream when 
		 * the current video is too small to realize the added value
		 * of a higher quality stream.
		 * 
		 * @throws RangeError If the specified index is less than zero or
		 * greater than the highest index available.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get maxIndex():int;
		function set maxIndex(value:int):void;
		
		/**
		 * Indicates whether or not a switch is currently in progress.
		 * This property will return <code>true</code> while a switch has been 
		 * requested and the switch has not yet been acknowledged and no switch failure 
		 * has occurred.  Once the switch request has been acknowledged or a 
		 * failure occurs, the property will return <code>false</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get switchUnderway():Boolean;
		
		/**
		 * Switch to a specific index. To switch up, use the <code>currentIndex</code>
		 * property, such as:<p>
		 * <code>
		 * obj.switchTo(obj.currentIndex + 1);
		 * </code>
		 * </p>
		 * @throws RangeError If the specified index is less than zero or
		 * greater than <code>maxIndex</code>.
		 * @throws IllegalOperationError If the stream is not in manual switch mode.
		 * 
		 * @see maxIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function switchTo(index:int):void;
		
	}
}
