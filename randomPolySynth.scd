//
// Here Be Dragons
// 
//   |  |  |
//   |  |  |
//   V  V  

(
{

var in, tracked;

in= SoundIn.ar;

// random code from PolySynth demo

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
