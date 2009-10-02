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
package org.osmf.vast.loader
{
	import org.osmf.traits.ILoadedContext;
	import org.osmf.vast.model.VASTDocument;
	
	/**
	 * The VASTLoadedContext class contains information about the output of a load operation
	 * performed by a VASTLoader, specifically, the VASTDocument object which is the root
	 * level object in the object model representation of a VAST document. 
	 * 
	 * @see http://www.iab.net/vast
 	 * @see VASTLoader
	 **/
	public class VASTLoadedContext implements ILoadedContext
	{
		/**
		 * Constructor.
		 * 
		 * @param vastDocument The root level object of the VAST document object model.
		 */
		public function VASTLoadedContext(vastDocument:VASTDocument)
		{
			_vastDocument = vastDocument;
		}
		
		/**
		 * The root level object in the VAST document object model.
		 */
		public function get vastDocument():VASTDocument
		{
			return _vastDocument;
		}
		
		private var _vastDocument:VASTDocument;
	}
}
