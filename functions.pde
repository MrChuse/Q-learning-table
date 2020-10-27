void drawEpochs(){
  fill(0);
  textSize(32);
  text(epochs+" epochs", gamePosition.x + gameSize.x, 600);
}

void drawRetry() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 0, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("retry", gamePosition.x + gameSize.x, 40);
}
void drawOneEpoch() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 100, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("one epoch", gamePosition.x + gameSize.x, 140);
}

void drawDoEpochs() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 200, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("do epochs", gamePosition.x + gameSize.x, 240);
}

void drawDoOneMove() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 300, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("one move", gamePosition.x + gameSize.x, 340);
}

void drawStop() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 400, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("stop", gamePosition.x + gameSize.x, 440);
}

void drawBestMove() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 500, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("best?", gamePosition.x + gameSize.x, 540);
  text(str(bestMove), gamePosition.x + gameSize.x, 580);
}

void drawSidebar(){
  drawEpochs();
  drawRetry();
  drawOneEpoch();
  drawDoEpochs();
  drawDoOneMove();
  drawStop();
  drawBestMove();
}
