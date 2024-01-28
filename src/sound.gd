class_name Sound
extends AudioStreamPlayer


func play_sound(sound: AudioStream):
	stream = sound
	play()
	
	await finished
	queue_free()
