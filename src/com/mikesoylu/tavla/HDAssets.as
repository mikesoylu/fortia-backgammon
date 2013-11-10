package com.mikesoylu.tavla {
	/**
	 * @author bms
	 */
	public class HDAssets {
		public function HDAssets() {
			
		}
		
		[Embed(source="../../../../assets/sheet2x.xml", mimeType="application/octet-stream")]
		public static const ATLAS_XML:Class;
		
		[Embed(source="../../../../assets/sheet2x.png")]
		public static const sheetHD:Class;
	}
}