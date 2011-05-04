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
	import flash.events.EventDispatcher;
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
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function HTTPStreamingMixerBase()
		{
		}
		
		public function mixFileSegment(input:IDataInput, input1:IDataInput):ByteArray
		{
			throw new IllegalOperationError("The processFileSegment() method must be overridden by HttpStreamingFileHandlerBase's derived class.");
		}
		
		public function mixMDATBytes(input:IDataInput, input1:IDataInput):ByteArray
		{
			throw new IllegalOperationError("The mixMDATBytes() method must be overridden by HttpStreamingFileHandlerBase's derived class.");
		}
		
		public function get mixedAudioTime():uint
		{
			throw new IllegalOperationError("The mixedAudioTime() method must be overridden by HttpStreamingFileHandlerBase's derived class.");
		}
		
		public function get mixedVideoTime():uint
		{
			throw new IllegalOperationError("The mixedVideoTime() method must be overridden by HttpStreamingFileHandlerBase's derived class.");
		}
		
		public function get videoInput():ByteArray
		{
			throw new IllegalOperationError("The videoInput() method must be overridden by HttpStreamingFileHandlerBase's derived class.");
		}
		
		public function get audioInput():ByteArray
		{
			throw new IllegalOperationError("The audioInput() method must be overridden by HttpStreamingFileHandlerBase's derived class.");
		}
		
		public function flushVideoInput():void
		{
		}
		
		public function flushAudioInput():void
		{
		}
		
		public function get mdatBytesPending():uint
		{
			throw new IllegalOperationError("The mdatBytesPending() method must be overridden by HttpStreamingFileHandlerBase's derived class.");
		}
	}
}