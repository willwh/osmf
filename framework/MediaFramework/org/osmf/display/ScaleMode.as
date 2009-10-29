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
package org.osmf.display
{
	import flash.geom.Point;
	
	/**
	 * <code>ScaleMode</code> controls the layout of out a single piece of content within a container.
	 * There are four enumeration values, <code>NONE</code>, <code>STRETCH</code>, <code>LETTERBOX</code>, and <code>ZOOM</code>.
	 * <code>ScalableSprite</code> uses <code>ScaleMode</code> to calculate the layout.
	 */ 
	public class ScaleMode
	{				
		/**
		 * <code>NONE</code> implies that the media size is set to match its intrinsic size.
		 **/
		public static const NONE:ScaleMode 		= new ScaleMode("NONE"); 
		
		/**
		 * <code>STRETCH</code> sets the width and the height of the content to the
		 * container width and height, possibly changing the content aspect ratio.
		 */ 
		public static const STRETCH:ScaleMode	= new ScaleMode("STRETCH");
		
		/**
		 * <code>LETTERBOX</code> sets the width and height of the content as close to the container width and height
		 * as possible while maintaining aspect ratio.  The content is stretched to a maximum of the container bounds, 
		 * with spacing added inside the container to maintain the aspect ratio if necessary.
		 */ 
		public static const LETTERBOX:ScaleMode = new ScaleMode("LETTERBOX"); 
		
		/**
		 * <code>ZOOM</code> is similar to <code>LETTERBOX</code>, except that <code>ZOOM</code> stretches the
		 * content past the bounds of the container, to remove the spacing required to maintain aspect ratio.
		 * This has the effect of using the entire bounds of the container, but also possibly cropping some content.
		 */
		public static const ZOOM:ScaleMode		= new ScaleMode("ZOOM");
		
		public function ScaleMode(token:String)
		{
			this.token = token;
		}
		
		public function toString():String
		{
			return token;
		}
		
		/**
		 * Calculates the scaled size based on the scaling algorithm.  
		 * The available width and height are the width and height of the container.
		 * The intrinsic width and height are the width and height of the content.
		 */ 
		public function getScaledSize
			( availableWidth:Number, availableHeight:Number
			, intrinsicWidth:Number, intrinsicHeight:Number
			):Point
		{
			var result:Point;
			
			switch (this)
			{
				case ScaleMode.ZOOM:
				case ScaleMode.LETTERBOX:
					
					var availableRatio:Number
						= availableWidth
						/ availableHeight;
						
					var componentRatio:Number 
						= (intrinsicWidth || availableWidth)
						/ (intrinsicHeight || availableHeight);
					
					if 	(	(this == ScaleMode.ZOOM && componentRatio < availableRatio) 
						||	(this == ScaleMode.LETTERBOX && componentRatio > availableRatio)
						)
					{
						result 
							= new Point
								( availableWidth
								, availableWidth / componentRatio
								);
					}
					else
					{
						result
							= new Point
								( availableHeight * componentRatio
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
							( intrinsicWidth	|| availableWidth
							, intrinsicHeight	|| availableHeight
							);
					
					break;
			}
			
			return result;
		}
		
		private var token:String;
	}
}