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
*  Contributor(s): Akamai Technologies
*  
*****************************************************/
package org.osmf.netmocker
{
	public interface IMockNetStream
	{
		/**
		 * The expected duration of the stream, in seconds.  Necessary so that
		 * this mock stream class knows when to dispatch the events related
		 * to a stream completing.  The default is zero.
		 **/
		function set expectedDuration(value:Number):void;
		function get expectedDuration():Number;
		
		/**
		 * The expected width of the stream, in pixels.  Necessary so that
		 * this mock stream class knows the dimensions to include in the
		 * onMetaData callback.  The default is zero.
		 **/
		function set expectedWidth(value:Number):void;
		function get expectedWidth():Number;
		
		/**
		 * The expected height of the stream, in pixels.  Necessary so that
		 * this mock stream class knows the dimensions to include in the
		 * onMetaData callback.  The default is zero.
		 **/
		function set expectedHeight(value:Number):void;
		function get expectedHeight():Number;
		
		/**
		 * An Array of EventInfos, representing the events that are expected
		 * to be dispatched when the playhead has passed a certain position.
		 **/
		function set expectedEvents(value:Array):void;
		function get expectedEvents():Array;
	}
}
