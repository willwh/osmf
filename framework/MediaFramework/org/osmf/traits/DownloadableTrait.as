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
	 * 
	 */	
	public class DownloadableTrait extends EventDispatcher implements IDownloadable
	{
		/**
		 * Constructor
		 * 
		 * @param bytesDownloaded the number of bytes that has been downloaded
		 * @param bytesTotal the total number of bytes to be downloaded
		 */
		public function DownloadableTrait(bytesDownloaded:Number=NaN, bytesTotal:Number=NaN)
		{
			super();
			
			_bytesDownloaded = bytesDownloaded;
			_bytesTotal = bytesTotal;
		}
		
		/**
		 * Invoking this setter will result in the trait's bytesDownloaded
		 * value changing if it differs from bytesDownloaded current value.
		 * 
		 * @throws ArgumentError - if value is negative or larger than bytesTotal
		 * 
		 * @see canProcessBytesDownloadedChange
		 * @see processBytesDownloadedChange
		 * @see postProcessBytesDownloadedChange
		 */		
		final public function set bytesDownloaded(value:Number):void
		{
			if (value > bytesTotal || value < 0)
			{
				throw new ArgumentError(MediaFrameworkStrings.BYTES_DOWNLOADED);
			}
			
			if (canProcessBytesDownloadedChange(value))
			{
				var oldBytesDownloaded:Number = _bytesDownloaded;
				processBytesDownloadedChange(value);
				_bytesDownloaded = value;
				postProcessBytesDownloadedChange(oldBytesDownloaded);
			}
		}
		
		/**
		 * Invoking this setter will result in the trait's bytesTotal
		 * value changing if it differs from bytesTotal current value.
		 * 
		 * @throws ArgumentError - if value is negative or smaller than bytesDownloaded
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
			
			if (value < _bytesDownloaded || value < 0)
			{
				throw new ArgumentError(MediaFrameworkStrings.BYTES_TOTAL);
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
		public function get bytesDownloaded():Number
		{
			return _bytesDownloaded;
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
		 * Called before the <code>bytesDownloaded</code> property is changed.
		 *  
		 * @param newValue Proposed new <code>bytesDownloaded</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override 
		 * this method can return <code>false</code> to abort processing.
		 */		
		protected function canProcessBytesDownloadedChange(newValue:Number):Boolean
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
		 * Called immediately before the <code>bytesDownloaded</code> property is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 *  
		 * @param newValue New <code>bytesDownloaded</code> value.
		 */		
		protected function processBytesDownloadedChange(newValue:Number):void
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
		 * Called just after the <code>bytesDownloaded</code> property has changed.
		 *  
		 * @param oldValue Previous <code>bytesDownloaded</code> value.
		 * 
		 */		
		protected function postProcessBytesDownloadedChange(oldValue:Number):void
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

		private var _bytesDownloaded:Number;
		private var _bytesTotal:Number;		
	}
}