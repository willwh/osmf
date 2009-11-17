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
	
	import org.osmf.events.LoadEvent;
	import org.osmf.utils.MediaFrameworkStrings;

	/**
	 * Dispatched when total size in bytes of data being downloaded has changed.
	 * 
	 * @eventType org.osmf.events.LoadEvent
	 */	
	[Event(name="bytesTotalChange",type="org.osmf.events.LoadEvent")]

	/**
	 * The DownloadableTrait class provides a base IDownloadable implementation. 
	 * It can be used as the base class for a more specific data downloadable trait	
	 * subclass or as is by a video or audio element.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	public class DownloadableTrait extends EventDispatcher implements IDownloadable
	{
		/**
		 * Constructor
		 * 
		 * @param bytesLoaded the number of bytes that have been downloaded
		 * @param bytesTotal the total number of bytes to be downloaded
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
				processBytesTotalChange(value);
				_bytesTotal = value;
				postProcessBytesTotalChange( value);
			}
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function processBytesLoadedChange(newValue:Number):void
		{
		}

		/**
		 * Called immediately before the <code>bytesTotal</code> property is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 *  
		 * @param newValue New <code>bytesTotal</code> value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function processBytesTotalChange(newValue:Number):void
		{
		}

		/**
		 * Called just after the <code>bytesLoaded</code> property has changed.
		 *  
		 * @param oldValue Previous <code>bytesLoaded</code> value.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessBytesLoadedChange(oldValue:Number):void
		{
		}

		/**
		 * Called just after the <code>bytesTotal</code> property has changed.
		 * Dispatches the bytesTotalChange event.
		 * <p>Subclasses that override should call this method to
		 * dispatch the bytesTotalChange event.</p>
		 *  
		 * @param newValue New <code>bytesTotal</code> value.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessBytesTotalChange(newValue:Number):void
		{
			dispatchEvent(new LoadEvent(LoadEvent.BYTES_TOTAL_CHANGE, false, false, null, newValue));
		}

		private var _bytesLoaded:Number;
		private var _bytesTotal:Number;		
	}
}