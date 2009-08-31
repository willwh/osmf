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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.metadata.Metadata;

	public class TesterLayoutTargetSprite extends Sprite implements ILayoutTarget
	{
		// ILayoutTarget
		//
		
		public function get metadata():Metadata
		{
			return _metadata;
		}
		
		public function get intrinsicWidth():Number
		{
			return _intrinsicWidth;
		}
		
		public function get intrinsicHeight():Number
		{
			return _intrinsicHeight;
		}
		
		public function get view():DisplayObject
		{
			return this;
		}
		
		//  Public API
		//
		
		public function setIntrinsicDimensions(width:Number, height:Number):void
		{
			graphics.clear();
			
			graphics.beginFill(0xff0000);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
			
			dispatchEvent
				( new DimensionChangeEvent
					( _intrinsicWidth
					, _intrinsicHeight
					, _intrinsicWidth = width
					, _intrinsicHeight = height
					)
				);	
		}
		
		private var _metadata:Metadata = new Metadata();
		private var _intrinsicWidth:Number;
		private var _intrinsicHeight:Number;
		
	}
}