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
package org.openvideoplayer.display
{
	import flash.geom.Point;
	
	/**
	 * The ScaleMode enumeration describes different ways of laying out a single piece of content within a container.
	 * There are four modes available, NONE, STRETCH, LETTERBOX and CROP, which are used by the ScalableSprite. 
	 */ 
	public class ScaleMode
	{				
		/**
		 * NONE implies that the media's size is not changed from its original size, regardless of the
		 * container size.
		 **/
		public static const NONE:ScaleMode 		= new ScaleMode("NONE"); 
		
		/**
		 * The STRETCH mode will set the width and the height of a piece of content to the same as it's
		 * conatiners width and height, possibly changing the contents aspect ratio.
		 */ 
		public static const STRETCH:ScaleMode	= new ScaleMode("STRETCH");
		
		/**
		 * The LETTERBOX mode will stretch the content as much as possible which still maintaining aspect ratio.  The content 
		 * will be stretched to a maximum of the containers bounds, with spacing to maintain aspect raiot if neccesary.
		 */ 
		public static const LETTERBOX:ScaleMode = new ScaleMode("LETTERBOX"); 
		
		/**
		 * The CROP mode is simliar to the Letterbox mode, except the CROP mode will stretch the content past the bounds of
		 * the conainer, in order to remove the spacing required to maintain aspect ratio.  This has the effect of using the entire bounds
		 * of the container, but also possible cropping some content.
		 */
		public static const CROP:ScaleMode		= new ScaleMode("CROP");
		
		public function ScaleMode(token:String)
		{
			this.token = token;
		}
		
		public function toString():String
		{
			return token;
		}
		
		/**
		 * Calculates the scaled size based on this scaling algorithm.  The available width and height are the width and height of the container, whilst the instrict width and height are for contents of the container.  
		 */ 
		public function getScaledSize
			( availableWidth:Number, availableHeight:Number
			, instrinsicWidth:Number, instrinsicHeight:Number
			):Point
		{
			var result:Point;
			
			switch (this)
			{
				case ScaleMode.CROP:
				case ScaleMode.LETTERBOX:
					
					var availableRatio:Number
						= availableWidth
						/ availableHeight;
						
					var componentRatio:Number 
						= (instrinsicWidth || availableWidth)
						/ (instrinsicHeight || availableHeight);
					
					if 	(	(this == ScaleMode.CROP && componentRatio < availableRatio) 
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
							( instrinsicWidth	|| availableWidth
							, instrinsicHeight	|| availableHeight
							);
					
					break;
			}
			
			return result;
		}
		
		private var token:String;

	}
}