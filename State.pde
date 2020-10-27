class State{
  int waiting = 0;
  int movingOnce = 1;
  int epochOnce = 2;
  int epochUntilStop = 3;
}

class AppState{
  static final int stop = 0;
  static final int doEpochs = 1;
  static final int doOneEpoch = 2;
  static final int doOneMove = 3;
}
