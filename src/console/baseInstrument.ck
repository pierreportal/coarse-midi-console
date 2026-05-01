@import "instruments/polyInstrument.ck"
@import "customChain.ck"

public class BaseInstrument
{
    PolyVoices keys => Chain g => dac;

    fun void handleMidiInData(MidiMsg midiMsg)
    {
        keys.handleMidiInData(midiMsg);
    }
};
