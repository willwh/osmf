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
package org.osmf.events
{
	import flash.events.Event;

	/*
	 * This event is dispatched by the MediaPlayer class when the value of 
	 * the property "bytesDownloaded" has changed, which indicates the progress of a download operation.
	 */
	public class BytesDownloadedEvent extends Event
	{
		public static const BYTES_DOWNLOADED:String = "bytesDownloaded";

		public function BytesDownloadedEvent(
			bytesDownloaded:Number, bytesTotal:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(BYTES_DOWNLOADED, bubbles, cancelable);
			
			_bytesDownloaded = bytesDownloaded;
			_bytesTotal = bytesTotal;
		}
		
		/*
		 * The number of bytes of data that have been downloaded into the application.
		 */
		public function get bytesDownloaded():Number
		{
			return _bytesDownloaded;
		}
		
		/*
		 * The total size in bytes of the datat being downloaded into the application.
		 */
		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
		//
		// Internal
		//
		
		private var _bytesDownloaded:Number;
		private var _bytesTotal:Number;
	}
}