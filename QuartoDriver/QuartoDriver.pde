int menu = 0;
Button startMultiplayer, startBots, startTutorial, easyDiff, mediDiff, hardDiff, closeTutorial;

MultiplayerGame mpg;
BotGame bots;

SoundFile[] piece_play;
SoundFile piece_selected, piece_deselected, piece_changed, victory, defeat, tie_game;

void setup() {
  fullScreen();
  loadResc();
  startMultiplayer = new Button("Play Multiplayer", new PVector(width / 4, height / 4), 100, #469928, #000000, #469928, #ffffff);
  startBots = new Button("Play Against a Bot", new PVector(width / 4, height / 3), 100, #469928, #000000, #469928, #ffffff);
  startTutorial = new Button("How to Play", new PVector(width / 4, height / 2), 100, #469928, #000000, #469928, #ffffff);
}

void draw() {
  if (menu == 0) {
    drawMenu();
  } else {
    if (menu == 1) {
      mpg.process();
    } else if (menu == 2) {
      bots.process();
    }
  }
}

void keyTyped() {
  if (key == 'r' || key == 'R') {
    rectMode(CORNER);
    textAlign(LEFT);
    noStroke();
    noFill();
    menu = 0;
  }
}

void mousePressed() {
  switch(menu) {
  case 0:
    if (startMultiplayer.clicked()) {
      mpg = new MultiplayerGame(); 
      menu = 1;
    }
    if (startBots.clicked()) {
      bots = new BotGame(true, 0); 
      menu = 2;
    }
    break;
  case 1:
    boolean play = false;
    boolean deselect = false;
    boolean select = false;
  Playing:
    if (mpg.selected.getSelection()) {
      for (int i = 0; i < mpg.board.grid.length; i++) {
        for (int j = 0; j < mpg.board.grid[i].length; j++) {
          if (mpg.board.grid[i][j].piece == null && mpg.board.grid[i][j].clicked()) {
            mpg.board.play(mpg.selected, i, j);
            mpg.selected.setSelection(false);
            for (int k = 0; k < mpg.pieces.length; k++) {
              if (mpg.pieces[k].equals(mpg.selected)) {
                mpg.pieces[k].setPlayed(true);
              }
            }
            mpg.turn = !mpg.turn;
            play = true;
            break Playing;
          }
        }
      }
    }
  Deselecting:
    if (mpg.selected.getSelection()) {
      for (int i = 0; i < mpg.pieces.length; i++) {
        if (mpg.pieces[i].equals(mpg.selected)) {
          mpg.pieces[i].setSelection(true);
          mpg.selected.setSelection(false);
          deselect = true;
          break Deselecting;
        }
      }
    }
  Selecting:
    for (int i = 0; i < mpg.pieces.length; i++) {
      if (!mpg.pieces[i].getPlayed() && mpg.pieces[i].clicked()) {
        mpg.selected = mpg.pieces[i].copyAttributes(mpg.selected.x, mpg.selected.y, mpg.selected.r);
        mpg.selected.setSelection(true);
        mpg.pieces[i].setSelection(false);
        select = true;
        break Selecting;
      }
    }
    if (!mpg.over) {
      if (play) {
        piece_play[(int)random(piece_play.length)].play();
      } else {
        if (select && deselect) {
          piece_changed.play();
        } else if (select) {
          piece_selected.play();
        } else if (deselect) {
          piece_deselected.play();
        }
      }
    }
    break;
  case 2:
    play = false;
    select = false;
  Playing:
    if (bots.selected.getSelection()) {
      for (int i = 0; i < bots.board.grid.length; i++) {
        for (int j = 0; j < bots.board.grid[i].length; j++) {
          if (bots.board.grid[i][j].piece == null && bots.board.grid[i][j].clicked()) {
            bots.board.play(bots.selected, i, j);
            bots.selected.setSelection(false);
            for (int k = 0; k < bots.pieces.length; k++) {
              if (bots.pieces[k].equals(bots.selected)) {
                bots.pieces[k].setPlayed(true);
              }
            }
            bots.turn = !bots.turn;
            play = true;
            break Playing;
          }
        }
      }
    }
  Selecting:
    if (bots.turn != bots.humanFirst) {
      for (int i = 0; i < bots.pieces.length; i++) {
        if (!bots.pieces[i].getPlayed() && bots.pieces[i].clicked()) {
          bots.selected = bots.pieces[i].copyAttributes(bots.selected.x, bots.selected.y, bots.selected.r);
          bots.selected.setSelection(true);
          bots.pieces[i].setSelection(false);
          select = true;
          break Selecting;
        }
      }
      if (!bots.over) {
        if (play) {
          piece_play[(int)random(piece_play.length)].play();
        } else {
          if (select) {
            piece_selected.play();
          }
        }
        break;
      }
    }
  }
}

void loadResc() {
  piece_play = new SoundFile[4];
  piece_play[0] = new SoundFile(this, "quarto_piece_play_1.wav");
  piece_play[1] = new SoundFile(this, "quarto_piece_play_2.wav");
  piece_play[2] = new SoundFile(this, "quarto_piece_play_3.wav");
  piece_play[3] = new SoundFile(this, "quarto_piece_play_4.wav");
  piece_selected = new SoundFile(this, "quarto_piece_selected.mp3");
  piece_deselected = new SoundFile(this, "quarto_piece_deselected.mp3");
  piece_changed = new SoundFile(this, "quarto_piece_changed.mp3");
  victory = new SoundFile(this, "victory_sound.mp3");
  defeat = new SoundFile(this, "defeat_sound.mp3");
  tie_game = new SoundFile(this, "tie_game_sound.mp3");
  piece_selected.rate(0.5);
  piece_deselected.rate(0.5);
  piece_changed.rate(0.5);
  tie_game.rate(0.5);
}

void drawMenu() {
  background(0);
  startMultiplayer.show();
  startBots.show();
  startTutorial.show();
}