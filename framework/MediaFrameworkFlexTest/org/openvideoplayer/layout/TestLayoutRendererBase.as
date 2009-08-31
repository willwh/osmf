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
package org.openvideoplayer.layout
{
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.utils.MediaFrameworkStrings;

	public class TestLayoutRendererBase extends TestCase
	{
		public function testBaseLayoutRenderer():void
		{
			// Since the base-class holds a number of functions
			// that must be overriden, we can't test it stand-
			// alone (we cover a lot with TestDefaultLayout, though):
			var renderer:LayoutRendererBase = new LayoutRendererBase();
			assertNotNull(renderer);
		}
		
	}
}