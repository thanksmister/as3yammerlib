package com.yammer.api.signals
{
	import com.yammer.api.vo.YammerError;
	import org.osflash.signals.Signal;

	public class ErrorReceivedSignal extends Signal
	{ 
		public function ErrorReceivedSignal()
		{
			super(YammerError);
		}
	}
}