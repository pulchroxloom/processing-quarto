class Piece {
  private boolean selection, played, tall, round, dark, holed;
  public float x, y, r;

  public Piece(Piece piece) {
    selection = piece.selection;
    played = piece.played;
    tall = piece.tall;
    round = piece.round;
    dark = piece.dark;
    holed = piece.holed;
  }

  public Piece(boolean t, boolean r, boolean d, boolean h, float x, float y, float rad) {
    selection = true;
    played = false;
    tall = t;
    round = r;
    dark = d;
    holed = h;
    this.x = x;
    this.y = y;
    this.r = rad;
  }

  public Piece(boolean s, float x, float y, float rad) {
    selection = s;
    played = false;
    tall = false;
    round = false;
    dark = false;
    holed = false;
    this.x = x;
    this.y = y;
    r = rad;
  }

  public Piece copyAttributes(float x, float y, float r) {
    return new Piece(tall, round, dark, holed, x, y, r);
  }

  public boolean clicked() {
    if (tall) {
      if (round) {
        return Math.hypot(mouseX - x, mouseY - y) < r / 2 || Math.hypot(mouseX - (x - r / 10), mouseY - (y + r/ 10)) < r / 2;
      } else {
        return (x - r / 2 < mouseX && mouseX < x + r / 2 && y - r / 2 < mouseY && mouseY < y + r / 2) || ((x - r / 10) - r / 2 < mouseX && mouseX < (x - r / 10) + r / 2 && (y + r / 10) - r / 2 < mouseY && mouseY < (y + r / 10) + r / 2);
      }
    } else {
      if (round) {
        return Math.hypot(mouseX - x, mouseY - y) < r / 2;
      } else {
        return x - r / 2 < mouseX && mouseX < x + r / 2 && y - r / 2 < mouseY && mouseY < y + r / 2;
      }
    }
  }

  public boolean getPlayed() {
    return played;
  }

  public boolean setPlayed(boolean b) {
    boolean ret = played == b;
    played = b;
    return ret;
  }

  public boolean getSelection() {
    return selection;
  }

  public boolean setSelection(boolean b) {
    boolean ret = selection == b;
    selection = b;
    return ret;
  }

  public boolean equals(Piece other) {
    boolean[] comparison = compareTo(other);
    for (boolean element : comparison) {
      if (!element) {
        return false;
      }
    }
    return true;
  }

  public boolean[] compareTo(Piece other) {
    boolean[] comparison = {tall == other.tall, round == other.round, dark == other.dark, holed == other.holed};
    return comparison;
  }

  public boolean[] compareToMultiple(Piece[] others) {
    boolean t = true, r = true, d = true, h = true;
    int index = 0;
    while (index < others.length && (t || r || d || h)) {//800 IQ Loop
      t = t && tall == others[index].tall;
      r = r && round == others[index].round;
      d = d && dark == others[index].dark;
      h = h && holed == others[index].holed;
      index++;
    }
    boolean[] comparison = {t, r, d, h};
    return comparison;
  }

  public void show() {
    if (selection) {
      if (dark) {
        fill(51, 32, 0);
      } else {
        fill(229, 219, 209);
      }
      if (tall) {
        if (round) {
          ellipse(x - r / 10, y + r / 10, r, r);
        } else {
          rect(x - r / 10, y + r / 10, r, r);
          line(x - 6 * r / 10, y - 4 * r / 10, x - r / 2, y - r / 2);
          line(x + 4 * r / 10, y + 6 * r / 10, x + r / 2, y + r / 2);
          line(x - 6 * r / 10, y + 6 * r / 10, x - r / 2, y + r / 2);
        }
      }
      if (round) {
        ellipse(x, y, r, r);
      } else {
        rect(x, y, r, r);
      }
      if (holed) {
        fill(26, 26, 26);
        ellipse(x, y, r / 2, r / 2);
      }
    }
  }

  @Override
    public String toString() {
    String ret = "";
    if (dark) {
      ret += "dark  ";
    } else {
      ret += "light ";
    }
    if (round) {
      ret += "round  ";
    } else {
      ret += "square ";
    }
    if (holed) {
      ret += "holed ";
    } else {
      ret += "solid ";
    }
    if (tall) {
      ret += "tall  ";
    } else {
      ret += "small ";
    }
    ret += x + " " + y + " " + r;
    return ret;
  }
}