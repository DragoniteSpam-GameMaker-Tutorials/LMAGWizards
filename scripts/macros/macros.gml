#macro FILE_AUDIO_SETTINGS "options_audio.json"
#macro FILE_VIDEO_SETTINGS "options_video.json"

#macro SOUND_PRIORITY_DEFAULT       100
#macro SOUND_PRIORITY_MUSIC         200
#macro SOUND_PRIORITY_AMBIENT        50

#macro DT                           (game_get_speed(gamespeed_microseconds) / 1_000_000 * obj_game.time_scale)
#macro PDT							(game_get_speed(gamespeed_microseconds) / 1_000_000)