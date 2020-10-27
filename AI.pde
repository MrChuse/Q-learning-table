class AI {



  float[][][] qt;
  int states;
  int moves;

  int lastx;
  int lasty;

  float startE;
  float endE;
  float decayE;
  float epsilon;
  float lr;
  float discount;
  AI(int gridSize, int num_moves, float sE, float eE, float dE, float lr_, float dis) {
    qt = new float[gridSize][gridSize][num_moves];
    states = gridSize;
    moves = num_moves;
    initqt();

    startE = sE;
    epsilon = startE;
    endE = eE;
    decayE = dE;
    lr = lr_;
    discount = dis;
  }

  AI(int size) {
    qt = new float[size][size][4];
    states = size;
    moves = 4;
    initqt();

    startE = 1;
    epsilon = 1;
    endE = 0.;
    decayE = 0.0003;
    lr = 0.45;
    discount = 0.95;
  }

  void initqt() {
    for (int i = 0; i < states; i++) {
      for (int j = 0; j < states; j++) {
        for (int k = 0; k < moves; k++) {
          qt[i][j][k] = 0;//randomGaussian();
        }
      }
    }
  }

  int pickMove(Response r) {
    float e = random(1);
    if (e < epsilon) {
      lastx = r.x;
      lasty = r.y;
      return int(random(moves)); //pick random move if you want to observe the space
    }
    return pickBestMove(r);
  }

  int pickBestMove(Response r) {
    lastx = r.x;
    lasty = r.y;
    int m = 0;
    for (int i = 0; i < moves; i++) {
      if (qt[r.x][r.y][i] > qt[r.x][r.y][m]) { //pick the best move if you want to abuse the knowledge
        m = i;
      }
    }
    return m;
  }

  void updateTable(int move, Response r) {
    float calc = r.reward;
    if (r.x >=0 && r.y>=0 && r.x<states && r.y<states) {
      int maxq = 0;
      for (int i = 0; i < moves; i++) {
        if (qt[r.x][r.y][i] > qt[r.x][r.y][maxq]) {
          maxq = i;
        }
      }
      calc += discount * qt[r.x][r.y][maxq];
    }
    qt[lastx][lasty][move] = (1-lr)*qt[lastx][lasty][move] + lr*calc;//old
  }

  void updateEpsilon() {
    epsilon = max(endE, epsilon - decayE);
  }

  void showScores(PVector drawPlace, PVector drawSize, int SIZE) {
    for (int i = 0; i < states; i++) {
      for (int j = 0; j < states; j++) {
        for (int k = 0; k < moves; k++) {
          fill(0, 125);
          textSize(drawSize.y/SIZE/5);
          text(qt[i][j][k], drawPlace.x + i * drawSize.x / SIZE, drawPlace.y + (j +0.2) * drawSize.y / SIZE + k*drawSize.y / SIZE/5 );
        }
      }
    }
  }
}
