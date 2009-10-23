package adobeTV.flash.view 
{
	import adobeTV.flash.events.CCEvent;
	import adobeTV.flash.PlayerTvMain;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Robert Colvin
	 */
	public class ClosedCaptioning extends Sprite
	{
		
		private var Txt:TextField;
		private var bg:Sprite;
		private var ws:URLLoader;
		
		private var allCC:Array = [];
		
		public var isCCavailable:Boolean = true;
		
		public function ClosedCaptioning() 
		{
			bg = new Sprite();
			Txt = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.color = 0xFFFFFF;
			tf.align = "center";
			tf.size = 12;
			
			tf.font = "Arial";
			Txt.wordWrap = true;
			Txt.multiline = true;
			Txt.width = 250;
			Txt.height = 35;
			Txt.defaultTextFormat = tf;
			Txt.selectable = true;
			//Txt.background = true;
			//Txt.backgroundColor = 0xCCCCCC;
			
			text = "";
			
			this.addChild(bg);
			this.addChild(Txt);
			
			ws = new URLLoader();
			ws.addEventListener(Event.COMPLETE, serviceCCLoad); 
			ws.addEventListener(IOErrorEvent.IO_ERROR, errorURL);
		}
	
		private function errorURL(e:IOErrorEvent):void {
			trace("load of CCaptions failed");	
				disableCCbtn();
		}
		
		
		public function set text(t:String):void {
			Txt.text = t;
		}
		
		public function setSize(w:Number, h:Number):void {
			PlayerTvMain.square(bg.graphics, { x:0, y:0, width:w, height:35 }, 0, 0x686868, .5, 0, 0x000000);
			Txt.x = (this.width - Txt.width) * .5;
		}
		
		public function loadSource(url:String):void
		{
			//http://tv.adobe.com/captions/cc_f1494v1000.xml
			if (url != "") {
				ws.load(new URLRequest(url));				
			}else {
				trace("(W) no caption url passed disabling button");
				isCCavailable = false;
				disableCCbtn();
			}
		}
		
		public function serviceCCLoad(e:Event):void {
			try{
				var xml:XML = new XML(e.target.data);
				var totalCC:int = xml..caption.length();
				var i:int;
				if (totalCC!=0){
					for ( i = 0; i < totalCC;++i) {
						allCC.push( {time: xml..caption[ i ].@time,msg:xml..caption[i]} );
					}
				}else {
					var sClean:String = parseCCstructure(e.target.data);
					xml=new XML(sClean);
					totalCC = xml..p.length();
					//trace("\n\n" + totalCC + "  is the total\n\n");
					for (i = 0; i < totalCC;++i) { //trace(xml..p[i].@begin);
							allCC.push( {time: convertToSeconds(xml..p[ i ].@begin),msg:xml..p[i]} );
						}
				}
			}catch (e:Error) {
				trace("(E) loaded caption file error::" + e);
				disableCCbtn();
			}
		}
		
		private function parseCCstructure(xml:String):String {
				var re1:RegExp = /<br\/>/gi;
				xml=xml.replace(re1, " ");
				re1 = /\n/gi;
				xml = xml.replace(re1, " ");
				re1 = /\n/gi;
				xml = xml.replace(re1, " ");
				//var re:RegExp = /<div\b[^>]*>(.*?)<\/div>/gi;
				//var result:Object = re.exec(newXML);
				//trace(result[1]);
				return  '<?xml version="1.0" encoding="UTF-8"?><tt>'+xml.slice(xml.indexOf("<p"),xml.indexOf("</div"))+'</tt>';
		}
		
		private function disableCCbtn():void {
				var cEvent:CCEvent = new CCEvent(CCEvent.URL_MISSING);
				this.dispatchEvent(cEvent);
				isCCavailable = false;
		}
		
		public function findCaption(elapsed:Number):void {
			//if (!this.parent) return;
			++elapsed;
			var atot:int = allCC.length;
			for (var i:int = 0; i < atot;++i) {
				var cc:Object = allCC[i];
				if (cc.time > elapsed) {
					if(i!=0)showCaption(allCC[i-1].msg);
					return;
				}
			}
			//go ahead and remove captions as there are none left
		}
		
		private function showCaption(msg:String):void
		{
			Txt.text = msg;
			if (this.parent)this.stage.focus = Txt;
			Txt.setSelection(0, Txt.text.length);
		}
		
		private function convertToSeconds(timecode:String):Number {
			var time:Array = timecode.split(":");
			var hr:int=parseInt(time[0])*60*60;
			var min:int=parseInt(time[1])*60;
			var sec:Number = Number(time[2]);
			return hr + min + sec+1;
		}
		
		//END CLASS
	}	
}