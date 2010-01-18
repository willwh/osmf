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
package org.osmf.net.httpstreaming.f4f
{
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * Full box extends box to have its own extended properties.
	 */
	internal class FullBox extends Box
	{
		/**
		 * Constructor
		 */
		public function FullBox()
		{
			super();
		}
		
		/**
		 * Specifies the version of this format of the box.
		 */
		public function get version():uint
		{
			return _version;
		}

		public function set version(value:uint):void
		{
			_version = value;
		}
		
		/**
		 * A map of flags
		 */
		public function get flags():uint
		{
			return _flags;
		}

		public function set flags(value:uint):void
		{
			_flags = value;
		}
		
		// Internal
		//
		
		private var _version:uint;
		private var _flags:uint;
	}
}