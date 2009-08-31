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
package com.adobe.strobe.plugins.smil.loader
{
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.ILoadedContext;
	
	/**
	 * This class represents the loaded context for the <code>SMILElement</code> object. This loaded context instance is created
	 * after the <code>SMILLoader</code> object has successfully loaded the smil element. The <code>mediaElement</code> property
	 * represents the underlying MediaElement that is created by the SMIL parser in the process of parsing the SMIL document.
	 * It corresponds to the root tag specified in the SMIL document.
	 */
	public class SMILLoadedContext implements ILoadedContext
	{
		/**
		 * Constructor
		 */
		public function SMILLoadedContext(value:MediaElement)
		{
			_mediaElement = value;
		}
		
		public function get mediaElement():MediaElement
		{
			return _mediaElement;
		}
		
		
		private var _mediaElement:MediaElement;
	}
}