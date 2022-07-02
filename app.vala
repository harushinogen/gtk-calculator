public class Application : Gtk.Application {

    public Application () {
        Object (application_id: "com.yonon.calculator");
    }

    public override void activate () {
        new MainWindow (this).show ();
    }
}

public class MainWindow : Gtk.ApplicationWindow {

    Gtk.Text number;
    Gtk.Text operator_text;

    int ? operand_a = null;
    string ? operator = null;

    internal MainWindow (Application app) {
        Object (application: app, title: "Calculator");
        var grid = new Gtk.Grid ();

        this.set_child (grid);

        number = new Gtk.Text ();
        operator_text = new Gtk.Text ();
        number.show ();
        operator_text.show ();
        grid.attach (number, 0, 0, 3, 1);
        grid.attach (operator_text, 0, 1, 3, 1);

        addButton ("1", grid, 0, 2);
        addButton ("2", grid, 1, 2);
        addButton ("3", grid, 2, 2);
        addButton ("4", grid, 0, 3);
        addButton ("5", grid, 1, 3);
        addButton ("6", grid, 2, 3);
        addButton ("7", grid, 0, 4);
        addButton ("8", grid, 1, 4);
        addButton ("9", grid, 2, 4);
        addButton ("0", grid, 1, 5);

        int operator_row_start = 2;
        string[] operators = { "+", "-", "x", ":" };
        foreach (string a in operators) {
            var button = new Gtk.Button.with_label (a);
            button.clicked.connect (() => {
                operator_text.text = a;
                operand_a = int.parse (number.text);
            });
            button.show ();
            grid.attach (button, 3, operator_row_start, 1, 1);
            operator_row_start++;
        }

        var equaltoButton = new Gtk.Button.with_label ("=");
        equaltoButton.clicked.connect (() => {
            int operand_b = int.parse (operator_text.text);
            int result;
            if (operand_a != null && operator != null) {
                switch (operator) {
                    case "+":
                        result = operand_a + operand_b;
                        break;
                    case "-":
                        result = operand_a - operand_b;
                        break;
                    case "x":
                        result = operand_a * operand_b;
                        break;
                    default:
                        result = operand_a / operand_b;
                        break;
                }
                number.text = result.to_string ();
                operator_text.text = "=";
            }
        });
        equaltoButton.show ();

        grid.attach (equaltoButton, 2, 5, 1, 1);

        var clearButton = new Gtk.Button.with_label ("C");
        clearButton.clicked.connect (() => {
            number.text = "";
            operator_text.text = "";
            operator = null;
            operand_a = null;
        });
        clearButton.show ();

        grid.attach (clearButton, 0, 5, 1, 1);

        var exitButton = new Gtk.Button.with_label ("Close");
        exitButton.clicked.connect (() => {
            this.close ();
        });
        exitButton.show ();
        grid.attach (exitButton, 0, 6, 4, 1);

        grid.show ();
    }

    void addButton (string name, Gtk.Grid grid, int column, int row) {
        var button1 = new Gtk.Button.with_label (name);
        button1.clicked.connect (() => {
            if (operand_a == null) {
                number.text += name;
            } else if (operand_a != null && operator == null) {
                operator = operator_text.text;
                number.text = operand_a.to_string () + " " + operator;
                operator_text.text = name;
            } else {
                operator_text.text += name;
            }
        });
        button1.show ();
        grid.attach (button1, column, row, 1, 1);
    }
}

int main (string[] args) {
    var app = new Application ();
    return app.run (args);
}
