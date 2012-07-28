// This is a simple pitch follower. 'Nuff said

s = Server.local;
s.options.hardwareBufferSize = (800);

// NOTE: UNCOMMENT if on a Mac and using the "mic in" port
//"open -a 'Audio MIDI Setup'".unixCmd;

(
SynthDef("pitchFollow1",{
	var in, amp, freq, hasFreq, out;
	// (allow as input) all the things!! :)
	in = Mix.new(SoundIn.ar([0,1,2,3,4,5,6,7,8]));
	amp = Amplitude.kr(in, 0.05, 0.05);
	# freq, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 7);
	//freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
	// I replaced the below commented lines with this one:
	out = Mix.new(SinOsc.ar(freq * [0.5,1,2], 0, amp));
	// the following added a randomized blipping kinda effect...
/*
	// NOTE: the [0.5,1,2] indicates an octave below, an octave aboce and two octaves above
	out = Mix.new(VarSaw.ar(freq * [0.5,1,2], 0, LFNoise1.kr(0.3,0.1,0.1), amp));
	6.do({
		out = AllpassN.ar(out, 0.040, [0.040.rand,0.040.rand], 2)
	});
*/
	Out.ar(0,out)
}).play(s);)
