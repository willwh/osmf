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
*  Contributor(s): Adobe Systems Inc.
* 
*****************************************************/
package org.openvideoplayer.vast.model
{
	public class VASTAdPackageBase
	{
		public function VASTAdPackageBase()
		{
			super();
		}

		/**
		 * Indicates source ad server.
		 */
		public function get adSystem():String 
		{
			return _adSystem;
		}
		
		public function set adSystem(value:String):void 
		{
			_adSystem = value;
		}
		
		/**
		 * An optional error URL so the various ad servers can be informed
		 * if the ad did not play for any reason.
		 */
		public function get errorURL():String 
		{
			return _errorURL;
		}
		
		public function set errorURL(value:String):void 
		{
			_errorURL = value;
		}
		
		private var _adSystem:String;
		private var _adSystemVersion:String;
		private var _errorURL:String;
	}
}