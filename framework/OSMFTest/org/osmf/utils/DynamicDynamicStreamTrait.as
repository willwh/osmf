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
package org.osmf.utils
{
	import org.osmf.net.dynamicstreaming.SwitchingDetail;
	import org.osmf.traits.DynamicStreamTrait;
	
	public class DynamicDynamicStreamTrait extends DynamicStreamTrait
	{
		public function set currentIndex(value:int):void
		{
			setCurrentIndex(value);
		}
		
		public function get bitrates():Array
		{
			return _bitrates;
		}
	
		public function set bitrates(value:Array):void
		{
			_bitrates = value;
			setNumDynamicStreams(bitrates.length);
			maxAllowedIndex = bitrates.length - 1;
		}
		
		override public function getBitrateForIndex(index:int):Number
		{
			return _bitrates[index];
		}
		
		override protected function switchingChangeEnd(index:int, detail:SwitchingDetail=null):void
		{
			super.switchingChangeEnd(index, detail);
			
			if (switching)
			{
				setSwitching(false, index, detail);
			}
		}
		
		private var _bitrates:Array = [];
	}
}