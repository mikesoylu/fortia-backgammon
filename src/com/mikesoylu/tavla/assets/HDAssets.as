package com.mikesoylu.tavla.assets {
	/**
	 * @author bms
	 */
	public class HDAssets {
		public function HDAssets() {
			
		}
		
		[Embed(source="../../../../../assets/sheet2x.xml", mimeType="application/octet-stream")]
		public static const sheet2x_xml:Class;
		
		[Embed(source="../../../../../assets/sheet2x.png")]
		public static const sheet2x:Class;
	}
}