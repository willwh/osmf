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

package org.osmf.net.dynamicstreaming
{
	import flash.net.NetStream;
	
	/**
	 * NetStream Metrics Interface
     * Defines an interface that a class must implement to provide netstream metrics
     * for dynamic switching rules. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public interface INetStreamMetrics
	{
		/**
		 * <code>True</code> if the target buffer has been reached by the stream.
		*  
		*  @langversion 3.0
		*  @playerversion Flash 10
		*  @playerversion AIR 1.0
		*  @productversion OSMF 1.0
		*/
		function get reachedTargetBufferFull():Boolean;
		
		/**
		 * The target buffer time for the stream. This target is the buffer level at which the 
		 * stream is considered stable. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get targetBufferTime():Number;
		function set targetBufferTime(targetBufferTime:Number):void;
				
		/**
		 * The expected frame rate for this NetStream. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get expectedFPS():Number;
		
		/**
		 * The frame drop rate calculated over the last interval.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get droppedFPS():Number;
		
		/**
		 * Returns the average frame-drop rate
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get averageDroppedFPS():Number;

		/**
		 * The last maximum bandwidth measurement in kbps.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get maxBandwidth():Number;
		
		/**
		 * The average max bandwidth value, in kbps.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get averageMaxBandwidth():Number;
		
		/**
		 * The current stream index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get currentIndex():int;
		function set currentIndex(value:int):void;
		
		/**
		 * Returns the maximum index value 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		function get maxIndex():int;
		
		/**
		 * The DynamicStreamingResource which the class is referencing.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get dynamicStreamingResource():DynamicStreamingResource;
		function set dynamicStreamingResource(value:DynamicStreamingResource):void;
		/**
		 * The current buffer length of the NetStream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get bufferLength():Number;
		
		/**
		 * The current buffer Time of the NetStream
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get bufferTime():Number;
		
		/**
		 * Returns the NetStream the class is working with.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get netStream():NetStream;
		
		/**
		 * Flash player can have problems attempting to accurately estimate max bytes available with live streams. The server will buffer the 
		 * content and then dump it quickly to the client. The client sees this as an oscillating series of maxBytesPerSecond measurements, where
		 * the peak roughly corresponds to the true estimate of max bandwidth available. Setting this parameter to true will cause a class implementing
		 * this interface to optimize its estimate for averageMaxBandwidth. It should only be set true for live streams and should always be 
		 * false for on demand streams. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function get optimizeForLivebandwidthEstimate ():Boolean;		
		function set optimizeForLivebandwidthEstimate(optimizeForLivebandwidthEstimate:Boolean):void;
		
		/**
		 * Enables this metrics engine.  The background processes will only resume on the next
		 * netStream.Play.Start event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function enable():void;
		
		/**
		 * Disables this metrics engine. The background averaging processes
		 * are stopped. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		function disable():void
	}
}
