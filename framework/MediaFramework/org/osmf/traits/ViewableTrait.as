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
	import flash.display.DisplayObject;
	
	import org.osmf.events.ViewChangeEvent;

	/**
	 * Dispatched when the trait's <code>view</code> property has changed.
	 * This occurs when a different DisplayObject is assigned to represent the media.
	 * 
	 * @eventType org.osmf.events.ViewChangeEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.osmf.events.ViewChangeEvent")]

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