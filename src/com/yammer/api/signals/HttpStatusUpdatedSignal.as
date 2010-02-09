package com.yammer.api.signals
{
	import org.osflash.signals.Signal;

	public class HttpStatusUpdatedSignal extends Signal
	{ 
		public function HttpStatusUpdatedSignal()
		{
			super(int);
		}
	}
}