extends Node2D

func playMusic():
	if !$MusicPlayer2D.playing:
		$MusicPlayer2D.play()
