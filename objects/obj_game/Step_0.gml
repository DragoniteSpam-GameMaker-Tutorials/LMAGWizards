Particles.BurstFromEmitter(Particles.emitters.test_effects, Particles.types.fire, 300, 0, 300, 4);

if (keyboard_check_pressed(vk_f1)) {
    Audio.SetVolumeMain(1)
}
if (keyboard_check_pressed(vk_f2)) {
    Audio.SetVolumeMain(0.5);
}