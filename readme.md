# Untitled Wizard Game, a 3D Zelda-Like made in GameMaker

It's time for another episodic game dev series, this time aiming for something a little more ambitious than the last two! Let's make a game about wizards using magic spells to explore the world.

The video playlist can be found here:

[![YouTube playlist](https://i.ytimg.com/vi/dgCHs9LFCwo/hqdefault.jpg)](https://www.youtube.com/playlist?list=PL_hT--4HOvrcG5ktEta4PUjPTVRE3ohk7)

I try to post about a video a week. If I miss a week for one reason or another, I may try to catch up later as to not delay the thing longer than it has to be.

I'm using a project management system called Codecks; [you can view the board here](https://open.codecks.io/lmag-magic-school).

## Releases

If you're following the series, I'm creating a release each week so that the state of the project at the end of a video can be marked. Each release has two numbers - a major and a minor version number - with each week being the minor version number. This means that the Week 1 project will be 0.1, Week 5 will be 0.5, Week 12 will be 0.12, etc.

The game receives a "1.0" release upon completion.

## Building

This project was built using **GameMaker Studio 2.** Currently I'm using whatever monthly version is most recent as of my recording a video, and sometimes a beta if there's a feature or bug fix that I need. As the project nears completion it's likely that I'll pick a stable version and stick with it, most likely a future LTS edition.

## Credits

I'm using a few more external extensions than usual this time around.

 - [Luminous Chickens](https://dragonite.itch.io/luminous-chicken-3d-lighting-shaders-for-gamemaker) - a lighting shader collection that I assembled based on past tutorials (with some fancy bells and whistles)
 - [Input](https://github.com/JujuAdams/Input) is an input manager written by Juju Adams and Alynne Keith
 - [Scribble](https://github.com/JujuAdams/scribble) by Juju for text effects
 - [Chatterbox](https://github.com/JujuAdams/Chatterbox) by Juju as a way to deal with narrative and cutscenes
 - [SnowState](https://github.com/sohomsahaun/SnowState) is a very nice finite state machine system written by Sohom Sahaun
 - [spart](https://forum.yoyogames.com/index.php?threads/spart-3d-particle-system-new-update-sept-2019-now-entirely-free.52130/) by TheSnidr
 - [Penguin](https://dragonite.itch.io/penguin) is a program I wrote to convert 3D model files into vertex buffers; I'm using it to load models into the game and do a few other things like setting their collision information.