public class Voice extends Chugraph
{
    SinOsc sineOsc;
    TriOsc triOsc;
    SqrOsc sqrOsc;
    
    sineOsc => ADSR env => outlet;

    1000::ms => env.releaseTime;

    private void Voice(int oscMode) { 
        setOsc(oscMode);
        
        if(oscMode == 2)
        {
            setGain(0.1);
        }
        else
        {
            setGain(0.5);
        }
    }
    fun void setFreq(float freq)
    {
        freq => sineOsc.freq => triOsc.freq => sqrOsc.freq;
    }
    
    fun void setGain(float gain)
    {
        gain => sineOsc.gain => triOsc.gain => sqrOsc.gain;
    }

    private void setOsc(int index)
    {
        if(index == 0)
        {
            sineOsc => env;
            triOsc =< env;
            sqrOsc =< env;
        }
        else if(index == 1)
        {
            sineOsc =< env;
            triOsc => env;
            sqrOsc =< env;
        }
        else if(index == 2)
        {
            sineOsc =< env;
            triOsc =< env;
            sqrOsc => env;
        }
    }

    fun void on(float freq, int velocity)
    {
        freq => setFreq;
        0.5 * (velocity / 127.0) => setGain;
        1 => env.keyOn;
    }

    fun void off()
    {
        1 => env.keyOff;
    }
}