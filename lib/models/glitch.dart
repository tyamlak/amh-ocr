class Glitch {
	String message;
	Glitch(this.message);

	String toString() => message;
}

class EmptyCacheGlitch extends Glitch {
	EmptyCacheGlitch(String message):super(message);
}