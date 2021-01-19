import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Q_learning__table__v0_3 extends PApplet {

Game g;
AI ai;
Response r1;
int epochs;
State state = new State();

PVector gamePosition = new PVector(0, 0);
PVector gameSize = new PVector(800, 800);

public void setup() {
  randomSeed(15);
  
  g = new Game(gamePosition, gameSize);
  ai = new AI(g.SIZE);
  epochs = 0;
  r1 = g.getState();
}

int divider = 10;
public void draw() {
  background(255);
  g.show();
  drawSidebar();
  ai.showScores(gamePosition, gameSize, g.SIZE);
  if (state.state != state.waiting && frameCount%divider == 0) {
    moveAI(state);
  }
}


public void mousePressed() {
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
      divider = PApplet.parseInt(map(mouseX,gamePosition.x+gameSize.x, width, 1,50));
    }
    
  }
}
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
    endE = 0.f;
    decayE = 0.0003f;
    lr = 0.45f;
    discount = 0.95f;
  }

  public void initqt() {
    for (int i = 0; i < states; i++) {
      for (int j = 0; j < states; j++) {
        for (int k = 0; k < moves; k++) {
          qt[i][j][k] = 0;//randomGaussian();
        }
      }
    }
  }

  public int pickMove(Response r) {
    lastx = r.x;
    lasty = r.y;
    float e = random(1);
    if (e < epsilon) {
      return PApplet.parseInt(random(moves)); //pick random move if you want to observe the space
    }
    int m = 0;
    for (int i = 0; i < moves; i++) {
      if (qt[r.x][r.y][i] > qt[r.x][r.y][m]) { //pick the best move if you want to abuse the knowledge
        m = i;
      }
    }
    return m;
  }

  public void updateTable(int move, Response r) {
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

  public void updateEpsilon() {
    epsilon = max(endE, epsilon - decayE);
  }

  public void showScores(PVector drawPlace, PVector drawSize, int SIZE) {
    for (int i = 0; i < states; i++) {
      for (int j = 0; j < states; j++) {
        for (int k = 0; k < moves; k++) {
          fill(0, 125);
          textSize(drawSize.y/SIZE/5);
          text(qt[i][j][k], drawPlace.x + i * drawSize.x / SIZE, drawPlace.y + (j +0.2f) * drawSize.y / SIZE + k*drawSize.y / SIZE/5 );
        }
      }
    }
  }
}
class Game {
  int prevx;
  int prevy;
  int playerx;
  int playery;

  final int initialx = 0;
  final int initialy = 0;

  int SIZE = 8;
  int[][] grid = {
    {1, 1, 1, 2, 1, 1, 2, 1}, 
    {1, 2, 1, 1, 1, 1, 1, 1}, // 1 - (-1) reward
    {1, 2, 2, 2, 2, 1, 2, 1}, // 2 - die, -100 reward
    {1, 1, 2, 1, 2, 2, 1, 1}, // 3 - win, 100 reward
    {1, 1, 1, 1, 2, 1, 1, 1}, 
    {1, 2, 2, 2, 2, 2, 2, 1}, 
    {1, 1, 2, 1, 1, 1, 2, 1}, 
    {2, 1, 1, 1, 2, 1, 1, 3}
  };

  PVector drawPlace, drawSize;

  Response r = new Response();

  Game(PVector drawPlace, PVector size) {
    this.drawPlace = drawPlace;
    this.drawSize = size;
    reset();
  }

  public void reset() {
    prevx = initialx;
    prevy = initialy;
    playerx = initialx;
    playery = initialy;
  }

  public void show() {
    showGrid();
    showPlayer();
  }

  public void showGrid() {
    for (int i = 0; i < SIZE; i++) {
      for (int j = 0; j < SIZE; j++) {
        if (i == initialx && j == initialy) {
          fill(255, 255, 0);
        } else if (grid[i][j] == 1) {
          fill(0, 255, 0);
        } else if (grid[i][j] == 2) {
          fill(255, 0, 0);
        } else fill(0, 0, 255);
        rect(drawPlace.x + i * drawSize.x / SIZE, drawPlace.y + j * drawSize.y / SIZE, drawSize.x / SIZE, drawSize.y / SIZE);
      }
    }
  }

  public void showPlayer() {
    fill(255);
    /*float x = map(frameCount%divider, 0, divider,
                  drawPlace.x + prevx * drawSize.x / SIZE + drawSize.x / SIZE / 3,
                  drawPlace.x + playerx * drawSize.x / SIZE + drawSize.x / SIZE / 3);
    float y = map(frameCount%divider, 0, divider,
                  drawPlace.y + prevy * drawSize.y / SIZE + drawSize.y / SIZE / 3,
                  drawPlace.y + playery * drawSize.y / SIZE + drawSize.y / SIZE / 3);*/
    float x = drawPlace.x + playerx * drawSize.x / SIZE + drawSize.x / SIZE / 3;
    float y = drawPlace.y + playery * drawSize.y / SIZE + drawSize.y / SIZE / 3;
    rect(x, y, drawSize.x / SIZE / 3, drawSize.y / SIZE / 3);
  }

  public Response step(int move) {
    prevx = playerx;
    prevy = playery;
    move(move);
    boolean end = checkEnd();
    int reward = getReward();
    r.x = playerx;
    r.y = playery;
    r.end = end;
    r.reward = reward;
    return r;
  }

  public Response getState() {
    r.x = playerx;
    r.y = playery;
    r.end = false;
    r.reward = 0;
    return r;
  }

  public void move(int m) {
    if (m == 0)playerx++;
    else if (m == 1) playery++;
    else if (m == 2) playerx--;
    else playery--;
  }

  public boolean checkEnd() {
    return (playerx >= SIZE || playery >= SIZE || playerx < 0 || playery < 0) || 
      (grid[playerx][playery] == 2 || grid[playerx][playery] == 3);
  }

  public int getReward() {
    if ((playerx >= SIZE || playery >= SIZE || playerx < 0 || playery < 0) || 
      grid[playerx][playery] == 2) {
      return -100;
    } else if (grid[playerx][playery] == 1) {
      return -1;
    } else return 100;
  }
}
class State{
  int state = 0;
  final int waiting = 0;
  final int movingOnce = 1;
  final int epochOnce = 2;
  final int epochUntilStop = 3;
}
public void drawEpochs() {
  fill(0);
  textSize(32);
  text(epochs+" epochs", gamePosition.x + gameSize.x, 600);
}

public void drawReset() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 0, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("reset", gamePosition.x + gameSize.x, 40);
}

public void drawOneMove() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 100, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("move once", gamePosition.x + gameSize.x, 140);
}

public void drawOneEpoch() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 200, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("one epoch", gamePosition.x + gameSize.x, 240);
}

public void drawDoEpochs() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 300, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("do epochs", gamePosition.x + gameSize.x, 340);
}

public void drawStop() {
  fill(100);
  rect(gamePosition.x + gameSize.x, 400, width - gamePosition.x + gameSize.x, 100);
  fill(255);
  textSize(40);
  text("stop", gamePosition.x + gameSize.x, 440);
}

public void drawDivider() {
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

public void drawState() {
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

public void drawSidebar() {
  drawReset();
  drawOneMove();
  drawOneEpoch();
  drawDoEpochs();
  drawStop();
  drawDivider();
  drawEpochs();
  drawState();
}

public void moveAI(State state) {
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
class Response{
  int x = 0;
  int y = 0;
  boolean end = false;
  int reward = 0;
}
  public void settings() {  size(1000, 900); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Q_learning__table__v0_3" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
