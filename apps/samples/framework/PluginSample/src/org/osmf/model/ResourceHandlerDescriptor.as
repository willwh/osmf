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
package org.osmf.model
{
	import org.osmf.media.IMediaInfo;
	
	public class ResourceHandlerDescriptor
	{
		public function ResourceHandlerDescriptor(mediaInfo:IMediaInfo, priority:int = 10)
		{
			_mediaInfo = mediaInfo;
			_priority = priority;
		}
		
		public function get mediaInfo():IMediaInfo
		{
			return _mediaInfo;
		}
		
		public function get mediaInfoId():String
		{
			return _mediaInfo.id;
		}
		
		public function get priority():int
		{
			return _priority;
		}
		
		public function set priority(value:int):void
		{
			_priority = value;
		}
		
		private var _mediaInfo:IMediaInfo;
		private var _priority:int;
	}
}