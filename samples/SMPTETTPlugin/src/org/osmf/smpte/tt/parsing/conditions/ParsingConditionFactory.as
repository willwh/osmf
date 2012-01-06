package org.osmf.smpte.tt.parsing.conditions
{
	import org.osmf.smpte.tt.parsing.conditions.impl.ParsingCondition_Continous;
	import org.osmf.smpte.tt.parsing.conditions.impl.ParsingCondition_PercentageIntervalByTime;
	import org.osmf.smpte.tt.parsing.conditions.impl.ParsingCondition_SpecificTimings;

	public class ParsingConditionFactory
	{
		public static function getCondition():ParsingCondition
		{
			return every10PercentDuration()
		}
		
		private static function every10PercentDuration():ParsingCondition
		{
			return new ParsingCondition_PercentageIntervalByTime(10);
		}
		
		private static function atDefinedDurations():ParsingCondition
		{
			var definedDurationsInSeconds:Array = [10,100,500,1000,1500,2000,2500,3000];
			return new ParsingCondition_SpecificTimings(definedDurationsInSeconds);
		}
		
		private static function continously():ParsingCondition
		{
			return new ParsingCondition_Continous();
		}
	}
}