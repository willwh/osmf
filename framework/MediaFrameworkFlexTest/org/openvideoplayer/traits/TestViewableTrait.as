/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.traits
{
	import org.openvideoplayer.events.ViewChangeEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class TestViewableTrait extends TestIViewable
	{
		override protected function createInterfaceObject(... args):Object
		{
			return new ViewableTrait();
		}
		
		public function testViewAssignment():void
		{
			viewable.addEventListener(ViewChangeEvent.VIEW_CHANGE,eventCatcher);

			assertNull(viewable.view);
			
			var displayObject1:DisplayObject = new Sprite();
			var displayObject2:DisplayObject = new Sprite();			
			
			viewableTraitBase.view = displayObject1;
			assertTrue(viewable.view == displayObject1);
			
			viewableTraitBase.view = displayObject2;
			assertTrue(viewable.view == displayObject2);
			
			// Should not cause a change event:
			viewableTraitBase.view = displayObject2;
			
			var vce:ViewChangeEvent;
			
			assertTrue(events.length == 2);
			
			vce = events[0] as ViewChangeEvent;
			assertNotNull(vce);
			assertTrue(vce.oldView == null);
			assertTrue(vce.newView == displayObject1);
			
			vce = events[1] as ViewChangeEvent;
			assertNotNull(vce);
			assertTrue(vce.oldView == displayObject1);
			assertTrue(vce.newView == displayObject2);
		}
		
		// Utils
		//
		
		protected function get viewableTraitBase():ViewableTrait
		{
			return viewable as ViewableTrait;
		}
		
	}
}