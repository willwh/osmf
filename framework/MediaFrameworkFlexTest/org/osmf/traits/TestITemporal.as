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
package org.osmf.traits
{
	import __AS3__.vec.Vector;
	
	import org.osmf.utils.InterfaceTestCase;
	
	import flash.events.Event;

	// Including this class pro forma, however there is nothing that
	// can be tested on the interface alone, for it solely consists of 
	// read-only properties.
	
	public class TestITemporal extends InterfaceTestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			events = new Vector.<Event>;
			temporal = createInterfaceObject() as ITemporal;
		}
		
		// Utils
		//
		
		protected var temporal:ITemporal;
		protected var events:Vector.<Event>;
		
		protected function eventCatcher(event:Event):void
		{
			events.push(event);
		}
	}
}