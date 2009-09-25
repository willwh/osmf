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
package org.openvideoplayer.mast.loader
{
	import flash.events.Event;
	
	import org.openvideoplayer.mast.model.MASTCondition;
	import org.openvideoplayer.media.MediaElement;
	
	public class MASTDocumentProcessedEvent extends Event
	{
		public static const PROCESSED:String = "processed";
		
		public function MASTDocumentProcessedEvent(inlineElements:Vector.<MediaElement>, condition:MASTCondition, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(PROCESSED, bubbles, cancelable);
			
			_inlineElements = inlineElements;
			_condition = condition;
		}
		
		public function get inlineElements():Vector.<MediaElement>
		{
			return _inlineElements;
		}
		
		public function get condition():MASTCondition
		{
			return _condition;
		}

		override public function clone():Event
		{
			return new MASTDocumentProcessedEvent(_inlineElements, _condition, bubbles, cancelable);
		}
		
		private var _inlineElements:Vector.<MediaElement>;
		private var _condition:MASTCondition;
	}
}