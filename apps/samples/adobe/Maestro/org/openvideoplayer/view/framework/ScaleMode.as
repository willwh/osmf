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
package org.openvideoplayer.view.framework
{
	import flash.geom.Point;

	public class ScaleMode
	{
		public static const NONE:ScaleMode 		= new ScaleMode("NONE"); 
		public static const STRETCH:ScaleMode	= new ScaleMode("STRETCH");
		public static const LETTERBOX:ScaleMode = new ScaleMode("LETTERBOX"); 
		public static const CROP:ScaleMode		= new ScaleMode("CROP");
		
		public function ScaleMode(token:String)
		{
			this.token = token;
		}
		
		public function toString():String
		{
			return token;
		}
		
		public function getScaledSize
			( availableWidth:Number,
			  availableHeight:Number,
			  contentWidth:Number,
			  contentHeight:Number
			):Point
		{
			var result:Point;
			
			switch (this)
			{
				case ScaleMode.CROP:
				case ScaleMode.LETTERBOX:
					
					var rA:Number
						= availableWidth
						/ availableHeight;
						
					var rC:Number 
						= (contentWidth || availableWidth)
						/ (contentHeight || availableHeight);
					
					if 	(	(this == ScaleMode.CROP && rC < rA) 
						||	(this == ScaleMode.LETTERBOX && rC > rA)
						)
					{
						result 
							= new Point
								( availableWidth
								, availableWidth / rC
								);
					}
					else
					{
						result
							= new Point
								( availableHeight * rC
								, availableHeight
								);
					}

					break;
					
				case ScaleMode.STRETCH:
					
					result 
						= new Point
							( availableWidth
							, availableHeight
							);
					break;
					
				case ScaleMode.NONE:
					
					result
						= new Point
							( contentWidth	|| availableWidth
							, contentHeight	|| availableHeight
							);
					
					break;
			}
			
			return result;
		}
		
		private var token:String;
	}
}