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
	import flash.events.EventDispatcher;
	
	import org.osmf.events.BytesTotalChangeEvent;
	import org.osmf.utils.MediaFrameworkStrings;

	/**
	 * Dispatched when total size in bytes of data being downloaded into the application has changed.
	 * 
	 * @eventType org.osmf.events.BytesTotalChangeEvent
	 */	
	[Event(name="bytesTotalChange",type="org.osmf.events.BytesTotalChangeEvent")]

	/**
	 * The DownloadableTrait class provides a base IDownloadable implementation. 
	 * It can be used as the base class for a more specific data downloadable trait	
	 * subclass or as is by a video or audio element.
	 */	
	public class DownloadableTrait extends EventDispatcher implements IDownloadable
	{
		/**
		 * Constructor
		 * 
		 * @param bytesLoaded the number of bytes that have been downloaded
		 * @param bytesTotal the total number of bytes to be downloaded
		 */
		public function DownloadableTrait(bytesLoaded:Number=NaN, bytesTotal:Number=NaN)
		{
			super();
			
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
		}
		
		/**
		 * Invoking this setter will result in the trait's bytesLoaded
		 * value changing if it differs from bytesLoaded current value.
		 * 
		 * @throws ArgumentError - if value is negative or larger than bytesTotal
		 * 
		 * @see canProcessBytesLoadedChange
		 * @see processBytesLoadedChange
		 * @see postProcessBytesLloadedChange
		 */		
		final public function set bytesLoaded(value:Number):void
		{
			if (value > bytesTotal || value < 0)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			if (canProcessBytesLoadedChange(value))
			{
				var oldBytesLoaded:Number = _bytesLoaded;
				processBytesLoadedChange(value);
				_bytesLoaded = value;
				postProcessBytesLoadedChange(oldBytesLoaded);
			}
		}
		
		/**
		 * Invoking this setter will result in the trait's bytesTotal
		 * value changing if it differs from bytesTotal current value.
		 * 
		 * @throws ArgumentError - if value is negative or smaller than bytesLoaded
		 * 
		 * @see canProcessBytesTotalChange
		 * @see processBytesTotalChange
		 * @see postProcessBytesTotalChange
		 */		
		final public function set bytesTotal(value:Number):void
		{
			if (value == _bytesTotal)
			{
				return;
			}
			
			if (value < _bytesLoaded || value < 0)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}

			if (canProcessBytesTotalChange(value))
			{
				var oldBytesTotal:Number = _bytesTotal;
				processBytesTotalChange(value);
				_bytesTotal = value;
				postProcessBytesTotalChange(oldBytesTotal, value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
		//
		// Internals
		//
		
		/**
		 * Called before the <code>bytesLoaded</code> property is changed.
		 *  
		 * @param newValue Proposed new <code>bytesLoaded</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override 
		 * this method can return <code>false</code> to abort processing.
		 */		
		protected function canProcessBytesLoadedChange(newValue:Number):Boolean
		{
			return true;
		}

		/**
		 * Called before the <code>bytesTotal</code> property is changed.
		 *  
		 * @param newValue Proposed new <code>bytesTotal</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override 
		 * this method can return <code>false</code> to abort processing.
		 */		
		protected function canProcessBytesTotalChange(newValue:Number):Boolean
		{
			return true;
		}
		
		/**
		 * Called immediately before the <code>bytesLoaded</code> property is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 *  
		 * @param newValue New <code>bytesLoaded</code> value.
		 */		
		protected function processBytesLoadedChange(newValue:Number):void
		{
		}

		/**
		 * Called immediately before the <code>bytesTotal</code> property is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 *  
		 * @param newValue New <code>bytesTotal</code> value.
		 */		
		protected function processBytesTotalChange(newValue:Number):void
		{
		}

		/**
		 * Called just after the <code>bytesLoaded</code> property has changed.
		 *  
		 * @param oldValue Previous <code>bytesLoaded</code> value.
		 * 
		 */		
		protected function postProcessBytesLoadedChange(oldValue:Number):void
		{
		}

		/**
		 * Called just after the <code>bytesTotal</code> property has changed.
		 * Dispatches the BytesTotalChangeEvent event.
		 * <p>Subclasses that override should call this method to
		 * dispatch the BytesTotalChangeEvent event.</p>
		 *  
		 * @param oldValue Previous <code>bytesTotal</code> value.
		 * 
		 */		
		protected function postProcessBytesTotalChange(oldValue:Number, newValue:Number):void
		{
			dispatchEvent(new BytesTotalChangeEvent(oldValue, newValue));
		}

		private var _bytesLoaded:Number;
		private var _bytesTotal:Number;		
	}
}