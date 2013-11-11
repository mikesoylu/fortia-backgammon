package com.mikesoylu.tavla.assets {
	/**
	 * @author bms
	 */
	public class SDAssets {
		public function SDAssets() {
			
		}
		
		[Embed(source="../../../../../assets/sheet.xml", mimeType="application/octet-stream")]
		public static const sheet_xml:Class;
		
		[Embed(source="../../../../../assets/sheet.png")]
		public static const sheet:Class;
	}
}