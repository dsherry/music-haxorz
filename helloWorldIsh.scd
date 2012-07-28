// My first SuperCollider file...
(
	// in theory, these should cancel out
	a = 0.001;
	{ SinOsc.ar(440,0,0.2)}.play;			// close the Function and call 'play' on it
	{ SinOsc.ar(440,pi-a.value,0.2)}.play;			// close the Function and call 'play' on it
)
