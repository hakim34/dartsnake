part of dartsnake;

/**
 * A [SnakeView] object interacts with the DOM tree
 * to reflect actual [SnakeGame] state to the user.
 */
class SnakeView {

  /**
   * Element with id '#warningoverlay' of the DOM tree.
   * Used to display general warnings
   * (e.g. connection to gamekey service could not be established).
   */
  final warningoverlay = querySelector("#warningoverlay");

  /**
   * Element with id '#overlay' of the DOM tree.
   * Used to display overlay forms.
   */
  final overlay = querySelector("#overlay");

  /**
   * Element with id '#title' of the DOM tree.
   * Shown only if game is not running.
   */
  final title = querySelector("#title");

  /**
   * Element with id '#welcome' of the DOM tree.
   * Shown only if game is not running.
   */
  final welcome = querySelector("#welcome");

  /**
   * Element with id '#snakegame' of the DOM tree.
   * Used to visualize the field of a [SnakeGame] as a HTML table.
   */
  final game = querySelector('#snakegame');

  /**
   * Element with id '#gameover' of the DOM tree.
   * Used to indicate that a game is over.
   */
  final gameover = querySelector('#gameover');

  /**
   * Element with id '#reasons' of the DOM tree.
   * Used to indicate why the game entered the game over state.
   */
  final reasons = querySelector('#reasons');

  /**
   * Element with id '#points' of the DOM tree.
   * Used to indicate how many points a user has actually collected.
   */
  final points = querySelector('#points');

  /**
   * Start button of the game.
   */
  HtmlElement get startButton => querySelector('#start');

  /**
   * Contains all TD Elements of the field.
   */
  List<List<HtmlElement>> fields;

  /**
   * Updates the view according to the [model] state.
   *
   * - [startButton] is shown according to the stopped/running state of the [model].
   * - [points] are updated according to the [model] state.
   * - [gameover] is shown when [model] indicates game over state.
   * - Game over [reasons] ([model.snake] tangled or off field) are shown when [model] is in game over state.
   * - Field is shown according to actual field state of [model].
   */
  void update(SnakeGame model) {

    welcome.style.display = model.stopped ? "block" : "none";
    // title.style.display = model.stopped? "block" : "none";

    points.innerHtml = "Points: ${model.miceCounter}";
    gameover.innerHtml = model.gameOver ? "Game Over" : "";
    reasons.innerHtml = "";
    if (model.gameOver) {
      final tangled = model.snake.tangled ? "Do not tangle your snake<br>" : "";
      final onfield = model.snake.notOnField ? "Keep your snake on the field<br>" : "";
      reasons.innerHtml = "$tangled$onfield";
    }

    // Updates the field
    final field = model.field;
    for (int row = 0; row < field.length; row++) {
      for (int col = 0; col < field[row].length; col++) {
        final td = fields[row][col];
        if (td != null) {
          td.classes.clear();
          if (field[row][col] == #mouse) td.classes.add('mouse');
          else if (field[row][col] == #snake) td.classes.add('snake');
          else if (field[row][col] == #empty) td.classes.add('empty');
        }
      }
    }
  }

  /**
   * Generates the field according to [model] state.
   * A HTML table (n x n) is generated and inserted
   * into the [game] element of the DOM tree.
   */
  void generateField(SnakeGame model) {
    final field = model.field;
    String table = "";
    for (int row = 0; row < field.length; row++) {
      table += "<tr>";
      for (int col = 0; col < field[row].length; col++) {
        final assignment = field[row][col];
        final pos = "field_${row}_${col}";
        table += "<td id='$pos' class='$assignment'></td>";
      }
      table += "</tr>";
    }
    game.innerHtml = table;

    // Saves all generated TD elements in field to
    // avoid time intensive querySelector calls in update().
    // Thanks to Johannes Gosch, SoSe 2015.
    fields = new List<List<HtmlElement>>(field.length);
    for (int row = 0; row < field.length; row++) {
      fields[row] = [];
      for (int col = 0; col < field[row].length; col++) {
        fields[row].add(game.querySelector("#field_${row}_${col}"));
      }
    }
  }

  /**
   * Shows the highscore form and save option for the user.
   */
  void showHighscore(SnakeGame model) {

    if (overlay.innerHtml != "") return;

    final score = model.miceCounter;

    overlay.innerHtml =
      "<div id='highscore'>"
      "   <h1>Highscore</h1>"
      "   You got $score points."
      "</div>"
      "<form id='highscoreform'>"
      "<input type='text' id='user' placeholder='user'>"
      "<input type='password' id='pwd' placeholder='password'>"
      "<button type='button' id='save'>Save</button>"
      "<button type='button' id='close'>Close</button>"
      "</form>";
  }

  /**
   * Closes a form (e.g. highscore form).
   */
  void closeForm() => overlay.innerHtml = "";

}