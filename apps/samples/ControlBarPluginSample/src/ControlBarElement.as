/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package
{
	import org.osmf.chrome.controlbar.ControlBarBase;
	import org.osmf.chrome.controlbar.ControlBarWidget;
	import org.osmf.chrome.controlbar.Direction;
	import org.osmf.chrome.controlbar.widgets.*;
	import org.osmf.layout.LayoutProperties;
	import org.osmf.media.IMediaReferrer;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.metadata.IMetadataProvider;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;

	public class ControlBarElement extends MediaElement implements IMediaReferrer
	{
		// IMediaReferrer
		//
		
		public function canReferenceMedia(target:MediaElement):Boolean
		{
			return getTargetFacet(target) != null;
		}
		
		public function addReference(target:MediaElement):void
		{
			var targetFacet:KeyValueFacet = getTargetFacet(target);
			if (targetFacet)
			{
				if 	(	targetFacet.getValue(ID) != null
					&&	targetFacet.getValue(ID) == settings.getValue(ID)
					)
				{
					controlBar.element = target;
				}
			}
		}
		
		// Overrides
		//
		
		override public function set resource(value:MediaResourceBase):void
		{
			if (value != null)
			{
				settings
					= value.metadata.getFacet(ControlBarPlugin.NS_CONTROL_BAR_SETTINGS)
					as KeyValueFacet;
			}
			
			super.resource = value;
		}
		
		override protected function setupTraits():void
		{
			setupControlBar();
			
			viewable = new DisplayObjectTrait(controlBar, controlBar.mediaWidth, controlBar.mediaHeight);
			addTrait(MediaTraitType.DISPLAY_OBJECT, viewable);
			
			var layoutProperties:LayoutProperties = new LayoutProperties(this);
			layoutProperties.width = controlBar.mediaWidth;
			layoutProperties.height = controlBar.mediaHeight;
			trace(controlBar.mediaWidth, controlBar.mediaHeight);
			
			super.setupTraits();	
		}
		
		// Internals
		//
		
		private function getTargetFacet(target:IMetadataProvider):KeyValueFacet
		{
			var targetFacet:KeyValueFacet;
			
			if (target)
			{
				targetFacet	
					= target.metadata.getFacet(ControlBarPlugin.NS_CONTROL_BAR_TARGET)
					as KeyValueFacet;
			}
			
			return targetFacet;
		}
		
		private function setupControlBar():void
		{
			controlBar = new ControlBarBase();
			
			var widget:ControlBarWidget;

			widget = controlBar.addWidget(SCRUB_BAR, new ScrubBar());
			widget.setPosition(0, SCRUBBAR_VERTICAL_OFFSET);
						
			widget = controlBar.addWidget(PLAY_BUTTON, new PlayButton());
			widget.setPosition(BORDER_SPACE, BUTTONS_VERTICAL_OFFSET);

			widget = controlBar.addWidget(PAUSE_BUTTON, new PauseButton());
			widget.setRegistrationTarget(PLAY_BUTTON, Direction.RIGHT);
			widget.setPosition(1, 0);
			
			widget = controlBar.addWidget(QUALITY_BUTTON, new QualityModeToggle());
			widget.setRegistrationTarget(PAUSE_BUTTON, Direction.RIGHT);
			widget.setPosition(3, 0);
			widget.hint = "Click to toggle between automatic and manual quality mode";
			
			widget = controlBar.addWidget(QUALITY_INCREASE, new QualityIncreaseButton());
			widget.setRegistrationTarget(QUALITY_BUTTON, Direction.RIGHT);
			widget.setPosition(-2, 4);
			
			widget = controlBar.addWidget(QUALITY_DECREASE, new QualityDecreaseButton());
			widget.setRegistrationTarget(QUALITY_INCREASE, Direction.RIGHT);
			widget.setPosition(1, 0);
			
			widget = controlBar.addWidget(QUALITY_LABEL, new QualityLabel());
			widget.setRegistrationTarget(QUALITY_DECREASE, Direction.RIGHT);
			widget.setPosition(0, -3);
						
			widget = controlBar.addWidget(SOUND_MORE, new SoundMoreButton());
			widget.setPosition(292, BUTTONS_VERTICAL_OFFSET);
			
			widget = controlBar.addWidget(SOUND_LESS, new SoundLessButton());
			widget.setRegistrationTarget(SOUND_MORE, Direction.LEFT);
			widget.setPosition(1, 0);
		}
		
		private var settings:KeyValueFacet
		
		private var controlBar:ControlBarBase;
		private var viewable:DisplayObjectTrait;
		
		/* static */
		
		private static const ID:ObjectIdentifier = new ObjectIdentifier("ID");
		
		private static const SCRUB_BAR:String = "scrubBar";
		private static const PAUSE_BUTTON:String = "pauseButton";
		private static const PLAY_BUTTON:String = "playButton";
		private static const QUALITY_BUTTON:String = "qualityButton";
		private static const QUALITY_INCREASE:String = "qualityIncrease";
		private static const QUALITY_DECREASE:String = "qualityDecrease";
		private static const QUALITY_LABEL:String = "qualityLabel";
		private static const SOUND_LESS:String = "soundLess";
		private static const SOUND_MORE:String = "soundMore";
		
		private static const BUTTONS_VERTICAL_OFFSET:Number = 10;
		private static const SCRUBBAR_VERTICAL_OFFSET:Number = 22;
		private static const BORDER_SPACE:Number = 9;
	}
}