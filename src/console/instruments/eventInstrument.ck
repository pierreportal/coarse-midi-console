class NoteEvent extends Event 
{
    int note;
    int velocity;
}

public class EventInstrument {
    20 => int voices; // 20 = poly, 1 = mono.
    Event @ us[128];

    NoteEvent on;

    private void EventInstrument()
    {
        for( 0 => int i; i < voices; i++ ) spork ~ voiceHandler();
    }

    fun void voiceHandler() {
        CustomInstrument cinst;
        Event off;
        int note;

        while(true) {
            on => now;
            on.note => note;

            off @=> us[note];
            cinst.keyOn(note, on.velocity);

            off => now;
            cinst.keyOff();
            null @=> us[note];
        }
    }

    fun void playNote(int note, int velocity) {
        note => on.note;
        velocity => on.velocity;
        on.signal();
    }

    fun void signal(int note) {
        if(us[note] != null) {
            us[note].signal();
        }
    }

    fun void handleMidiInData(MidiMsg midiMsg)
    {
        if( (midiMsg.data1 & 0xf0) == 0x90 )
        {
            if( midiMsg.data3 > 0 )
            {
                playNote(midiMsg.data2, midiMsg.data3);
                me.yield();
            }
            else
            {
                signal(midiMsg.data2);
            }
        }
        else if( (midiMsg.data1 & 0xf0) == 0x80 )
        {
            signal(midiMsg.data2);
        }
    }
}