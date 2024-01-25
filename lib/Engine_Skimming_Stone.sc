Engine_Skimming_Stone : CroneEngine {
// All norns engines follow the 'Engine_MySynthName' convention above

	var params;

	alloc { //no capatal input, and only have ',' '.' ':' '?' marks.
		//for 'w', 'a', 'z', 'p', ':', '.'
		SynthDef(\da, {
			var snd;
			snd = SinOscFB.ar(\freq.kr(300) + LFNoise2.ar(\freq.kr(300), \dither.kr(0))
				+ SinOsc.ar(\freq.kr(300)*5.5, mul: XLine.ar(1, \m1.kr(0.8), mul: \freq.kr(300)*\m2.kr(0)))
				* (1+ SinOsc.ar(\freq.kr(300) / 2, mul: \m2.kr(0)))
				, [0.15, 0.18], XLine.ar(1, \m1.kr(0.8), [0.08, 0.04]));
			snd = snd * Env.perc(0.01, \rls.kr(1.2), exprand(\m1.kr(0.8), 1)).ar(Done.freeSelf);
			snd = BHiShelf.ar(snd, 2800, 1.5, \stone.kr(0) * 2);
			snd = BLowShelf.ar(snd, 280, 0.8, 0.3 - \stone.kr(0) * 12);
			snd = snd.tanh;
			snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
			snd = snd * -6.dbamp;
			Out.ar(0, snd);
		}).add;

		//for 'e', 's', 'x', 'o', 'l', ','
		SynthDef(\ka, {
			var snd;
			snd = SinOscFB.ar(\freq.kr(300) + LFNoise2.ar(\freq.kr(300), \dither.kr(0))
				+ SinOsc.ar(\freq.kr(300)*[6, 3.3], mul: \m1.kr(0.02))
				+ SinOscFB.ar(\freq.kr(300)*[12, 8.8], [0.05, 0.08], mul: Env.perc(0.01, \m2.kr(0)/100, \m2.kr(0)).ar),
				Env.perc(0.01, 0.3, 0.3).ar);
			snd = snd * Env.perc(0.01, \rls.kr(1.2), exprand(0.8, 1)).ar(Done.freeSelf);
			snd = BHiShelf.ar(snd, 2800, 1.5, \stone.kr(0) * 2);
			snd = BLowShelf.ar(snd, 280, 0.8, 0.3 - \stone.kr(0) * 12);
			snd = snd.tanh;
			snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
			snd = snd * -6.dbamp;
			Out.ar(0, snd);
		}).add;

		//for 'r', 'd', 'c', 'i', 'k', 'm'
		SynthDef(\yea, {
			var snd, mod, modmod;
			modmod = SinOsc.ar(\freq.kr(300)*[9.5, 9.6], mul: \m2.kr(0));
			mod = SinOsc.ar(\freq.kr(300)*[0.5, 0.5001] + modmod, mul: Env.perc(\atk.kr(0.01), \rls.kr(1.2), \m1.kr(0)).ar);
			snd = SinOsc.ar(\freq.kr(300) + mod + LFNoise2.ar(\freq.kr(300), \dither.kr(0)));
			snd = snd * Env.perc(\atk.kr(0.01), \rls.kr(1.2), exprand(0.8, 1)).ar(Done.freeSelf);
			snd = BHiShelf.ar(snd, 2800, 1.5, \stone.kr(0) * 2);
			snd = BLowShelf.ar(snd, 280, 0.8, 0.3 - \stone.kr(0) * 12);
			snd = snd.tanh;
			snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
			snd = snd * -6.dbamp;
			Out.ar(0, snd);
		}).add;

		//for 't', 'f', 'v', 'u', 'j', 'n'
		SynthDef(\re, {
			var snd;
			snd = SinOscFB.ar(
				(\freq.kr(300) + LFNoise2.ar(\freq.kr(300), \dither.kr(0)))
				* (1 + Env.perc(\atk.kr(0.01), \rls.kr(1.2), \m1.kr(0)).ar)
			, Env.perc(0.01, 0.3, 0.2).ar);
			snd = snd + (Env.perc(\atk.kr(0.01), \rls.kr(1.2), \m1.kr(0)).ar * BPF.ar(Hasher.ar(Sweep.ar + [1, 3]), [XLine.kr(2300, 6000, 0.7), XLine.kr(2200, 6000, 0.6)], 0.5) * -20.dbamp);
			snd = snd * Env.perc(\atk.kr(0.01), \rls.kr(1.2), exprand(0.8, 1)).ar(Done.freeSelf);
			snd = BHiShelf.ar(snd, 2800, 1.5, \stone.kr(0) * 2);
			snd = BLowShelf.ar(snd, 280, 0.8, 0.3 - \stone.kr(0) * 12);
			snd = snd.tanh;
			snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
			snd = snd * -6.dbamp;
			Out.ar(0, snd);
		}).add;

		//for 'y', 'g', 'h', 'b'
		SynthDef(\dong, {
			var snd;
			snd = SinOsc.ar(
				(\freq.kr(60) + LFNoise2.ar(\freq.kr(60), \dither.kr(0)))
				* (1 + (\m1.kr(0.3) * Env.perc(0.0, 0.05, curve: -4).ar))
				* (1 + (\m2.kr(0.1) * Env.perc(0.001, 0.4, curve: -4).ar))
					, mul: 1.006).fold2;
			snd = snd + (Env.perc(0.001, 0.01).ar * BPF.ar(Hasher.ar(Sweep.ar + [1, 3]), \m1.kr(0.3)*800, \m2.kr(0.1)) * 8.dbamp);
			snd = BHiShelf.ar(snd, 3000, 2.5, \stone.kr(0) * 2);
			snd = BLowShelf.ar(snd, 100, 0.8, 0.3);
			snd = snd.tanh;
			snd = snd * Env.perc(0.001, \rls.kr(0.8), exprand(0.8, 1)).ar(Done.freeSelf);
			snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
			snd = snd * -6.dbamp;
			Out.ar(0, snd);
		}).add;

		//for 'q', '?'
		SynthDef(\guang, {
			var snd, fire;
			fire = Env.perc(\atk.kr(0.01), \rls.kr(1.2), \m1.kr(0)).ar;
			snd = SinOscFB.ar(\freq.kr(300) * (1 + fire)  + LFNoise2.ar(\freq.kr(300), \dither.kr(0)), [0.4 + fire/2, 0.6 + fire/2]);
			snd = snd * Env.perc(\atk.kr(0.01), \rls.kr(1.2), [exprand(0.8, 1), exprand(0.8, 1)]).ar(Done.freeSelf);
			snd = BHiShelf.ar(snd, 3000, 1.5, \stone.kr(0));
			snd = BLowShelf.ar(snd, 100, 1, 0.3 - \stone.kr(0) * 2);
			snd = snd.tanh;
			snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
			snd = snd * -6.dbamp;
			Out.ar(0, snd)
		}).add;

		//for ' '(blankspace)
		SynthDef(\kong, {
			var snd;
			snd = SinOscFB.ar(\freq.kr(77), 0.1, 1);
			snd = snd * Env.perc(\atk.kr(0.01), \rls.kr(0.12)).ar(Done.freeSelf);
			snd = Pan2.ar(snd, \pan.kr(0));
			snd = snd.tanh;
			snd = snd * -6.dbamp;
			Out.ar(0, snd);
		}).add;

  // We don't need to sync with the server in this example,
  //   because were not actually doing anything that depends on the SynthDef being available,
  //   so let's leave this commented:
  // Server.default.sync;
		
  // let's create an Dictionary (an unordered associative collection)
  //   to store parameter values, initialized to defaults.
		params = Dictionary.newFrom([
			\sub_div, 2,
			\noise_level, 0.1,
			\cutoff, 8000,
			\resonance, 3,
			\attack, 0,
			\release, 0.4,
			\amp, 0.5,
			\pan, 0;
		]);

  // "Commands" are how the Lua interpreter controls the engine.
  // The format string is analogous to an OSC message format string,
  //   and the 'msg' argument contains data.

  // We'll just loop over the keys of the dictionary, 
  //   and add a command for each one, which updates corresponding value:
		params.keysDo({ arg key;
			this.addCommand(key, "f", { arg msg;
				params[key] = msg[1];
			});
		});

  // This is faster than (but similar to) individually defining each command, eg:
		// this.addCommand("amp", "f", { arg msg;
		//	  amp = msg[1];
		// });

  // The "hz" command, however, requires a new syntax!
  // ".getPairs" flattens the dictionary to alternating key,value array
  //   and "++" concatenates it:
		this.addCommand("da", "fffffff", { arg msg;
			Synth.new("da", [\freq: msg[1], \dither: msg[2], \m1: msg[3], \m2: msg[4], \rls: msg[5], \pan:msg[6], \stone: msg[7]] ++ params.getPairs)
		});

		this.addCommand("ka", "fffffff", { arg msg;
			Synth.new("ka", [\freq: msg[1], \dither: msg[2], \m1: msg[3], \m2: msg[4], \rls: msg[5], \pan:msg[6], \stone: msg[7]] ++ params.getPairs)
		});

		this.addCommand("yea", "ffffffff", { arg msg;
			Synth.new("yea", [\freq: msg[1], \dither: msg[2], \m1: msg[3], \m2: msg[4], \atk: msg[5], \rls: msg[6], \pan:msg[7], \stone: msg[8]] ++ params.getPairs)
		});

		this.addCommand("re", "fffffff", { arg msg;
			Synth.new("re", [\freq: msg[1], \dither: msg[2], \m1: msg[3], \atk: msg[4], \rls: msg[5], \pan:msg[6], \stone: msg[7]] ++ params.getPairs)
		});

		this.addCommand("guang", "fffffff", { arg msg;
			Synth.new("guang", [\freq: msg[1], \dither: msg[2], \m1: msg[3], \atk: msg[4], \rls: msg[5], \pan:msg[6], \stone: msg[7]] ++ params.getPairs)
		});
		
		this.addCommand("dong", "fffffff", { arg msg;
			Synth.new("dong", [\freq: msg[1], \dither: msg[2], \m1: msg[3], \m2: msg[4], \rls: msg[5], \pan:msg[6], \stone: msg[7]] ++ params.getPairs)
		});

		this.addCommand("kong", "f", { arg msg;
			Synth.new("kong", [\freq, msg[1]] ++ params.getPairs)
		});

	}

}