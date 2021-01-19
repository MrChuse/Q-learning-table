Game g;
AI ai;
Response r1;
int epochs;
State state = new State();

PVector gamePosition = new PVector(0, 0);
PVector gameSize = new PVector(800, 800);

void setup() {
  randomSeed(15);
  size(1000, 900);
  g = new Game(gamePosition, gameSize);
  ai = new AI(g.SIZE);
  epochs = 0;
  r1 = g.getState();
}

int divider = 10;
void draw() {
  background(255);
  g.show();
  drawSidebar();
  ai.showScores(gamePosition, gameSize, g.SIZE);
  if (state.state != state.waiting && frameCount%divider == 0) {
    moveAI(state);
  }
}


void mousePressed() {
  if (mouseX > gamePosition.x+gameSize.x) {
    if (mouseY < 100) {
      g.reset();
      r1 = g.getState();
    } else if (mouseY < 200) {
      state.state = state.movingOnce;
    } else if (mouseY < 300) {
      state.state = state.epochOnce;
    } else if (mouseY < 400) {
      state.state = state.epochUntilStop;
    } else if (mouseY < 500) {
      if (state.state == state.epochUntilStop)
        state.state = state.epochOnce;
      else 
      state.state = state.waiting;
    } else if(mouseY < 550){
      divider = int(map(mouseX,gamePosition.x+gameSize.x, width, 1,50));
    }
    
  }
}
