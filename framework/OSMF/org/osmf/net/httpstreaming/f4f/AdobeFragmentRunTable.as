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
package org.osmf.net.httpstreaming.f4f
{
	import __AS3__.vec.Vector;
	
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * Fragment run table. Each entry in the table is the first fragment of a sequence of 
	 * fragments that have the same duration.
	 */
	internal class AdobeFragmentRunTable extends FullBox
	{
		/**
		 * Constructor
		 * 
		 * @param bi The box info that contains the size and type of the box
		 * @param parser The box parser to be used to assist constructing the box
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function AdobeFragmentRunTable()
		{
			super();
			
			_fragmentDurationPairs = new Vector.<FragmentDurationPair>();
		}
		
		/**
		 * The time scale for this run table.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get timeScale():uint
		{
			return _timeScale;
		}
		
		public function set timeScale(value:uint):void
		{
			_timeScale = value;
		}

		/**
		 * The quality segment URL modifiers.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get qualitySegmentURLModifiers():Vector.<String>
		{
			return _qualitySegmentURLModifiers;
		}

		public function set qualitySegmentURLModifiers(value:Vector.<String>):void
		{
			_qualitySegmentURLModifiers = value;
		}

		/**
		 * A list of <first fragment, duration> pairs.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get fragmentDurationPairs():Vector.<FragmentDurationPair>
		{
			return _fragmentDurationPairs;
		}
		
		/**
		 * Append a fragment duration pair to the list. The accrued duration for the newly appended
		 * fragment duration needed to be calculated. This is basically the total duration till the
		 * time spot that the newly appended fragment duration pair represents.
		 * 
		 * @param fdp The <first fragment, duration> pair to be appended to the list.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function addFragmentDurationPair(fdp:FragmentDurationPair):void
		{
			_fragmentDurationPairs.push(fdp);
		}
		
		/**
		 * The total duration of the movie in terms of the time scale used. It is basically
		 * the duration accrued until the last fragment duration pair plus the duration for the
		 * last fragment duration pair.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get totalDuration():uint
		{
			var lastFdp:FragmentDurationPair 
				= _fragmentDurationPairs.length <= 0 ? null : _fragmentDurationPairs[_fragmentDurationPairs.length - 1];
				
			return (lastFdp != null) ? lastFdp.durationAccrued + lastFdp.duration : 0;
		}
		
		/**
		 * The total number of fragments contained in this fragment run table.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get totalFragments():uint
		{
			var lastFdp:FragmentDurationPair 
				= _fragmentDurationPairs.length <= 0 ? null : _fragmentDurationPairs[_fragmentDurationPairs.length - 1];
			return lastFdp.firstFragment; 
		}

		/**
		 * Given a time spot in terms of the time scale used by the fragment table, returns the corresponding
		 * Id of the fragment that contains the time spot.
		 * 
		 * @return the Id of the fragment that contains the time spot.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function findFragmentIdByTime(time:Number, totalDuration:Number):FragmentAccessInformation
		{
			if (_fragmentDurationPairs.length <= 0)
			{
				return null;
			}
			
			var fdp:FragmentDurationPair = null;
			
			for (var i:uint = 1; i < _fragmentDurationPairs.length; i++)
			{
				fdp = _fragmentDurationPairs[i];
				if (fdp.durationAccrued >= time)
				{
					return validateFragment(calculateFragmentId(_fragmentDurationPairs[i - 1], time), totalDuration);
				}
			}
			
			return validateFragment(calculateFragmentId(_fragmentDurationPairs[_fragmentDurationPairs.length - 1], time), totalDuration);
		}
		
		/**
		 * Given a fragment id, check whether the current fragment is valid or a discontinuity.
		 * If the latter, skip to the nearest fragment and return the new fragment id.
		 * 
		 * @return the Id of the fragment that is valid.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function validateFragment(fragId:uint, totalDuration:Number):FragmentAccessInformation
		{
			var size:uint = _fragmentDurationPairs.length - 1;
			var fai:FragmentAccessInformation = new FragmentAccessInformation();

			for (var i:uint = 0; i < size; i++)
			{
				var curFdp:FragmentDurationPair = _fragmentDurationPairs[i];
				var nextFdp:FragmentDurationPair = _fragmentDurationPairs[i+1];
				
				if (curFdp.firstFragment <= fragId &&
					((fragId < nextFdp.firstFragment) || (curFdp.firstFragment >= nextFdp.firstFragment)))
				{
					if ((curFdp.durationAccrued + (fragId - curFdp.firstFragment + 1) * curFdp.duration) >= totalDuration)
					{
						return null;
					}
					
					if (curFdp.duration > 0)
					{
						fai.fragId = fragId;
						fai.fragDuration = curFdp.duration;
						fai.fragmentEndTime = curFdp.durationAccrued + curFdp.duration * (fragId - curFdp.firstFragment + 1);
						return fai;
					}
					
					curFdp = findValidFragmentDurationPair(i + 1);
					if (curFdp == null)
					{
						return null;
					}
					
					fai.fragId = curFdp.firstFragment;
					fai.fragmentEndTime = curFdp.durationAccrued + curFdp.duration;
					fai.fragDuration = curFdp.duration;
					
					return fai;
				}
			}
			
			CONFIG::LOGGING
			{
				logger.debug("total duration: " + totalDuration);
				logger.debug("fragment timestamp: " + _fragmentDurationPairs[size].durationAccrued);
				logger.debug("fragId: " + fragId);
				logger.debug("firstFragment: " + _fragmentDurationPairs[size].firstFragment);
				
				logger.debug("time residue: " + 
					(totalDuration - 
					_fragmentDurationPairs[size].durationAccrued - 
					(fragId - _fragmentDurationPairs[size].firstFragment + 1) * _fragmentDurationPairs[size].duration));
					
				logger.debug("fragment duration: " + _fragmentDurationPairs[size].duration);
			}
			
			if (fragId >= _fragmentDurationPairs[size].firstFragment && 
				((totalDuration - _fragmentDurationPairs[size].durationAccrued - (fragId - _fragmentDurationPairs[size].firstFragment + 1) * _fragmentDurationPairs[size].duration) > _fragmentDurationPairs[size].duration) && 
				_fragmentDurationPairs[size].duration > 0)
			{
				fai.fragId = fragId;
				fai.fragDuration = 
				fai.fragmentEndTime = _fragmentDurationPairs[size].duration;
					_fragmentDurationPairs[size].durationAccrued + 
					_fragmentDurationPairs[size].duration * (fragId - _fragmentDurationPairs[size].firstFragment + 1);
			}
			else
			{
				fai = null;
			}
			
			return fai;
		}
		
		/**
		 * Given a fragment id, return the number of fragments after the 
		 * fragment with the id given.
		 * 
		 * @return the number of fragments after the fragment with the id given.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function fragmentsLeft(fragId:uint, currentMediaTime:Number):uint
		{
			if (_fragmentDurationPairs == null)
			{
				return 0;
			}
			
			var fdp:FragmentDurationPair = _fragmentDurationPairs[fragmentDurationPairs.length - 1] as FragmentDurationPair;
			var fragments:uint = (currentMediaTime - fdp.durationAccrued) / fdp.duration + fdp.firstFragment - fragId;
			
			return fragments;
		}		
		
		/**
		 * @return whether the fragment table is complete.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function tableComplete():Boolean
		{
			if (_fragmentDurationPairs == null)
			{
				return false;
			}
			
			var fdp:FragmentDurationPair = _fragmentDurationPairs[fragmentDurationPairs.length - 1] as FragmentDurationPair;
			return (fdp.duration == 0 && fdp.discontinuityIndicator == 0);
		}
		
		public function adjustEndEntryDurationAccrued(value:Number):void
		{
			var fdp:FragmentDurationPair = _fragmentDurationPairs[_fragmentDurationPairs.length - 1];
			if (fdp.duration == 0 && fdp.discontinuityIndicator == 0)
			{
				fdp.durationAccrued = value;
			}
		}
		
		// Internal
		//
		
		private function findValidFragmentDurationPair(index:uint):FragmentDurationPair
		{
			for (var i:uint = index; index < _fragmentDurationPairs.length; i++)
			{
				var fdp:FragmentDurationPair = _fragmentDurationPairs[i];
				if (fdp.duration > 0)
				{
					return fdp;
				}
			}
			
			return null;
		}
		
		private function calculateFragmentId(fdp:FragmentDurationPair, time:Number):uint
		{
			if (fdp.duration <= 0)
			{
				return fdp.firstFragment;
			}
			
			return fdp.firstFragment + ((uint)(time - fdp.durationAccrued)) / fdp.duration;
		}

		private var _timeScale:uint;
		private var _qualitySegmentURLModifiers:Vector.<String>;
		private var _fragmentDurationPairs:Vector.<FragmentDurationPair>;

		CONFIG::LOGGING
		{
			private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("org.osmf.net.httpstreaming.f4f.AdobeFragmentRunTable");
		}
	}
}
