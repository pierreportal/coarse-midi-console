class SinLfo
{
    SinOsc sineOsc;
    setFreq(pi);
    setGain(50);
    sineOsc => blackhole;

    fun dur period(){return sineOsc.period();}
    fun float value(){return sineOsc.last();}

    fun void setFreq(float f)
    {
        f => sineOsc.freq;
    }
    fun void setGain(float g)
    {
        g => sineOsc.gain;
    }
}

public class Chain extends Chugraph
{
    inlet => LPF lpf => Dyno limiter => NRev rev => outlet;
    time T;

    10000 => lpf.freq;
    100::ms => limiter.attackTime;
    0.8 => limiter.thresh;
    0.1 => rev.mix;

    fun void filterEnvelope()
    {
        SinLfo lfo1;
        lfo1.setGain(100.0);
        500.0 => float center;
        100.0 => float offset;
        T % lfo1.period() => now;
        while(1)
        {
            10::ms => now;
            (lfo1.value() + center) + offset => lpf.freq;
        }
    }

    private void Chain()
    {
        spork ~ filterEnvelope();
    }
}
