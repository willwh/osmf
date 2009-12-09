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
	import flash.display.Sprite;
	
	import org.osmf.events.ViewEvent;

	public class TestSeekTraitAsSubclass extends TestSeekTrait
	{
		override protected function createInterfaceObject(... args):Object
		{
			return new DynamicSeekTrait(args.length > 0 ? args[0] : null);
		}
		
		override protected function get processesSeekCompletion():Boolean
		{
			// Some implementations of ISeekable will signal completion 
			// of a seek, although the default implementation doesn't.
			// Subclasses can override this to indicate that they process
			// completion.
			return true;
		}
	}
}

import flash.display.DisplayObject;

import org.osmf.events.SeekEvent;
import org.osmf.traits.SeekTrait;
import org.osmf.traits.TimeTrait;
import flash.utils.Timer;
import flash.events.TimerEvent;

class DynamicSeekTrait extends SeekTrait
{
	public function DynamicSeekTrait(timeTrait:TimeTrait)
	{
		super(timeTrait);
		
		addEventListener(SeekEvent.SEEK_BEGIN, onSeekBegin);
	}
	
	private function onSeekBegin(event:SeekEvent):void
	{
		seekTargetTime = event.time;
		
		// Complete the seek shortly after it begins.
		var timer:Timer = new Timer(500, 1);
		timer.addEventListener(TimerEvent.TIMER, onTimer);
		timer.start();
		
		function onTimer(timerEvent:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			
			processSeekCompletion(seekTargetTime);
		}
	}

	private var seekTargetTime:Number;
}