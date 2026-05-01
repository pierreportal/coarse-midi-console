@import "console/baseInstrument.ck" // entry point cartridge instrument.

// MIDI device selection.
0 => int device;
if( me.args() ) me.arg(0) => Std.atoi => device;

MidiIn min;
MidiMsg msg;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

// Instrument instence.
BaseInstrument inst;

// MIDI envent listener start.
while( true )
{
    min => now;
    while( min.recv( msg ) )
    {
        inst.handleMidiInData(msg);
    }
}
