package org.osmf.chrome.application
{
	import flash.display.Sprite;
	
	import org.osmf.chrome.configuration.Configuration;
	import org.osmf.chrome.configuration.WidgetsParser;
	import org.osmf.chrome.widgets.Widget;
	import org.osmf.containers.MediaContainer;
	import org.osmf.layout.LayoutRenderer;
	import org.osmf.layout.LayoutRendererBase;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;

	public class ChromeApplication extends Sprite
	{
		// Public Interface
		//
		
		public function ChromeApplication()
		{
			super();
			
			_factory = constructMediaFactory();
			_player = constructMediaPlayer();
			_renderer = constructLayoutRenderer();
			_container = constructMediaContainer(renderer);
			_widgets = constructWidgetsParser();
			
			addChild(_container);
		}
		
		public function get factory():MediaFactory
		{
			return _factory;
		}
		
		public function get player():MediaPlayer
		{
			return _player;
		}
		
		public function get renderer():LayoutRendererBase
		{
			return _renderer;
		}
		
		public function get container():MediaContainer
		{
			return _container;
		}
		
		public function get widgets():WidgetsParser
		{
			return _widgets;
		}
		
		public function setup(configuration:Configuration):void
		{
			_widgets.parse
				( configuration.configuration.widgets.*
				, configuration.assetsManager
				);
			
			// Add widgets on top of the media:
			var index:Number = 10000;
			for each (var widget:Widget in _widgets.widgets)
			{
				widget.layoutMetadata.index = index++;
				_renderer.addTarget(widget);
			}
			
			processSetupComplete();
		}
		
		public function set media(value:MediaElement):void
		{
			if (value != _media)
			{
				// Remove the current media from the container:
				if (_media)
				{
					container.removeMediaElement(_media);
				}
				
				// Remove the current media reference from all widgets: 
				for each (var widget:Widget in _widgets.widgets)
				{
					widget.media = null;
				}
				
				// See if subclasses wish to process the new value:
				var processedNewValue:MediaElement = processNewMedia(value);
				if (processedNewValue)
				{
					value = processedNewValue;
				}
				
				// Set the new main media element:
				_media = player.media = value;
					
				if (_media)
				{
					// Forward a reference to all chrome widgets:
					for each (widget in _widgets.widgets)
					{
						widget.media = _media;
					}
					
					// Add the media to the media container:
					container.addMediaElement(_media);
				}
			}
		}
		
		public function get media():MediaElement
		{
			return _media;
		}
		
		public function set url(value:String):void
		{
			media = factory.createMediaElement(new URLResource(value));
		}
		
		// Protected
		//
		
		protected function constructLayoutRenderer():LayoutRendererBase
		{
			return new LayoutRenderer();
		}
		
		protected function constructMediaContainer(renderer:LayoutRendererBase):MediaContainer
		{
			return new MediaContainer(renderer);
		}
		
		protected function constructMediaFactory():MediaFactory
		{
			return new DefaultMediaFactory();
		}
		
		protected function constructMediaPlayer():MediaPlayer
		{
			return new MediaPlayer();
		}
		
		protected function constructWidgetsParser():WidgetsParser
		{
			return new WidgetsParser();
		}
		
		protected function processSetupComplete():void
		{
		}
		
		protected function processNewMedia(value:MediaElement):MediaElement
		{
			return null;
		}
		
		// Overrides
		//
		
		override public function set width(value:Number):void
		{
			container.width = value;
		}
		
		override public function set height(value:Number):void
		{
			container.height = value;
		}
		
		// Internals
		//
		
		private var _renderer:LayoutRendererBase;
		private var _container:MediaContainer;
		private var _factory:MediaFactory;
		private var _player:MediaPlayer;
		private var _media:MediaElement;
		private var _widgets:WidgetsParser;
	}
}