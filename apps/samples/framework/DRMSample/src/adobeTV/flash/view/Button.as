package adobeTV.flash.view
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class Button extends Sprite
	{
		public function Button(upState:DisplayObject, overState:DisplayObject, downState:DisplayObject, hitTestState:DisplayObject)
		{
			super();
			innerButton = new SimpleButton(upState, overState, downState, hitTestState);
			innerButton.mouseEnabled = false;
			
			labelControl = new TextField();
			labelControl.mouseEnabled = false;
			addChild(innerButton);
			addChild(labelControl);				
		}
		
		public function set emphasized(value:Boolean):void
		{
			_emphasized = value;
		}	
		
		public function get emphasized():Boolean
		{
			return _emphasized;	
		}	
			
		public function set label(value:String):void
		{			
			labelControl.text = value;
			setSize(innerButton.width, innerButton.height);
		}
		
		public function get label():String
		{			
			return labelControl.text;
		}
		
		public function set enabled(value:Boolean):void
		{			
			_enabled = value;
		}
		
		public function get enabled():Boolean
		{			
			return _enabled;
		}
		
		public function set icon(value:DisplayObject):void
		{
			if(_icon)
			{
				removeChild(_icon);
			}
			_icon = value;
			addChild(_icon);
			setSize(innerButton.width, innerButton.height);
		}
		
		public function setSize(width:Number, height:Number):void
		{
			innerButton.width = width;
			innerButton.height = height;
			
			labelControl.width = width;
			labelControl.height = height;
			
			_icon.x =  (width - _icon.width)/2;
			_icon.y =  (height - _icon.height)/2;
			labelControl.x =  (width - labelControl.width)/2;
			labelControl.y =  (height - labelControl.height)/2;			
		}
		
		private var _enabled:Boolean = true;
		private var _emphasized:Boolean;
		private var _icon:DisplayObject;
		private var _label:String;
		private var labelControl:TextField;
		private var innerButton:SimpleButton;
				
	}
}