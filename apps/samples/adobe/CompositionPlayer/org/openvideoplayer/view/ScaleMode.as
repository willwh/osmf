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
package org.openvideoplayer.view
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