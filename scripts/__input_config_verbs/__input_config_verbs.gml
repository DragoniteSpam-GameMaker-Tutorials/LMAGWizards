//Input defines the default profiles as a macro called 
//This macro is parsed when Input boots up and provides the baseline bindings for your game
//
//  Please edit this macro to meet the needs of your game!
//
//The root struct called __input_config_verbs() contains the names of each default profile
//Default profiles then contain the names of verbs. Each verb should be given a binding that is
//appropriate for the profile. You can create bindings by calling one of the input_binding_*()
//functions, such as input_binding_key() for keyboard keys and input_binding_mouse() for
//mouse buttons

return {
    
    keyboard_and_mouse:
    {
        up:         [input_binding_key(vk_up),          input_binding_key("W")],
        down:       [input_binding_key(vk_down),        input_binding_key("S")],
        left:       [input_binding_key(vk_left),        input_binding_key("A")],
        right:      [input_binding_key(vk_right),       input_binding_key("D")],
        
        action:     [input_binding_key(vk_enter),       input_binding_key("E")],
        back:       [input_binding_key(vk_backspace),   input_binding_key(vk_tab)],
        cast:       [input_binding_key("C"),            input_binding_mouse_button(mb_left)],
        jump:       [input_binding_key(vk_space),       input_binding_mouse_button(mb_right)],
        
        run:        input_binding_key(vk_shift),
        
        pause:      input_binding_key(vk_escape),
    },
    
    gamepad:
    {
        up:         [input_binding_gamepad_axis(gp_axislv, true),  input_binding_gamepad_button(gp_padu)],
        down:       [input_binding_gamepad_axis(gp_axislv, false), input_binding_gamepad_button(gp_padd)],
        left:       [input_binding_gamepad_axis(gp_axislh, true),  input_binding_gamepad_button(gp_padl)],
        right:      [input_binding_gamepad_axis(gp_axislh, false), input_binding_gamepad_button(gp_padr)],
        
        action:     input_binding_gamepad_button(gp_face1),
        back:       [input_binding_gamepad_button(gp_face2),        input_binding_gamepad_button(gp_select)],
        special:    input_binding_gamepad_button(gp_face3),
        jump:       input_binding_gamepad_button(gp_face4),
        
        run:        [input_binding_gamepad_button(gp_shoulderlb), input_binding_gamepad_button(gp_shoulderrb)],
        pause:      input_binding_gamepad_button(gp_start),
        
        aim_up:     input_binding_gamepad_axis(gp_axisrv, true),
        aim_down:   input_binding_gamepad_axis(gp_axisrv, false),
        aim_left:   input_binding_gamepad_axis(gp_axisrh, true),
        aim_right:  input_binding_gamepad_axis(gp_axisrh, false),
        
    }
};