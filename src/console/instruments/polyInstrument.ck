@import "voices/graphs.ck"

public class PolyVoices extends Chugraph
{
    0 => int SIN_OSC;
    1 => int TRI_OSC;
    2 => int SQR_OSC;
    128 => int KEYBOARD_SIZE;

    Voice v(TRI_OSC)[KEYBOARD_SIZE] => outlet;

    fun void keyOn(int note, int velocity) 
    {
        v[note].on(Std.mtof(note), velocity);
    }

    fun void keyOff(int note)
    {
        v[note].off();
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