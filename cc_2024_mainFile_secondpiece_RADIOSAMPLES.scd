NetAddr.langPort;

/*
Recorder solo
Granulated recorder
Wind / Field recordings / joystick
Complex sonic landscape
Rhythmic elements
OP-1 - FM synth patch nr 4 - Wholetonescale from F without C#
OP-1 with recorder + some subtle field recordings
*/
(

fork{
Require("/home/numina/repos/electromagnetic_sensibility/sintnoise_2023_synthdefs_tunings.scd");
2.0.wait;
/*	"./pulsejack".unixCmd;*/

	"jack_connect SuperCollider:out_1 system:playback_1".unixCmd;
	"jack_connect SuperCollider:out_2 system:playback_2".unixCmd;
	"jack_connect SuperCollider:out_3 system:playback_1".unixCmd;
	"jack_connect SuperCollider:out_4 system:playback_2".unixCmd;
	"jack_connect SuperCollider:out_5 system:playback_1".unixCmd;
	"jack_connect SuperCollider:out_6 system:playback_2".unixCmd;
	"jack_connect SuperCollider:out_7 system:playback_1".unixCmd;
	"jack_connect SuperCollider:out_8 system:playback_2".unixCmd;
	"jack_connect SuperCollider:out_9 system:playback_1".unixCmd;
	"jack_connect SuperCollider:out_10 system:playback_2".unixCmd;




MIDIClient.init;
MIDIIn.connectAll;
	// 5.0.wait;
	//
	// Require("D:/Dropbox/PROJECTS/SC_performances/tenori-on/Ansage_Ende_01052021/animals_grainpatch_v5.scd");

4.0.wait;
//s.latency = nil;MIDIClient.init;
//stereo
~channels = Array.fill(16,{ 0});
	//multichannel (to mixer)
//~channels = [0,2,4,6,7,8,9];

~synthGroup = Group.new;
~percGroup = Group.tail(~synthGroup);
~insects = Group.tail(~synthGroup);

~recGroup = Group.after(~synthGroup);
~effectGroup = Group.after(~synthGroup);
~effectGroup2 = Group.after(~effectGroup);

~transformChain1 = Group.after(~percGroup);
~transformChain2 = Group.after(~percGroup);
~transformChain3 = Group.after(~percGroup);
~transformChain4 = Group.after(~percGroup);
~transBuses = Array.fill(4, { Bus.audio(s, 1); });

//~grain_clock = 	TempoClock.new(1);

/* transform synth*/
/*
~trans1 = Synth(\transform1, [\in, ~transBuses[0]], ~transformChain1);
~trans2 = Synth(\transform2, [\in, ~transBuses[1]], ~transformChain2);
~trans3 = Synth(\transform3, [\in, ~transBuses[2]], ~transformChain3);
~trans4 = Synth(\transform4, [\in, ~transBuses[3]], ~transformChain4);
*/

~synthChooser = 1;

~notes = Array.fill(16, { nil!128 });
~noteGroups = Array.fill(16, { Group.new(~synthGroup); });


/*BUSES*/
~anaBus = 8;
~tenvolBus = Bus.audio(s, 2);


~combBus = Bus.audio(s, 1);
~combBus2 = Bus.audio(s, 1);
/*for toy piano */
~toycombBus = Bus.audio(s, 1);
/* for tape grin */
~tapecombBus = Bus.audio(s, 1);

~percBus = Bus.audio(s, 1);
~percGrainBus = Bus.audio(s, 1);

~dronesideBus = Bus.audio(s, 1);
~droneverbBus = Bus.audio(s, 2);
~toypianoverbBus = Bus.audio(s, 1);
~voiceverbBus = Bus.audio(s, 1);
~slenverbBus = Bus.audio(s, 1);
~sineverbBus = Bus.audio(s, 1);
~sawverbBus = Bus.audio(s, 1);
~pulseBus = Bus.audio(s, 2);
~crushBus = Bus.audio(s, 1);

/*control buses */
~maingrainDurBus = Bus.control(s, 1).set(0.5);
~fmodBus = Bus.control(s, 1).set(0.01);
~widthBus = Bus.control(s, 1).set(0.5);
~phasemodBus = Bus.control(s,1).set(0.1);
~bpmodBus = Bus.control(s,1).set(0.1);
~fmfreqBus = Bus.control(s, 1).set(10);
~fmindexBus = Bus.control(s, 1).set(0.01);
~fmfreqBus2 = Bus.control(s, 1).set(10);
~fmindexBus2 = Bus.control(s, 1).set(0.01);

~ampVBus = Bus.control(s, 1).set(0); //bus for switching amplitude variation
~srBus = Bus.control(s, 1).set(48000);
~pitchBus = Bus.control(s, 1);

//~combC.free
//~crusher.free;
/* EFFECT SYNTHS */

// a custom envelope
~winenv = Env([0, 1, 0], [3, 1], [8, -8]);
~wenv = Buffer.sendCollection(s, ~winenv.discretize, 1);

//SAMPLES
/* BUFFERS for recording */
~recBufs = [Buffer.alloc(s, s.sampleRate*2,1), Buffer.alloc(s, s.sampleRate*2,1)];
~recBufs2 = [Buffer.alloc(s, s.sampleRate*2,1), Buffer.alloc(s, s.sampleRate*2,1)];
~recBufs3 = [Buffer.alloc(s, s.sampleRate*2,1), Buffer.alloc(s, s.sampleRate*2,1)];
~playBuf = ~recBufs[0];

~fftBuf = Buffer.alloc(s, 1024, 1);
~fftBuf2 = Buffer.alloc(s, 1024, 1);
~fftBuf3 = Buffer.alloc(s, 1024, 1);

~recFreqBus = [Bus.control(s, 1), Bus.control(s, 1)];
~recFreqBus2 = [Bus.control(s, 1), Bus.control(s, 1)];
~recFreqArr = Array.fill(2, { 0});
~grainFreqArray = Array.fill(2, {0 });

//windows for grains
~win1 = Buffer.sendCollection(s, Signal.hammingWindow(1024));
~win2 = Buffer.sendCollection(s, Signal.hanningWindow(1024));
~win3 = Buffer.sendCollection(s, Signal.welchWindow(1024));

3.0.wait;
~baseFreqs = [32.7, 65.41, 130.81, 261.63, 523.25];


~whatDrone = 0;
~whatSlen = 0;
~scaleNum = 0;

~typeScale = ~oton;
~typeScaleNum = 0;
~scale = ~typeScale[~scaleNum];
~scale = ~micro[0];
~index = 1;
~index2 = 0;
~index3 = 0;
~playBuf = ~recBufs[0];
~pelogChoose = 0;
~myscaleChoose = 0;
~myscaleChoose2 = 0;
~whatBuf = 0;
~whatMalm = 0;
~whatBallBuf = 0;
~sampleColState = 0;
~sampleCol = ~harpsi;
~sampleBallCol = ~harpsi;
//duration for drones
~dur = 2.0;
~grainAmp = 0.1;
~durSpec = [0.001, 2.0,\exp,0.001,2.0].asSpec;
~ampSpec = [0.004,0.05,\exp].asSpec;

~grainDurSpec = [2.0,0.01,\exp].asSpec;
~grainAmpSpec = [0.025,0.035,\exp].asSpec;
~maingrainDurSpec = [4.0,0.01,\exp].asSpec;
~droneMul = 0.5;
~droneMulChoose = 0;
~dronemularr = [0.5,1,0.25];

~ffreqSpec = [250,8000,\linear].asSpec;
~srateSpec = [250,32000,\exp].asSpec;

~widthSpec = [0.01,0.99,\exp].asSpec;
~fmodSpec = [0.001,300.0,\exp].asSpec;
~phasemodSpec = [0.01,80.0,\exp].asSpec;
~bpmodSpec = [0.01,500.0, \linear].asSpec;
~fmfreqSpec = [1.0,100,\linear].asSpec;
~fmindexSpec = [0.0,1,\linear].asSpec;

~modRange = [0.001, 9, \exp, 0.001].asSpec;
~ampRange = [0.25, 1.0, \linear, 0.001].asSpec;
~relRange = [0.1, 2.0, \linear, 0.001].asSpec;
~decRange = [0.001, 30.0, \exp, 0.001].asSpec;
~ratioSpec = [0, 15, \linear, 1].asSpec;


2.0.wait;
~defChoose = 0;

Require("/home/numina/repos/chirp.crush_tour2024/cc_2024_grains.scd");
4.0.wait;
Require("/home/numina/repos/chirp.crush_tour2024/cc_2024_extreme3d.scd");
2.0.wait;
	Require("/home/numina/repos/chirp.crush_tour2024/cc_2024_monome_secondpiece_radio.scd");
2.0.wait;




	~fcricket_trigBus = Bus.control(s, 1).set(58.82);
	~cicada_trigBus = Bus.control(s, 1).set(0.2);

	~percReleaseBus = Bus.control(s, 1).set(0.001);


	~phasemIndexBus = Bus.control(s, 1).set(0);
	~phaseModFreq = Bus.control(s, 1).set(8);

	~phasemIndexSpec = [0.01, 1000.0, \linear, 0.01].asSpec;
	~freqRange = [100, 800, \linear, 10].asSpec;
	~releaseRange = [0.1,1.0, 5, 0.001].asSpec;
	~relmulSpec = [1.0, 10.0, \exp, 0.001].asSpec;

	~fcrickets_trigSpec = [58.82, 400.0, \linear, 0.01].asSpec;
	~cicada_trigSpec = [0.001, 80.0, \linear, 0.01].asSpec;
	~relMul = 1;

/*fade in sdr */
	~radio_sample_picker = 5;
	~morse_sample_picker = 3;
	~radio_sample_pick = ~radio_samples[5];
	~morse_sample_pick = ~radio_samples[3];

	// ~radio_sample_pick = ~radio_samples[5];

~scene = 1;

MIDIdef.cc(\white_control, {|val, num, cc, chan|
	[val, num,cc, chan].postln;
	case
	/*scene switch*/
	{ num == 100 } {
	if ( ~scene != 0, {
				~scene = ~scene - 1;

			}, {
				~scene = 6;

			});
			("SCENE : "++~scene).postln;
			case
			{ ~scene == 0 } {
				~grainclock_spec = [0.1, 1.5, \linear, 0.01].asSpec;
				~grain_dur_spec = [5.0, 0.05, \linear, 0.01].asSpec;
				~grain_pos_spec =[0.0,0.9,\linear, 0.001].asSpec;
				~grain_rate_spec =[0.9,1.1,\linear, 0.1].asSpec;

				~fb_spec = [0.0, 0.01, \linear, 0.001].asSpec;
				~tFreq_spec = [10, 400, -2, 0.1].asSpec;
				~overlap_spec = [8.5,0.1, -2, 0.01].asSpec;
				~offsetmf_spec = \widefreq.asSpec;
				~offsetMD_spec = [0.0,0.01,\linear,0.1].asSpec;
				~rateMD_spec = [0.0,0.05,\linear,0.1].asSpec;
				~rate_spec = [0.95,1.025,\linear,0.1].asSpec;
				~tFreqMF_spec = [10,1.0, \linear, 0.1].asSpec;
				~tFreqMD_spec = [50,150, \linear, 0.1].asSpec;

			}
			{ ~scene == 1 } {
				~grainclock_spec = [0.2, 50.0, \exp, 0.01].asSpec;
				~grain_dur_spec = [5.0, 0.02, \exp, 0.01].asSpec;
				~grain_pos_spec =[0.0,0.9,\linear, 0.001].asSpec;
				~grain_rate_spec =[-1.0,3,\linear, 0.1].asSpec;

				~fb_spec = [0.0, 0.1, \linear, 0.001].asSpec;
				~tFreq_spec = [10, 4000, -2, 0.1].asSpec;
				~overlap_spec = [8.5,0.01, -2, 0.01].asSpec;
				~offsetmf_spec = \widefreq.asSpec;
				~offsetMD_spec = [0.0,0.1,\linear,0.1].asSpec;
				~rateMD_spec = [0.0,0.75,\linear,0.1].asSpec;
				~rate_spec = [0.5,2.5,\linear,0.1].asSpec;
				~tFreqMF_spec = [30.0,5.0, \linear, 0.1].asSpec;
				~tFreqMD_spec = [150,250, \linear, 0.1].asSpec;


				if ( ~psalt_switch == 1, {

				Ndef((\psalt), {|mix=0|
				var wetsig;
				var sig = SoundIn.ar(0);
				// voor morse 3 voor stem 5

				wetsig = [PitchShift.ar(sig, 0.2, SinOsc.kr(0.0125).range(0.225,0.29),0.01,0.1),
					PitchShift.ar(sig, 0.2, SinOsc.kr(0.025).range(0.42,0.515),0.01,0.1);];
				wetsig = Mix.ar(wetsig);
					wetsig = Decimator.ar(wetsig, LFNoise1.kr(0.01).range(9000,20000),8,0.4,wetsig*0.6);
					wetsig = MoogFF.ar(wetsig, SinOsc.kr(0.025).range(500, 900), 2,0,4);
					wetsig = LPF.ar(wetsig, 3000,2);
					wetsig = LPF.ar(wetsig, 3000,2);
					wetsig = Compander.ar(wetsig, wetsig, 0.01,1.0,0.1,0.001,0.1,10);
				//wetsig = CombC.ar(wetsig, 0.2, 0.2,1.0, 0.4, wetsig * 0.6);
				//wetsig = CombC.ar(wetsig, 0.1, 0.1,2.0, 0.4, wetsig * 0.6);

				//sig = (sig * (1 -mix)) + (wetsig * mix);
				//sig = sig * 2;
				Pan2.ar(wetsig, SinOsc.kr(0.025).range(-0.6,0.4));



			}).play(out:2);
				});

			};
		}
	{ num == 101 } {
	if ( ~scene != 6, {
				~scene = ~scene + 1;

			}, {
				~scene = 0;

			});
			("SCENE : "++~scene).postln;

			case
			{ ~scene == 0 } {
				~grainclock_spec = [0.1, 1.5, \linear, 0.01].asSpec;
				~grain_dur_spec = [5.0, 0.66666666666667, \linear, 0.01].asSpec;
				~grain_pos_spec =[0.0,0.9,\linear, 0.001].asSpec;
				~grain_rate_spec =[0.9,1.1,\linear, 0.1].asSpec;

				~fb_spec = [0.0, 0.01, \linear, 0.001].asSpec;
				~tFreq_spec = [10, 400, -2, 0.1].asSpec;
				~overlap_spec = [8.5,0.1, -2, 0.01].asSpec;
				~offsetmf_spec = \widefreq.asSpec;
				~offsetMD_spec = [0.0,0.01,\linear,0.1].asSpec;
				~rateMD_spec = [0.0,0.05,\linear,0.1].asSpec;
				~rate_spec = [0.95,1.025,\linear,0.1].asSpec;
				~tFreqMF_spec = [10,1.0, \linear, 0.1].asSpec;
				~tFreqMD_spec = [50,150, \linear, 0.1].asSpec;

			}
			{ ~scene == 1 } {
				~grainclock_spec = [0.2, 50.0, \exp, 0.01].asSpec;
				~grain_dur_spec = [5.0, 0.02, \exp, 0.01].asSpec;
				~grain_pos_spec =[0.0,0.9,\linear, 0.001].asSpec;
				~grain_rate_spec =[-1.0,3,\linear, 0.1].asSpec;

				~fb_spec = [0.0, 0.1, \linear, 0.001].asSpec;
				~tFreq_spec = [10, 4000, -2, 0.1].asSpec;
				~overlap_spec = [8.5,0.01, -2, 0.01].asSpec;
				~offsetmf_spec = \widefreq.asSpec;
				~offsetMD_spec = [0.0,0.1,\linear,0.1].asSpec;
				~rateMD_spec = [0.0,0.75,\linear,0.1].asSpec;
				~rate_spec = [0.5,2.5,\linear,0.1].asSpec;
				~tFreqMF_spec = [30.0,5.0, \linear, 0.1].asSpec;
				~tFreqMD_spec = [150,250, \linear, 0.1].asSpec;


				if ( ~psalt_switch == 1, {
				Ndef((\psalt), {|mix=0|
				var wetsig;
				var sig = SoundIn.ar(0);
				// voor morse 3 voor stem 5

				wetsig = [PitchShift.ar(sig, 0.2, SinOsc.kr(0.0125).range(0.225,0.29),0.01,0.1),
					PitchShift.ar(sig, 0.2, SinOsc.kr(0.025).range(0.42,0.515),0.01,0.1);];
				wetsig = Mix.ar(wetsig);
					wetsig = Decimator.ar(wetsig, LFNoise1.kr(0.01).range(9000,20000),8,0.4,wetsig*0.6);
					wetsig = MoogFF.ar(wetsig, SinOsc.kr(0.025).range(500, 900), 2,0,4);
					wetsig = LPF.ar(wetsig, 3000,2);
					wetsig = LPF.ar(wetsig, 3000,2);
					wetsig = Compander.ar(wetsig, wetsig, 0.01,1.0,0.1,0.001,0.1,10);
				//wetsig = CombC.ar(wetsig, 0.2, 0.2,1.0, 0.4, wetsig * 0.6);
				//wetsig = CombC.ar(wetsig, 0.1, 0.1,2.0, 0.4, wetsig * 0.6);

				//sig = (sig * (1 -mix)) + (wetsig * mix);
				//sig = sig * 2;
				Pan2.ar(wetsig, SinOsc.kr(0.025).range(-0.6,0.4));



			}).play(out:2);
				});

			}
			{ ~scene == 2 }
			{
				~rateState = 0;
				~radiosample_choose = 14;


			}
			{ ~scene == 3 }
			{
				~rateState = 1;
				~radiosample_choose = 9;


			}
			{ ~scene == 4 }
			{
				~rateState = 4;

			}
			{ ~scene == 5 }
			{
				~rateState = 4;
				~maingroup.set(\gate,0);


				~grainclock_spec = [0.1, 1.5, \linear, 0.01].asSpec;
				~grain_dur_spec = [5.0, 0.66666666666667, \linear, 0.01].asSpec;
				~grain_pos_spec =[0.0,0.9,\linear, 0.001].asSpec;
				~grain_rate_spec =[0.9,1.1,\linear, 0.1].asSpec;

				~fb_spec = [0.0, 0.01, \linear, 0.001].asSpec;
				~tFreq_spec = [10, 400, -2, 0.1].asSpec;
				~overlap_spec = [8.5,0.1, -2, 0.01].asSpec;
				~offsetmf_spec = \widefreq.asSpec;
				~offsetMD_spec = [0.0,0.01,\linear,0.1].asSpec;
				~rateMD_spec = [0.0,0.05,\linear,0.1].asSpec;
				~rate_spec = [0.95,1.025,\linear,0.1].asSpec;
				~tFreqMF_spec = [10,1.0, \linear, 0.1].asSpec;
				~tFreqMD_spec = [50,150, \linear, 0.1].asSpec;

			};





		}
	{ num == 50 }
		{ if ( val == 127, { 	~fieldcricket = Synth(\fieldcricket, [\tfreqBus, ~fcricket_trigBus.index, \recout, ~anaBus], ~insects); }, { ~fieldcricket.set(\gate, 0); }); }
		{ num == 58 }
		{
			~fcricket_trigBus.set( ~fcrickets_trigSpec.map(val/127));
		}
		{ num == 51 }
		{ if ( val == 127, { 	~cicada_3calls = Synth(\cicada_3calls, [\tfreqBus, ~cicada_trigBus.index, \recout, ~anaBus], ~insects); }, { ~cicada_3calls.set(\gate, 0); }); }
		{ num == 59 }
		{
			~cicada_trigBus.set( ~cicada_trigSpec.map(val/127));
		}

/*

	{ num == 52 } {
		if ( val == 127, {
				"op1 on".postln;
		Ndef(\op1).fadeTime = 5;

			Ndef((\op1), {|mix=0|
				var wetsig;
					var sig = SoundIn.ar([2,3]);
					sig = Mix(sig);
				// voor morse 3 voor stem 5

				wetsig = [PitchShift.ar(sig, 0.2, SinOsc.kr(0.03).range(0.92,1.08),0.01,0.1),
					PitchShift.ar(sig, 0.2, SinOsc.kr(0.01).range(0.91,1.15),0.01,0.1);];
				wetsig = Mix.ar(wetsig);
				wetsig = AllpassC.ar(wetsig, 0.2, 0.2,6.0, 0.4, wetsig * 0.6);
				wetsig = AllpassC.ar(wetsig, 0.1, 0.1,4.0, 0.4, wetsig * 0.6);

				sig = (sig * (1 -mix)) + (wetsig * mix);
				sig = sig * 2;
					Pan2.ar(sig, SinOsc.kr(LFNoise0.kr(0.8).range(0.01,2.0)).range(-0.2,0.1));



			}).play(out:2);
			}, {
				"op1 off".postln;
				Ndef((\op1)).free;

			});






		}

	/* psaltery */
	{ num == 53 } {
		if ( val == 127, {
				"psalt on".postln;
		Ndef(\psalt).fadeTime = 15;
						~psalt_switch = 1;
			Ndef((\psalt), {|mix=0|
				var wetsig;
				var sig = SoundIn.ar(0);
				// voor morse 3 voor stem 5

				wetsig = [PitchShift.ar(sig, 0.2, SinOsc.kr(0.0125).range(0.88,1.01),0.01,0.1),
					PitchShift.ar(sig, 0.2, SinOsc.kr(0.025).range(0.92,1.15),0.01,0.1);];
				wetsig = Mix.ar(wetsig);
				wetsig = CombC.ar(wetsig, 0.2, 0.2,6.0, 0.4, wetsig * 0.6);
				wetsig = CombC.ar(wetsig, 0.1, 0.1,4.0, 0.4, wetsig * 0.6);

				sig = (sig * (1 -mix)) + (wetsig * mix);
				sig = sig * 2;
				Pan2.ar(sig, SinOsc.kr(0.025).range(-0.6,0.4));



			}).play(out:4);
			}, {
				"psalt off".postln;
				~psalt_switch = 0;
				Ndef(\psalt).free;

			});
		}

	*/

	{ num == 38 } {


		if ( val == 127, {
			if ( ~morse_sample_picker != (~radio_samples.size-1),
				{ ~morse_sample_picker = ~morse_sample_picker + 1; },
				{ ~morse_sample_picker = 0; });
			~morse_sample_picker.postln;
            ~morse_sample_pick = ~radio_samples[~morse_sample_picker];
			});


		}

	/*fading web sdr */
	{ num == 46 } { if ( val == 127, {

			/*

			case
			{ ~scene == 0 } { ~morse_sample_pick = ~radio_samples[3]; }
			{ ~scene == 1 } { ~morse_sample_pick = ~radio_samples[0]; }
			{ ~scene == 2 } { ~morse_sample_pick = ~radio_samples[5]; }
			{ ~scene == 3 } { ~morse_sample_pick = ~radio_samples[7]; }
			{ ~scene == 4 } { ~morse_sample_pick = ~radio_samples[8]; };
			*/


			"fading in morse sample".postln;

Ndef(\sdr_morse).fadeTime = 10;

Ndef(\sdr_morse, {|amp=0.6 mix=0|

	//var sig = SoundIn.ar([4,5],0.2);
	// voor morse 3 voor stem 5
	var sig = PlayBuf.ar(1, ~morse_sample_pick, BufRateScale.kr(~morse_sample_pick), 1, 0, loop: 1);
	var wetsig = PlayBuf.ar(1, ~morse_sample_pick, BufRateScale.kr(~morse_sample_pick) * LFNoise0.kr(3.2).range(0.48,0.54), 1, 0, loop: 1);
	wetsig = CombC.ar(wetsig, 0.25,0.25,5,0.3, wetsig * 0.7);
	sig = LPF.ar(sig, 9000, 1.2);
	//Pan2.ar(sig, SinOsc.kr(LFNoise0.kr(0.2).range(0.01,30.0)).range(-0.6,0.3));
	//Pan2.ar(PitchShift.ar(sig, 0.2, LFNoise1.kr(0.2).range(0.92,1.15),0.3,0.2);, SinOsc.kr(LFNoise0.kr(0.2).range(0.01,30.0)).range(0.6,-0.3));

	sig = [sig, PitchShift.ar(sig, 0.2, LFNoise1.kr(0.2).range(0.92,1.15),0.3,0.4);];
				sig = Mix(sig);
	wetsig = [wetsig, PitchShift.ar(sig, 0.2, LFNoise1.kr(0.2).range(0.92,1.15),0.3,0.4);];
				wetsig = Mix(wetsig);
	sig = (sig * (1 -mix)) + (wetsig * mix);
	sig = sig * amp;
				Pan2.ar(sig, SinOsc.kr(0.04).range(-0.2,0.2));

}).play(out:6);
	}, {
		"fading out morse sample".postln;
		Ndef(\sdr_morse).free;

	}); }
		{ num == 39 } {

			if ( val == 127, {

			if ( ~radio_sample_picker != (~radio_samples.size-1),
				{ ~radio_sample_picker = ~radio_sample_picker + 1; },
				{ ~radio_sample_picker = 0; });
			~radio_sample_picker.postln;
            ~radio_sample_pick = ~radio_samples[~radio_sample_picker];
			});


		}

	{ num == 47 } { if ( val == 127, {
			/*
			case
			{ ~scene == 0 } { ~radio_sample_pick = ~radio_samples[5]; }
			{ ~scene == 1 } { ~radio_sample_pick = ~radio_samples[6]; }
			{ ~scene == 2 } { ~radio_sample_pick = ~radio_samples[9]; }
			{ ~scene == 3 } { ~radio_sample_pick = ~radio_samples[10]; }
			{ ~scene == 4 } { ~radio_sample_pick = ~radio_samples[11]; };
			*/

			"fading in radio sample".postln;

Ndef(\sdr).fadeTime = 10;

Ndef(\sdr, {|amp=0.5 mix=0|

	//var sig = SoundIn.ar([4,5],0.2);
	// voor morse 3 voor stem 5
	var sig = PlayBuf.ar(1, ~radio_sample_pick, BufRateScale.kr(~radio_sample_pick), 1, 0, loop: 1);
	var wetsig = BufRd.ar(1, ~radio_sample_pick, LFNoise0.ar(0.8) * BufFrames.ir(~radio_sample_pick), 1, 2);
	sig = LPF.ar(sig, 9000, 1.2);
	sig = [sig, PitchShift.ar(sig, 0.2,0.95,0.1,0.0);];

				sig = Mix(sig);
	wetsig = [wetsig, PitchShift.ar(sig, 0.2, LFNoise1.kr(0.2).range(0.92,1.15),0.3,0.4);];
				wetsig = Mix(wetsig);
	sig = (sig * (1 -mix)) + (wetsig * mix);
				Pan2.ar(sig, SinOsc.kr(LFNoise1.kr(0.4).range(0.01,15.0)).range(-0.3,0.8));

}).play(out:6);
	}, {
		"fading out radio sample".postln;
		Ndef(\sdr).free;

	}); };



});

/*
MIDIdef.cc(\secondController, {|val, num, cc, chan|
		[val, num, cc, chan].postln;

		case
		/*
		{ num == 82 }
		{ ~phasemIndexBus.set(~phasemIndexSpec.map(val/127)); "setting phase index".postln; }
		{ num == 50 }
		{ ~relMul = ~relmulSpec.map(val/127); "increasing perc rel".postln; }
		*/
		{ num == 76 }
		{ if ( val == 127, { 	~fieldcricket = Synth(\fieldcricket, [\tfreqBus, ~fcricket_trigBus.index, \recout, ~anaBus], ~insects); }, { ~fieldcricket.set(\gate, 0); }); }
		{ num == 84 }
		{
			~fcricket_trigBus.set( ~fcrickets_trigSpec.map(val/127));
		}
		{ num == 77 }
		{ if ( val == 127, { 	~cicada_3calls = Synth(\cicada_3calls, [\tfreqBus, ~cicada_trigBus.index, \recout, ~anaBus], ~insects); }, { ~cicada_3calls.set(\gate, 0); }); }
		{ num == 85 }
		{
			~cicada_trigBus.set( ~cicada_trigSpec.map(val/127));
		}

		}, chan: 0);
*/


};
)



