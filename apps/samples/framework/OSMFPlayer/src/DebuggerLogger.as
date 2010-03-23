package
{
	import org.osmf.logging.TraceLogger;
	
	public class DebuggerLogger extends TraceLogger
	{
		public function DebuggerLogger(name:String, debugger:Debugger)
		{
			super(name);
			
			this.name = name;
			this.debugger = debugger;
		}
		
		override protected function log(level:String, message:String, params:Array):void
		{
			var msg:String = "";
			
			// add datetime
			msg += new Date().toLocaleString() + " [" + level + "] ";
			
			// add name and params
			msg += "[" + name + "] " + applyParams(message, params);
			
			// trace the message
			debugger.send(msg);
		}
		
		// Internals
		//
		
		private var name:String;
		private var debugger:Debugger;
	}
}