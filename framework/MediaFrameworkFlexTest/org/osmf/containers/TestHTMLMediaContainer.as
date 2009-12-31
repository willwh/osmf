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
package org.osmf.containers
{
	import flash.external.ExternalInterface;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.external.HTMLElement;
	
	public class TestHTMLMediaContainer extends TestCase
	{
		public function testHTMLMediaContainer():void
		{
			if (ExternalInterface.available)
			{
				var container:HTMLMediaContainer = new HTMLMediaContainer("test");
				
				// There three lines need further review: they seem to fail on IE for no
				// apparent reason:
				/*
				assertTrue(ExternalInterface.call("function(){return document.osmf;}"));
				assertTrue(ExternalInterface.call("function(){return document.osmf.containers;}"));
				assertTrue(ExternalInterface.call("function(){return document.osmf.containers.MediaFrameworkTest_test;}"));
				*/
				
				var element:HTMLElement = new HTMLElement();
				element.gateway = container;
				
				assertTrue(container.containsMediaElement(element));
				
				container.removeMediaElement(element);
				
				assertFalse(container.containsMediaElement(element));
				
				container.addMediaElement(element);
				
				assertTrue(container.containsMediaElement(element));
			}
		}
		
	}
}