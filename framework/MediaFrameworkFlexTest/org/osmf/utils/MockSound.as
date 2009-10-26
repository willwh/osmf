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
package org.osmf.utils
{
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	public class MockSound extends Sound
	{
		public function MockSound(stream:URLRequest=null, context:SoundLoaderContext=null)
		{
			super(stream, context);
		}
		
		public function set bytesLoaded(value:uint):void
		{
			_bytesLoaded = value;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _bytesLoaded, _bytesTotal));
		}
		
		override public function get bytesLoaded():uint
		{
			return _bytesLoaded;
		}
		
		public function set bytesTotal(value:int):void
		{
			_bytesTotal = value;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _bytesLoaded, _bytesTotal));
		}
		
		override public function get bytesTotal():int
		{
			return _bytesTotal;
		}
		
		private var _bytesLoaded:uint;
		private var _bytesTotal:int;
	}
}