function ease_parabolic(start, finish, f, type) {
    var curve = animcurve_get(ac_parabola);
    var value = animcurve_channel_evaluate(curve.channels[animcurve_get_channel_index(curve, type)], f);
	return lerp(start, finish, value);
}