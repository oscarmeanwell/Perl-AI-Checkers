use replayGame;
use helpMe;
use persist;
use gamePlay;
use heavyLifting;
use strict;
use feature qw/say/;
no warnings;
my %hashBoard;
my %movesHash;
my $playCompV = 0;
my @globA;
my $replay = 0;
use 5.010;

sub playGame{
    heavyLifting::printBoard(%hashBoard);
    my @returned = gamePlay::playGame(\%hashBoard, \%movesHash, $playCompV, \@globA); 
    %hashBoard = %{ $returned[0] };
    %movesHash = %{ $returned[1] };
    if ($returned[2] == 1) {saveGame();}
    $playCompV = 0;
}

sub replayGame{
    say "replay";
    replayGame::repG(\%movesHash);
}
sub loadGame{
    my %has = persist::loadGame();
    if($replay) {
	%hashBoard = %{$has{"Board"}};
	%movesHash = %{$has{"Moves"}};
	replayGame();
	$replay=0;
    }
    elsif(!($has{"Board"}{"computer"} ~~ [1,0, '1', '0'])){
	newGame();
    }
    else{
	%hashBoard = %{$has{"Board"}};
	%movesHash = %{$has{"Moves"}};
	if($hashBoard{"computer"} == 1){
	    $playCompV = 1;
	    @globA = split ' ', $movesHash{"move".$hashBoard{"glob"}}{"open"};
	}
	playGame();
    }
}

sub newGame{
    %hashBoard = heavyLifting::bHash;
    playGame();
}

sub saveGame{
    my %hashT;
    $hashT{"Board"} = {%hashBoard};
    $hashT{"Moves"} = {%movesHash};
    persist::saveGame(%hashT);
}

sub playComp{
    say "Playing Computer";
    $playCompV = 1;
    %hashBoard = heavyLifting::bHash;
    $hashBoard{"computer"} = 1;
    playGame();
}
#if json not installed, install it.
eval("require JSON") || heavyLifting::installJ(); 


while(1){
    say "\nWelcome to Perl Checkers!";
    say "\n\t To Load game - 1";
    say "\t For New Game - 2";
    say "\t  Replay game - 3";
    say "\t     For help - 4";
    say "\t    For rules - 5";
    say "\t     To Exit  - 6";
    print "\nChoice: ";
    my $input = <>;
    if ($input == 1){
        loadGame();
    }
    elsif ($input == 2){
        my $loopBreak = 0;
	while(!$loopBreak){
	    say "\n\n\tFor two player - 1";
	    say "\tTo play PC - 2";
	    print "\n\nChoice: ";
	    $input = <>;
	    if ($input == 1){
                $loopBreak = 1;
		newGame();
	    }
	    elsif ($input == 2){
                $loopBreak = 1;
		playComp();
	    }
	    else{
		say "\n\nPlease enter a valid input.";
	    }
	}
    }
    elsif ($input == 3){
	$replay = 1;
	loadGame();
    }
    elsif ($input == 4){
        helpMe::helpME(0);
    }
    elsif ($input == 5){
        helpMe::helpME(1);
    }
    elsif($input == 6){
	say "\nQuitting\n";
	exit;
    }
    else{
        say "\n\nPlease enter a valid input";
    }
}
