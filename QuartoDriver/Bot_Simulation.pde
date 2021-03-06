import processing.sound.*;

class BotSimulation {
  public Piece[] pieces;
  public Board board;
  public Piece selected;
  public boolean turn, over;
  public Primary[] primaries;
  public Particle[] particles;
  public int difficulty, gamesToPlay;

  public BotSimulation(int games, int fr, int diff) {
    rectMode(CENTER);
    float x, y, r;
    x = 2 * width / 3;
    y = height / 10;
    r = height / 7;
    pieces = new Piece[]{
      new Piece(true, true, true, true, x, y, 9 * r / 11), 
      new Piece(true, true, true, false, x + r, y, 9 * r / 11), 
      new Piece(true, true, false, true, x + 2 * r, y, 9 * r / 11), 
      new Piece(true, true, false, false, x + 3 * r, y, 9 * r / 11), 
      new Piece(true, false, true, true, x, y + r, 9 * r / 11), 
      new Piece(true, false, true, false, x + r, y + r, 9 * r / 11), 
      new Piece(true, false, false, true, x + 2 * r, y + r, 9 * r / 11), 
      new Piece(true, false, false, false, x + 3 * r, y + r, 9 * r / 11), 
      new Piece(false, true, true, true, x, y + 2 * r, 9 * r / 11), 
      new Piece(false, true, true, false, x + r, y + 2 * r, 9 * r / 11), 
      new Piece(false, true, false, true, x + 2 * r, y + 2 * r, 9 * r / 11), 
      new Piece(false, true, false, false, x + 3 * r, y + 2 * r, 9 * r / 11), 
      new Piece(false, false, true, true, x, y + 3 * r, 9 * r / 11), 
      new Piece(false, false, true, false, x + r, y + 3 * r, 9 * r / 11), 
      new Piece(false, false, false, true, x + 2 * r, y + 3 * r, 9 * r / 11), 
      new Piece(false, false, false, false, x + 3 * r, y + 3 * r, 9 * r / 11)
    };
    board = new Board();
    selected = new Piece(false, 8 * width / 9, 8 * height / 9, height / 6);
    turn = false;
    over = false;
    selected.setPlayed(true);

    primaries = new Primary[15];
    for (int i = 0; i < primaries.length; i++) {
      primaries[i] = new Primary(random(50, 150), new PVector(random(2 * width / 3 + 3 * height / 14 - 17 * height / 56, 2 * width / 3 + 3 * height / 14 + 17 * height / 56), random(height - (height / 10 + 3 * height / 34) - 17 * height / 112, height - (height / 10 + 3 * height / 34) + 17 * height / 112)), new PVector(random(-5, 5), random(-5, 5)));
    }
    particles = new Particle[15];
    for (int i = 0; i < particles.length; i++) {
      particles[i] = new Particle(new PVector(random(width / 5, 4 * width / 5), random(height / 5, 4 * height / 5)), new PVector(random(-10, 10), random(-10, 10)), new PVector(0, 0), random(50, 70));
    }
    difficulty = diff;
    gamesToPlay = games;
    frameRate(fr);
  }

  public void process() {
    if (!over) {
      background(0);
      //fill(random(255));
      //rect(2 * width / 3 + 3 * height / 14, height - (height / 10 + 3 * height / 34), 17 * height / 28, 17 * height / 56);
      for (Primary primary : primaries) {
        primary.update(); 
        //primary.show();
      }
      for (Particle particle : particles) {
        particle.update(primaries); 
        particle.show();
      }
      board.show();
      drawPieceMat();
      for (Piece piece : pieces) {
        piece.show();
      }
      selected.show();
      if (board.gameOver()) {
        if (turn) {
          bot1Wins++;
        } else {
          bot2Wins++;
        }
        over = true;
      } else if (board.tieGame()) {
        over = true;
      } else {
        if (selected.getSelection()) {
          if (turn) {
            botMove();
          } else {
            botMove();
          }
        } else {
          if (turn) {
            botSelect();
          } else {
            botSelect();
          }
        }
      }
      textSize(height / 20);
      fill(255);
      textAlign(LEFT);
      text("Bot Stats:", 11 * width / 20, 3 * height / 4);
      text("Bot 1: " + bot1Wins, 11 * width / 20, 3 * height / 4 + height / 19);
      text("Bot 2: " + bot2Wins, 11 * width / 20, 3 * height / 4 + 2 * height / 19);
      text("Tie Games: " + botTie, 11 * width / 20, 3 * height / 4 + 3 * height / 19);
      text("Game #" + botGames + "/" + gamesToPlay, 11 * width / 20, 3 * height / 4 + 4 * height / 19);
    } else {
      if (botGames < gamesToPlay) {
        botGames++;
        sim = new BotSimulation(gamesToPlay, 300, 0);
      } else {
        rectMode(CORNER);
        textAlign(LEFT);
        noStroke();
        noFill();
        frameRate(300);
        menu = 0;
      }
    }
  }

