(
// a bad (no offense but it's true) sinusoidal pitch follower from http://music.dartmouth.edu/~cc11/sc_code/bad_pitch_follower
{ 
	var in, freq, amp, sig, sig2;
	in = AudioIn.ar(1);
	sig = RLPF.ar(in, 8000, 0.2);
	sig2 = RHPF.ar(sig, 100, 0.2);
	freq = OnePole.ar(ZeroCrossing.ar(sig2), 0.99);
	f = max(freq, 100);
	f.value.postln;
	g = min(f, 400);
	g.value.postln;
	
	amp = Amplitude.kr(in);
	s = SinOsc.ar(f, 0, amp);
	// Integrator.ar(sig, 0.3)
	s

}.scope(0.1)

)
