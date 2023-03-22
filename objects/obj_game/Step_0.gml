Particles.BurstFromEmitter(Particles.emitters.test_effects, Particles.types.fire, 300, 0, 300, 4);

if (keyboard_check_pressed(vk_f1)) {
    Audio.SetVolumeMain(1)
}
if (keyboard_check_pressed(vk_f2)) {
    Audio.SetVolumeMain(0.5);
}

if (keyboard_check_pressed(vk_f3)) {
    Audio.SetVolumeFX(1)
}
if (keyboard_check_pressed(vk_f4)) {
    Audio.SetVolumeFX(0.5);
}

if (keyboard_check_pressed(vk_f5)) {
    Audio.SetVolumeMusic(1)
}
if (keyboard_check_pressed(vk_f6)) {
    Audio.SetVolumeMusic(0.5);
}

if (keyboard_check_pressed(vk_tab)) {
    Audio.PlayFX(se_test);
}