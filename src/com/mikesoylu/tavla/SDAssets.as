package com.mikesoylu.tavla {
	/**
	 * @author bms
	 */
	public class SDAssets {
		public function SDAssets() {
			
		}
		
		[Embed(source="../../../../assets/sheet.xml", mimeType="application/octet-stream")]
		public static const ATLAS_XML:Class;
		
		[Embed(source="../../../../assets/sheet.png")]
		public static const sheet:Class;
	}
}