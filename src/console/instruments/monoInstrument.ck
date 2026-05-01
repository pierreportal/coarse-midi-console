@import "voices/graphs.ck"

public class MonoVoice extends Chugraph
{
    0 => int SIN_OSC;
    1 => int TRI_OSC;
    2 => int SQR_OSC;

    Voice v(TRI_OSC) => outlet;

    220.0 => float f;

    fun void keyOn(int note, int velocity) 
    {
        Std.mtof(note) => float newFreq;
        if(f < newFreq)
        {
            while(f != newFreq)
            {
                f + 0.1 => f;
                v.on(f, velocity);
                10::ms => now;
            }
        }
        else if(f > newFreq)
        {
            while(f != newFreq)
            {
                f - 0.1 => f;
                v.on(f, velocity);
                10::ms => now;
            }
        }
        else
        {
            v.on(f, velocity);
        }
    }

    fun void keyOff(int note)
    {
        v.off();
    }

    fun void handleMidiInData(MidiMsg midiMsg)
    {
        if( (midiMsg.data1 & 0xf0) == 0x90 )
        {
            if( midiMsg.data3 > 0 )
            {
                keyOn(midiMsg.data2, midiMsg.data3);
            }
        }
        else if( (midiMsg.data1 & 0xf0) == 0x80 )
        {
            keyOff(midiMsg.data2);
        }
    }
}