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
	 * Dispatched when total size in bytes of data being loaded has changed.
	 * 
	 * @eventType org.osmf.events.BytesTotalChangeEvent
	 */	
	[Event(name="bytesTotalChange",type="org.osmf.events.BytesTotalChangeEvent")]

	/**
	 * IDownloadable defines the interface that can be used to access the progress
	 * of data load operations.
	 */	
	public interface IDownloadable extends IMediaTrait
	{
		/**
		 * The number of bytes of data that have been loaded.
		 */
		function get bytesLoaded():Number;
		
		/**
		 * The total size in bytes of the data being loaded.
		 */
		function get bytesTotal():Number;
	}
}