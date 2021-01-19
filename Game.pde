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

  void reset() {
    prevx = initialx;
    prevy = initialy;
    playerx = initialx;
    playery = initialy;
  }

  void show() {
    showGrid();
    showPlayer();
  }

  void showGrid() {
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

  void showPlayer() {
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

  Response step(int move) {
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

  Response getState() {
    r.x = playerx;
    r.y = playery;
    r.end = false;
    r.reward = 0;
    return r;
  }

  void move(int m) {
    if (m == 0)playerx++;
    else if (m == 1) playery++;
    else if (m == 2) playerx--;
    else playery--;
  }

  boolean checkEnd() {
    return (playerx >= SIZE || playery >= SIZE || playerx < 0 || playery < 0) || 
      (grid[playerx][playery] == 2 || grid[playerx][playery] == 3);
  }

  int getReward() {
    if ((playerx >= SIZE || playery >= SIZE || playerx < 0 || playery < 0) || 
      grid[playerx][playery] == 2) {
      return -100;
    } else if (grid[playerx][playery] == 1) {
      return -1;
    } else return 100;
  }
}
