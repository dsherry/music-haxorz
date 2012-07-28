// This file contains a test of the PolyPitch SuperCollider plugin
// 
// I highligted this first segment to get a printout of the PolyPitch in action. I haven't looked at the other code yet.

({
var in, tracked;

// Haven't messed with these lines yet... just added the last to capture all input
//in = Mix(SinOsc.ar([440,990,775],0,0.1));Ê
//in = Mix(Saw.ar([440,990,775],0.1));
//in= SoundIn.ar;
in = Mix.new(SoundIn.ar([0,1,2,3,4,5,6,7,8]));

// instantiate the PolyPitch object, 6 voices max
tracked=PolyPitch.kr(in,6,-0.1,10.0);

// start tracking?
tracked.poll;

// uncomment the following line to output the original input signal
//Out.ar(0,Pan2.ar(in));
}.play)

//
// Here Be Dragons
// 
//   |  |  |
//   |  |  |
//   V  V  V


(
{

var in, tracked;

in= SoundIn.ar;

tracked=PolyPitch.kr(in,6,-0.1,10.0);

SendReply.kr(Impulse.kr(44100/2048),'polyparam',tracked); 

}.play
)


(

SynthDef(\ppsine,{arg amp=0.0, freq= 440,pan=0.0; 
	
	
	Out.ar(0,Pan2.ar(Saw.ar(freq.lag(0.01),amp.lag(0.01)),pan))
}).add; 
)

(
b = Array.fill(6,{Synth(\ppsine)})
)


(
var count= 0; 

o.remove; 

o = OSCresponder(nil, 'polyparam', { |t, r, msg| 
	

	var numvoices = msg[3]; 
	
	count= (count+1)%1; 	
	
	if(count==0) {
		msg.postln;
	
	6.do{|i| var index = 4+(i*2); 
		
		if(i<numvoices) {
		
		b[i].set(\freq,msg[index]*4,\amp,0.2); //*(msg[index+1])
		
		}
		{
		
		b[i].set(\amp,0.0); 
			
		}
		
		};
	}
	
	
	
}).add;

)

c = {(SoundIn.ar*0.5)!2}.play

c.free;
