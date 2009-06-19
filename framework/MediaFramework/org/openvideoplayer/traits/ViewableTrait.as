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
package org.openvideoplayer.traits
{
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.traits.IViewable;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;

	/**
	 * Dispatched when the trait's <code>view</code> property has changed.
	 * This occurs when a different DisplayObject is assigned to represent the media.
	 * 
	 * @eventType org.openvideoplayer.events.ViewChangeEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.openvideoplayer.events.ViewChangeEvent")]

	/**
	 * The ViewableTrait class provides a base IViewable implementation. 
	 * It can be used as the base class for a more specific viewable trait	
	 * subclass or as is by a media element that listens for and handles
	 * its change events.
	 * 
	 */
	public class ViewableTrait extends MediaTraitBase implements IViewable
	{		
		// Public interface
		//
		
		/**
		 * Defines the trait's view. If the view is different from the one
		 * that is currently set, a ViewChangeEvent will be dispatched.
		 * 
		 * @see canProcessViewChange
		 * @see processViewChange
		 * @see postProcessViewChange
		 */		
		final public function set view(value:DisplayObject):void
		{
			if (_view != value && canProcessViewChange(value))
			{
				processViewChange(value);
				
				var oldView:DisplayObject = _view;
				_view = value;
				
				postProcessViewChange(oldView);
			}
		}
		
		// IViewable
		//
		
		/**
		 * @inheritDoc
		 */
		public function get view():DisplayObject
		{
			return _view;
		}
		
		// Internals
		//
		
		private var _view:DisplayObject;
	
		/**
		 * Called before the <code>view</code> property is changed. 
		 *
		 * @param newView Proposed new <code>view</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override 
		 * this method can return <code>false</code> to abort processing.
		 */		
		protected function canProcessViewChange(newView:DisplayObject):Boolean
		{
			return true;
		}
		
		/**
		 * Called immediately before the <code>view</code> property is changed. 
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 * @param newView New <code>view</code> value.
		 */		
		protected function processViewChange(newView:DisplayObject):void
		{
		}
		
		/**
		 * Called just after the <code>view</code> property has changed.
		 * Dispatches the change event.
		 * <p>Subclasses that override should call this method to
		 * dispatch the viewChange event.</p>
		 *  
		 * @param oldView Previous <code>view</code> value.
		 * 
		 */		
		protected function postProcessViewChange(oldView:DisplayObject):void
		{
			dispatchEvent(new ViewChangeEvent(oldView,_view));
		}
	}
}