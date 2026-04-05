// ======================= AUv3 AUDIO UNIT =======================
import AudioToolbox
import AVFoundation

class MyMIDIProcessorAudioUnit: AUAudioUnit {

    let router = MIDIRouter() // Shared MIDI engine

    override func handleMIDIEvent(_ midiEvent: AUMIDIEvent) {
        let event = MIDIEvent(
            status: midiEvent.data.0,
            data1: midiEvent.data.1,
            data2: midiEvent.data.2,
            timestamp: UInt64(midiEvent.eventSampleTime)
        )

        let processed = router.route(event: event) // Verwerk MIDI
        
        // TODO: stuur naar output host
    }
}
