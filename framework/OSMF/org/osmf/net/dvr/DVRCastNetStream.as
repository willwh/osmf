/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.net.dvr
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamPlayOptions;
	
	import org.osmf.media.URLResource;

	[ExcludeClass]
	
	/**
	 * @private
	 */
	internal class DVRCastNetStream extends NetStream
	{
		public function DVRCastNetStream(connection:NetConnection, resource:URLResource)
		{
			super(connection);
		}
		
		public function set disabled(value:Boolean):void
		{
			if (_disabled != value)
			{
				_disabled = value;
				if (_disabled == true)
				{
					// Close the stream:
					close();
				}	
			}
		}
		
		// Overrides
		//
		
		override public function play(...arguments):void
		{
			if (_disabled != true)
			{
				super.play.apply(this, arguments);
			}
		}
		
		override public function play2(param:NetStreamPlayOptions):void
		{
			if (_disabled != true)
			{
				super.play2(param);
			}
		}
		
		// Internals
		//
		
		private var _disabled:Boolean = false;
	}
}