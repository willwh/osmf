/*****************************************************
*  
*  Copyright 2011 Adobe Systems Incorporated.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.net.httpstreaming
{
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * Mixer class.
	 */
	public class HTTPStreamingMixerBase 
	{
		/**
		 * Default constructor.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		public function HTTPStreamingMixerBase()
		{
		}

		/**
		 * Flag indicating the mixer needs more audio.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		public function get needsAudio():Boolean
		{
			throw new IllegalOperationError("The needsAudio() method must be overridden by HTTPStreamingMixerBase's derived class.");
		}
		
		/**
		 * Gets the last audio time in miliseconds.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		public function get audioTime():uint
		{
			throw new IllegalOperationError("The audioTime() method must be overridden by HTTPStreamingMixerBase's derived class.");
		}

		/**
		 * Flag indicating the mixer needs more video.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		public function get needsVideo():Boolean
		{
			throw new IllegalOperationError("The needsVideo() method must be overridden by HTTPStreamingMixerBase's derived class.");
		}

		/**
		 * Gets the last video time in miliseconds.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		public function get videoTime():uint
		{
			throw new IllegalOperationError("The videoTime() method must be overridden by HTTPStreamingMixerBase's derived class.");
		}
		
		/**
		 * Flushes the internal cache of video data.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		public function flushVideoInput():void
		{
			throw new IllegalOperationError("The flushVideoInput() method must be overridden by HTTPStreamingMixerBase's derived class.");
		}
		
		/**
		 * Flushes the internal cache of audio data.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		public function flushAudioInput():void
		{
			throw new IllegalOperationError("The flushAudioInput() method must be overridden by HTTPStreamingMixerBase's derived class.");
		}
		
		/**
		 * Returns the mixed stream.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		public function getMixedMDATBytes():ByteArray
		{
			throw new IllegalOperationError("The getMixedMDATBytes() method must be overridden by HTTPStreamingMixerBase's derived class.");
		}
		
		/**
		 * Mixes two media streams based on their time codes.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		public function mixMDATBytes(videoInput:IDataInput, audioInput:IDataInput):void
		{
			throw new IllegalOperationError("The mixMDATBytes() method must be overridden by HTTPStreamingMixerBase's derived class.");
		}
	}
}