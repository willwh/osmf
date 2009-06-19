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
package org.openvideoplayer.events
{
	import flash.events.Event;
	
	/**
	 * A trait that implements the ISpatial interface dispatches
	 * this event when its <code>width</code> and/or <code> height</code> 
	 * properties have changed.
	 */	
	public class DimensionChangeEvent extends TraitEvent
	{
		/**
		 * The DimensionChangeEvent.DIMENSION_CHANGE constant defines the value
		 * of the type property of the event object for a dimensionChange
		 * event.
		 * 
		 * @eventType DIMENSION_CHANGE
		 **/
		public static const DIMENSION_CHANGE:String = "dimensionChange";

		/**
		 * Constructor.
		 * 
		 * @param oldWidth Previous width.
		 * @param oldHeight Previous height.
		 * @param newWidth New width.
		 * @param newHeight New height.
 		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 **/		
		public function DimensionChangeEvent
							( oldWidth:int, oldHeight:int
							, newWidth:int, newHeight:int
							, bubbles:Boolean=false
							, cancelable:Boolean=false
							)
		{
			_oldWidth = oldWidth;
			_oldHeight = oldHeight;
			_newWidth = newWidth;
			_newHeight = newHeight;
			
			super(DIMENSION_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * Old value of <code>width</code> before it was changed.
		 */		
		public function get oldWidth():int
		{
			return _oldWidth;
		}
		
		/**
		 * Old value of <code>height</code> before it was changed.
		 */
		public function get oldHeight():int
		{
			return _oldHeight;
		}
		
		/**
		 * New value of <code>width</code> resulting from this change.
		 */
		public function get newWidth():int
		{
			return _newWidth;
		}
		
		/**
		 * New value of <code>height</code> resulting from this change.
		 */
		public function get newHeight():int
		{
			return _newHeight;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new DimensionChangeEvent
				( _oldWidth, _oldHeight
				, _newWidth, _newHeight
				, bubbles, cancelable
				);
		}
		
		// Internals
		//
		
		private var _oldWidth:int;
		private var _oldHeight:int;
		private var _newWidth:int;
		private var _newHeight:int;
	}
}