/*****************************************************
 *  
 *  Copyright 2012 Adobe Systems Incorporated.  All Rights Reserved.
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
 *  Portions created by Adobe Systems Incorporated are Copyright (C) 2012 Adobe Systems 
 *  Incorporated. All Rights Reserved. 
 *  
 *****************************************************/
package org.osmf.utils {
	import flexunit.framework.Assert;
	
	public class TestDateUtil {		
		[Test]
		public function testParseW3CDTF():void {
			// Reference data tested against previous implementation and, where
			// necessary, the correct answer manually computed. These were then
			// double checked through DateTime::Format::W3CDTF
			//   http://search.cpan.org/~gwilliams/DateTime-Format-W3CDTF/
			var cases:Array = [
				// Previous implementation handled these cases correctly...
				{ "in": "1994-11-05T08:15:30-05:00",    "out":  784041330000 },
				{ "in": "1997-07-16T19:20+01:00",       "out":  869077200000 },
				{ "in": "1997-07-16T19:20:30+01:00",    "out":  869077230000 },
				{ "in": "1999-09-25T14:20+10:00",       "out":  938233200000 },
				{ "in": "2000-06-12T14:12:33Z",         "out":  960819153000 },
				{ "in": "2003-12-31T10:14:55-08:00",    "out": 1072894495000 },
				{ "in": "2003-12-31T10:14:55Z",         "out": 1072865695000 },
				{ "in": "2005-03-10T20:14:34+09:30",    "out": 1110451474000 },

				// ...but misparsed or failed on these 
				{ "in": "1985-06",                      "out":  486432000000 },
				{ "in": "1988",                         "out":  567993600000 },
				{ "in": "1997",                         "out":  852076800000 },
				{ "in": "1997-04-11T09:34",             "out":  860751240000 },
				{ "in": "1997-07",                      "out":  867715200000 },
				{ "in": "1997-07-16",                   "out":  869011200000 },
				{ "in": "1997-07-16T19:20:30.45+01:00", "out":  869077230450 },
				{ "in": "2002-05-12",                   "out": 1021161600000 },
				{ "in": "2003",                         "out": 1041379200000 },
				{ "in": "2003-02-10T15:23:45",          "out": 1044890625000 },
				{ "in": "2003-02-10T15:23:45.045",      "out": 1044890625045 },
				{ "in": "2003-02-10T15:23:59.999999",   "out": 1044890639999 },
				{ "in": "2003-01-01T00:00:00.000",      "out": 1041379200000 },
				{ "in": "2003-12-31T23:59:59.999",      "out": 1072915199999 },
				{ "in": "2003-12",                      "out": 1070236800000 },
				{ "in": "2003-12-31",                   "out": 1072828800000 },
				{ "in": "2004-07-01T15:00:13.17-05:00", "out": 1088712013170 },
				{ "in": "2004-07-01T15:00:13.17-05:30", "out": 1088713813170 },
				{ "in": "2003-02-28T10:14:51",			"out": 1046427291000 },
				{ "in": "2004-02-29T10:14:51",			"out": 1078049691000 },
				{ "in": "2100-02-28T10:14:51",			"out": 4107492891000 }
			];
			
			for each (var tc:Object in cases) {
				var got:Date = DateUtil.parseW3CDTF(tc['in']);
				Assert.assertNotNull(got);
				Assert.assertEquals(
					"Wanted " + new Date(tc['out']).toUTCString() + ", got " + got.toUTCString(),
					tc['out'], got.time 
				);
			}
		}
		[Test]
		public function testParseW3CDTFFail():void {
			var cases:Array = [
				"03-12-31T10:14:61Z",
				"1997-07-16T19:20:30.45+0100",
				"2003-12-31T25:14:55Z",
				"2003-12-31T10:61:55Z",
				"2003-12-31T10:14:61Z",
				"20050310T201434+0930",
				"20050310T201434",
				"2003-13-31T10:14:51",
				"2003-12-31TZ",
				"2003-02-29T10:14:51",//we don't support month checking
				"2004-02-30T10:14:51",//we don't support month checking
				"2100-02-29T10:14:51",//we don't support month checking
				"2003-02-18T30:14:51",
				"2004-07-01T15:00:13.17-30:00",
				"2004-07-01T15:00:13.17-10:75",
				"",
				"-1",
				"alabalaportocala",
				null
			];
			
			for each (var bad:String in cases) {
				var gotError:Boolean = false;
				try {
					DateUtil.parseW3CDTF(bad);
				}
				catch (e:Error) {
					gotError = true;
				}
				Assert.assertTrue("Shouldn't parse " + bad, gotError);
			}
		}
	}
}
