class RandomNickName {
  final List<String> randomNicknames = [
    'MOVIE BUFF',
    'CINEPHILE',
    'FILM GEEK',
    'SCREEN STAR',
    'POPCORN LOVER',
    'TRAILER TRACKER',
    'REEL ENTHUSIAST',
    'SCRIPT CRITIC',
    'BLOCKBUSTER FAN',
    'SCENE STEALER',
    'DIRECTOR\'S CUT',
    'CASTING QUEEN',
    'FLICK FANATIC',
    'PLOT TWIST',
    'CINEMA SNOB',
    'TICKET STUB',
    'ACTION HERO',
    'ROM-COM ROYALTY',
    'SCI-FI SAVVY',
    'ADVENTUROUS SPIRIT',
    'SMILING SOUL',
    'ETERNAL OPTIMIST',
    'JOYFUL WANDERER',
    'KINDHEARTED COMPANION',
    'CARING FRIEND',
    'CREATIVE DREAMER',
    'RADIANT ENERGY',
    'PLAYFUL EXPLORER',
    'SINCERE LISTENER',
    'CURIOUS MIND',
    'POSITIVE VIBES',
    'HARMONIOUS HEART',
    'ENTHUSIASTIC DREAMER',
    'BRAVE VOYAGER',
    'GENUINE SMILE',
    'EMPATHETIC HEART',
    'RESILIENT SOUL',
    'INQUISITIVE THINKER',
    'FREE SPIRIT'
  ];

  String generateRandomNickname() {
    return randomNicknames[
        DateTime.now().millisecondsSinceEpoch % randomNicknames.length];
  }
}
