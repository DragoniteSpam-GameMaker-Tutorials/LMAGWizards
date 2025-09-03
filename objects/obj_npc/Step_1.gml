event_inherited();

if (keyboard_check_pressed(vk_enter)) {
    self.NavigateTo(random_range(-1000, 1000), 0, random_range(-1000, 1000));
}