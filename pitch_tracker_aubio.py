import sys
import numpy
import wave
import aubio
import pyaudio
import time

filename = "/home/dylan/Dropbox/music-haxorz/Sine_wave_440.wav"

downsample = 1
win_s = 4096 / downsample # fft size
hop_s = 512  / downsample # hop size

# COMMENTED CODE FOR FILES ONLY
# # get framerate
# wr = wave.open(filename, 'r')
# samplerate = wr.getframerate() / downsample
# wr.close()
# # todo use numpy.fromstring(data, 'Int16') to convert string data to ints.
# # http://stackoverflow.com/questions/19629496/get-an-audio-sample-as-float-number-from-pyaudio-stream

# get audio from pulseaudio via pyaudio
FORMAT = pyaudio.paFloat32
CHANNELS = 2
RATE = 44100

# set up callback for writing data
frameBuffer = []
def callback(in_data, frame_count, time_info, status):
    print "Time: %s, status: %s" %(time_info, status)
    print "Need %d frames" %frame_count
    ctr = 0
    while len(frameBuffer) < frame_count:
        if ctr % 100 == 0: print "Warning: len of frameBuffer is %d" %len(frameBuffer)
        time.sleep(0.001)
        ctr += 1
        if ctr > 1000:
            print "Fatal error: buffer still empty after 1 second"
            sys.exit(-1)
    data = []
    for i in xrange(frame_count):
        data.append(frameBuffer.pop(0))
    joined = b''.join(data)
    print "Done"
    print len(joined)
    return (joined, pyaudio.paContinue)

p = pyaudio.PyAudio()
instream = p.open(format=FORMAT,
                  channels=CHANNELS,
                  rate=RATE,
                  input=True,
                  frames_per_buffer=hop_s)
outstream = p.open(format=FORMAT,
                   channels=CHANNELS,
                   rate=RATE,
                   output=True,
                   stream_callback = callback)

# set up YIN pitch tracking algo
tolerance = 0.8
pitch_o = aubio.pitch("yin", win_s, hop_s, RATE)
pitch_o.set_unit("freq")
pitch_o.set_tolerance(tolerance)

print "Recording"

try:
    outstream.start_stream()
    print "Finished?: " + str(outstream.is_active())
    while True:
        data_str = instream.read(hop_s)
        data = numpy.fromstring(data_str,'Float32')
        pitch = pitch_o(data)[0]
        print "Pitch: %.5f Hz"%pitch
        for i in xrange(len(data_str)):
            frameBuffer.append(data_str[i])
        print "Active?: " + str(outstream.is_active())
        #outstream.write(data_str)
except KeyboardInterrupt:
    print "\nReceived interrupt; exiting."

instream.stop_stream()
instream.close()
outstream.stop_stream()
outstream.close()
p.terminate()
