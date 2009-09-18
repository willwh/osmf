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
	import __AS3__.vec.Vector;
	
	/**
	 * This class represents the top level object of the VAST document object
	 * model.
	 */
	public class VASTDocument
	{
		/**
		 * Constructor.
		 **/
		public function VASTDocument()
		{
			super();
			
			_ads = new Vector.<VASTAd>();
		}
		
		/**
		 * Adds the given VASTAd to the document.
		 */		
		public function addAd(ad:VASTAd):void
		{
			_ads.push(ad);
		}

		/**
		 * Gets the collection of VASTAds in the document.
		 */
		public function get ads():Vector.<VASTAd>
		{
			return _ads;
		}
			
		private var _ads:Vector.<VASTAd>;
	}
}
