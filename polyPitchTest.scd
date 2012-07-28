// This file contains a test of the PolyPitch SuperCollider plugin
// 
// I highligted this first segment to get a printout of the PolyPitch in action. I haven't looked at the other code yet.

s = Server.local;

// NOTE: UNCOMMENT if on a Mac and using the "mic in" port
//"open -a 'Audio MIDI Setup'".unixCmd;

({
var in, tracked, numFreqs, amp, freqs, amps, out;

// Haven't messed with these lines yet... just added the last to capture all input
//in = Mix(SinOsc.ar([440,990,775],0,0.1));Ê
//in = Mix(Saw.ar([440,990,775],0.1));
//in= SoundIn.ar;
in = Mix.new(SoundIn.ar([0]));
// add amplitude tracking
amp = Amplitude.kr(in, 0.25, 0.25, 10);
//amp.poll(10);

// instantiate the PolyPitch object, 6 voices max
tracked=PolyPitch.kr(in,6,-0.1,10.0);

// start tracking?
tracked.poll(250);

// add output of the base frequency
//out = Mix.new(SinOsc.ar(tracked[1].value, 0, amp));
/*
// AUGH BROKEN ALGORITHM
numFreqs = tracked[0];
freqs = [10,10,10,10,10,10];
amps = [0,0,0,0,0,0];
for (1, 6, {
	arg i;
	// 1, 3, 5, 7, etc...
	var j = (2 * i) - 1;
	if (i > numFreqs, {
			amps[i].set(0);
		}, {
			freqs[i].set(tracked[j]);
			amps[i].set(tracked[j+1]);
			// pass
		});
//	freqs[i] = tracked[j];
//	amps[i] = tracked[j+1];
	}
);
out = Mix.new(SinOsc.ar(freqs, 0, amps));
*/
//out = Mix.new(SinOsc.ar(tracked[1], 0, amp));

out = Mix.new(SinOsc.ar([tracked[1],tracked[3]], 0, amp));
Out.ar(0,out);
// uncomment the following line to output the original input signal
//Out.ar(0,Pan2.ar(in));
}.play)