  void drawPieceMat() {
    fill(55, 0, 0);
    float x = 2 * width / 3 + 3 * height / 14;
    float y = height / 10 + 3 * height / 14;
    rect(x, y, 17 * height / 28, 17 * height / 28);
  }

  void botMove() {
    ArrayList<Integer> bestCells = new ArrayList<Integer>();
    int bestCellCost = Integer.MIN_VALUE;
    for (int i = 0; i < board.grid.length; i++) {
      for (int j = 0; j < board.grid[i].length; j++) {
        if (board.grid[i][j].piece == null) {
          int cellCost = testMove(board, selected, i, j);
          if (cellCost > bestCellCost) {
            bestCells.clear(); 
            bestCells.add(i * board.grid[i].length + j);
            bestCellCost = cellCost;
          } else if (cellCost == bestCellCost) {
            bestCells.add(i * board.grid[i].length + j);
          }
        }
      }
    }
    int cellToPlay = bestCells.get((int)random(bestCells.size()));
    board.play(selected, cellToPlay / board.grid[0].length, cellToPlay % board.grid[0].length);
    //piece_play[(int)random(piece_play.length)].play();
    selected.setSelection(false);
    for (int i = 0; i < pieces.length; i++) {
      if (pieces[i].equals(selected)) {
        pieces[i].setPlayed(true);
      }
    }
    turn = !turn;
  }

  void botSelect() {
    ArrayList<Integer> bestPieces = new ArrayList<Integer>();
    int bestPieceCost = Integer.MAX_VALUE;
    for (int i = 0; i < pieces.length; i++) {
      if (!pieces[i].getPlayed()) {
        int pieceCost = testPiece(board, pieces[i]);
        if (pieceCost < bestPieceCost) {
          bestPieces.clear(); 
          bestPieces.add(i);
          bestPieceCost = pieceCost;
        } else if (pieceCost == bestPieceCost) {
          bestPieces.add(i);
        }
      }
    }
    int pieceToSelect = bestPieces.get((int)random(bestPieces.size()));
    selected = pieces[pieceToSelect].copyAttributes(selected.x, selected.y, selected.r);
    selected.setSelection(true);
    pieces[pieceToSelect].setSelection(false);
  }

  int testPiece(Board b, Piece piece) {
    int sum = 0;
    for (int i = 0; i < b.grid.length; i++) {
      for (int j = 0; j < b.grid[i].length; j++) {
        if (b.grid[i][j].piece == null) sum += testMove(b, piece, i, j);
      }
    }
    return sum;
  }

  int testMove(Board b, Piece piece, int r, int c) {
    if (b.grid[r][c].piece != null) return Integer.MIN_VALUE;
    boolean horiz = true, verti = true, diagf = r == 3 - c, diagb = r == c;
    for (int i = 0; i < b.grid.length; i++) {//Assumes a Square Board
      if (horiz && i != c && b.grid[r][i].piece == null) horiz = false;
      if (verti && i != r && b.grid[i][c].piece == null) verti = false;
      if (diagf && i != r && b.grid[i][3 - i].piece == null) diagf = false;
      if (diagb && i != r && b.grid[i][i].piece == null) diagb = false;
    }
    boolean[] horizR = new boolean[0], vertiR = new boolean[0], diagfR = new boolean[0], diagbR = new boolean[0];
    if (horiz) {
      Piece[] row = new Piece[3];
      int index = 0;
      for (int i = 0; i < b.grid.length; i++) if (i != c) { 
        row[index] = b.grid[r][i].piece; 
        index++;
      }
      horizR = piece.compareToMultiple(row);
    }
    if (verti) {
      Piece[] col = new Piece[3];
      int index = 0;
      for (int i = 0; i < b.grid.length; i++) if (i != r) { 
        col[index] = b.grid[i][c].piece; 
        index++;
      }
      vertiR = piece.compareToMultiple(col);
    }
    if (diagf) {
      Piece[] diag = new Piece[3];
      int index = 0;
      for (int i = 0; i < b.grid.length; i++) if (i != r) { 
        diag[index] = b.grid[i][3 - i].piece; 
        index++;
      }
      diagfR = piece.compareToMultiple(diag);
    }
    if (diagb) {
      Piece[] diag = new Piece[3];
      int index = 0;
      for (int i = 0; i < b.grid.length; i++) if (i != r) { 
        diag[index] = b.grid[i][i].piece; 
        index++;
      }
      diagbR = piece.compareToMultiple(diag);
    }
    int sum = 0;
    for (boolean element : horizR) {
      if (element) sum++;
    }
    for (boolean element : vertiR) {
      if (element) sum++;
    }
    for (boolean element : diagfR) {
      if (element) sum++;
    }
    for (boolean element : diagbR) {
      if (element) sum++;
    }
    return sum;
  }
}