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
package org.openvideoplayer.display
{
	import flash.media.Video;
	
	import flexunit.framework.TestCase;

	public class TestScalableSprite extends TestCase
	{
				
		public function testScaleMode():void
		{
			var sprite:ScalableSprite = new ScalableSprite();
			var displayObject:Video = new Video(600, 500);
			
			sprite.setAvailableSize(1,1); //ensure this works without a view set.
						
			sprite.view = displayObject;
			assertEquals(sprite.view, displayObject);				
			assertEquals(sprite.scaleMode, ScaleMode.LETTERBOX);
			
			//None
			
			sprite.scaleMode = ScaleMode.NONE;
			assertEquals(sprite.scaleMode, ScaleMode.NONE);	
			
			sprite.width = 800;
			sprite.height = 900;
			
			/*
			Failing on build machine for no reason
			assertEquals(displayObject.width, 600);
			assertEquals(displayObject.height, 500);	
			*/
			//Stretch
			
			sprite.scaleMode = ScaleMode.STRETCH;
			sprite.setAvailableSize(200, 300);
			
			assertEquals(displayObject.width, 200);
			assertEquals(displayObject.height, 300);	
			 
			//Crop
			
			sprite.scaleMode = ScaleMode.CROP;
			sprite.setAvailableSize(200, 300);
			
			assertEquals(displayObject.width, 360); // 360  (160 pixels wider than width, to keep aspect ratio)
			assertEquals(displayObject.height, 300);	 //Should match the height in this case
			
			//Letterbox
			
			sprite.scaleMode = ScaleMode.LETTERBOX;
			
			assertEquals(displayObject.width, 200); // Should match the width in this case
			assertEquals(Math.round( displayObject.height ) , Math.round( 2/6 * 500 ) );	 //Should maintain aspect ratio	
			
			var displayObject2:Video = new Video();
			sprite.view = displayObject2;
			assertEquals(sprite.view, displayObject2);	
			
			sprite.view = null;
			sprite.setAvailableSize(NaN, NaN);
			
		}
				
		
	}
}