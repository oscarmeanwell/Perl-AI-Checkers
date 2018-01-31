package helpMe;
no warnings;
use feature qw/say/;
{
    sub helpME{
        $tracker = @_[0];
        if($tracker==0){
           print "\nThis is the main menu. From here you can press\none to load a game or press two to create a new game.";
           print "\nIf this is your first time here, press 2.\n\n";
        }
	if($tracker==1){
	    #Not really help, well I guess it is.
	    #done here to keep main code clean
	    say "\n\t - You may only move on black spaces";
	    say "\t - You may only move forwards unless your piece is a king";
	    say "\t - You must take by jumping over a piece diagonally";
	    say "\t - You cannot land on another piece";
	    say "\t - Taking is not enforced, take when you want or dont want";
	    say "\t - If you cannot move, the other person wins";
	    say "\t - If your piece reaches the other end of the board it";
	    say "\t   is crowned and becomes a king. Meaning it can move in";
	    say "\t   any direction so long as its diagnonal";
	    say "\t - If playing the computer and you want to undo type uu";
	} 
	elsif ($tracker==2){
	    say "\n\nu for undo, r for redo, uu for double undo if playing computer.";
	    print "Enter a start coordinate and press enter followed\nby a destination coordinate. If you want to double jump,\nenter start coordinate press enter, destination following\nfirst jump press enter, and the final destination and press enter.\n\n";
	}
    }

}
1;
