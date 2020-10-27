Game g;
AI ai;
Response r1;
int epochs;
int appState;
boolean bestMove;

PVector gamePosition = new PVector(0, 0);
PVector gameSize = new PVector(1000, 900);

void setup() {

  randomSeed(15);
  size(1200, 900);
  g = new Game(gamePosition, gameSize);
  ai = new AI(g.SIZE);
  epochs = 0;
  r1 = g.getState();
  appState = AppState.stop;
  bestMove = false;

  background(255);
  g.show();
  drawSidebar();
  ai.showScores(gamePosition, gameSize, g.SIZE);
}

void draw() {
  background(255);
  g.show();
  drawSidebar();
  ai.showScores(gamePosition, gameSize, g.SIZE);
  if (appState != AppState.stop) {
    if (frameCount%2 == 0) {
      int move;
      if (bestMove) {
        move = ai.pickBestMove(r1);
      } else {
        move = ai.pickMove(r1);
      }
      r1 = g.step(move);
      ai.updateTable(move, r1);
      
      if (r1.end == true) {
        epochs++;
        g.reset();
        ai.updateEpsilon();
        r1 = g.getState();

        if (appState == AppState.doOneEpoch) {
          appState = AppState.stop;
        }
      }
      
      if (appState == AppState.doOneMove){
        appState = AppState.stop;
      }
    }
  }
}

void mousePressed() {
  if (mouseX > gamePosition.x + gameSize.x) {
    if (mouseY < 100) {
      setup();
    } else if (mouseY < 200) {
      appState = AppState.doOneEpoch;
    } else if (mouseY < 300) {
      appState = AppState.doEpochs;
    } else if (mouseY < 400) {
      appState = AppState.doOneMove;
    } else if (mouseY < 500) {
      appState = AppState.stop;
    } else if (mouseY < 600){
      bestMove = !bestMove;
    }
  }
  redraw();
}
