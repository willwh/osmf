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
	/**
	 * This class represents a Wrapper Ad which is another 
	 * VAST document that points to another VAST document from
	 * a different server.
	 */
	public class VASTWrapperAd extends VASTAdPackageBase
	{
		public function VASTWrapperAd()
		{
			super();
		}

		/**
		 * The ad tag URL.
		 */
		public function get vastAdTagURL():String 
		{
			return _vastAdTagURL;
		}
		
		public function set vastAdTagURL(value:String):void 
		{
			 _vastAdTagURL = value;
		}
		
		private var _vastAdTagURL:String;
	}
}
