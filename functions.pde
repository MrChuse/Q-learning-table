void drawEpochs() {
  fill(0);
  textSize(32);
  text(epochs+" epochs", gamePosition.x + gameSize.x, 600);
}

void drawReset() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 0, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("reset", gamePosition.x + gameSize.x, 40);
}

void drawOneMove() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 100, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("move once", gamePosition.x + gameSize.x, 140);
}

void drawOneEpoch() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 200, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("one epoch", gamePosition.x + gameSize.x, 240);
}

void drawDoEpochs() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 300, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("do epochs", gamePosition.x + gameSize.x, 340);
}

void drawStop() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 400, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("stop", gamePosition.x + gameSize.x, 440);
}

void drawDivider() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 500, width - gamePosition.x + gameSize.x, 50);
  fill(255);
  textSize(40);
  text(divider, (gamePosition.x + gameSize.x + width)/2 - 15, 540);
  float xdivider = map(divider, 1, 50, gamePosition.x+gameSize.x, width);
  stroke(127); 
  line(xdivider, 500, xdivider, 550);
  stroke(0);
}

void drawState() {
  fill(0);
  textSize(32);
  String s = "";
  if (state.state == state.waiting) {
    s = "waiting";
  } else if (state.state == state.movingOnce) {
    s = "moving once";
  } else if (state.state == state.epochOnce) {
    s = "doing one epoch";
  } else if (state.state == state.epochUntilStop) {
    s = "doing epochs until stop";
  }
  text(s, gamePosition.x + gameSize.x, 640);
}

void drawSidebar() {
  drawReset();
  drawOneMove();
  drawOneEpoch();
  drawDoEpochs();
  drawStop();
  drawDivider();
  drawEpochs();
  drawState();
}

void moveAI(State state) {
  int move = ai.pickMove(r1);
  r1 = g.step(move);
  ai.updateTable(move, r1);
  if (r1.end == true) {
    epochs++;
    g.reset();
    ai.updateEpsilon();
    r1 = g.getState();
    if (state.state == state.epochOnce) {
      state.state = state.waiting;
    }
  }
  if (state.state == state.movingOnce) {
    state.state = state.waiting;
  }
}
