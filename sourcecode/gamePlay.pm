package gamePlay;
use isMoveValid;
use helpMe;
use aiCalcMove;
use heavyLifting;
use strict;
use feature qw/say/;
no warnings;
my %hashBoard;
my $currentP = 1;
my %tmpHash;
my $globalPosition = 0;
my %movesHash;
my $playCompV = 0;
my @piecesAdd;
my @piecesRemove;
my @openP;
my $firstTime = 0;
my @pieces;
use 5.010;
{
    sub calcCompMoves{
	my @to         = aiCalcMove::calcCompMoves(\%hashBoard, \@piecesAdd, \@piecesRemove, \@openP, $firstTime, \@pieces);
	$firstTime     = $to[4];
	@piecesAdd     = @{ @to[1] };
	@piecesRemove  = @{ @to[2] } ;
	@openP         = @{ @to[3] };
	@pieces        = @{ @to[5] };
	return @{ @to[0] };
    }

    sub playGame{
	%hashBoard  = %{ $_[0] };
	%movesHash  = %{ $_[1] };
	$playCompV  = $_[2];
	@piecesAdd  = @{@_[3]}; 
	my $color   = "";
	my $over    = 0;
	my $doubleU = 0;
	my %redo;
	$currentP = $hashBoard{"turn"};
	$globalPosition = $hashBoard{"glob"};
	while(!$over){
	    $color = $hashBoard{"color"};
	    my $myCol = ($currentP == 1) ? 'b' : 'w';
	    say "Welcome player " . $currentP . " (" . $color . ")";
	    my $toM = "";
	    if ($hashBoard{"p1score"} == 12 or $hashBoard{"p2score"} == 12){
		my $otherP = ($currentP==1) ? 2 : 1;
		say "\n\nPlayer $otherP Wins by " . ($hashBoard{"p".$otherP."score"}-$hashBoard{"p".$currentP."score"}) . " points";
		$over=1;
	    }
	    else{
		if($doubleU){
		    $toM = 'u';
		    $doubleU = 0;
		}
		if(!($playCompV and $currentP == 2)){
		    print "Please enter a piece to move (e.g. b3) q to quit (help - h): ";
		    $toM = <>;
		    chomp $toM;
		    if($toM eq 'h') {
			helpMe::helpME(2);
		        print "Please enter a piece to move (e.g. b3) q to quit: ";
		        $toM = <>;
		        chomp $toM;
		    }	
		}
		if ($toM eq 'q'){
		    print "Quitting! Do you want to save? (y/n): ";
		    my $quitter = <>;
		    chomp $quitter;
		    if ($quitter eq 'y'){
			return(\%hashBoard, \%movesHash, 1);
		    }
		    exit;
		}
		elsif ($toM eq 'u' or $toM eq 'uu'){
		    #switch player back around and gig hashes about
		    $doubleU = ($toM eq 'uu')? 1 : 0;
		    if ($globalPosition==0){
			say "Cant undo any more";
		    }
		    else{
			%redo = %{$movesHash{"move".$globalPosition}};#this is the last move made so reverse it.
			#here re-write the hash board will work unless piece taken
			$hashBoard{substr($redo{"dest"}, length($redo{"dest"})-2, length($redo{"dest"}))} = "1";
			$hashBoard{$redo{"current"}} = $myCol;
			my $play = ($currentP==1) ? 2 : 1;
			if(length($redo{"taken"}) > 1){
			    #then a piece was taken, reverse this
			    #change to allow for double takes
			    my @replacePieces = split ' ', $redo{"taken"};
			    foreach(@replacePieces){
				say "Replacing: " . $_ . " with $color";
				$hashBoard{$_} = $color;
			    }
			    $hashBoard{("p".$play."score")} = $hashBoard{("p".$play."score")} - scalar(@replacePieces);   
			}
			#globalPosition array add pieces that should be removed and ones added
			push(@piecesAdd, $redo{"current"});
			push(@piecesRemove, substr($redo{"dest"}, length($redo{"dest"})-2, length($redo{"dest"})));
			delete $movesHash{"move".$globalPosition};
			$globalPosition--;
			heavyLifting::printBoard(%hashBoard);
			$currentP = ($currentP==1) ? 2 : 1;
		    }
		}
		elsif ($toM eq 'r' and %redo){
		    $globalPosition++;
		    $movesHash{"move".$globalPosition}= {%redo};
		    #%hashBoard = %{$movesHash{"move".$globalPosition}};
		    $hashBoard{substr($redo{"dest"}, length($redo{"dest"})-2, length($redo{"dest"}))} = $color;
		    my @replacePieces = split ' ', $redo{"taken"};
		    $hashBoard{("p".$currentP."score")} = $hashBoard{("p".$currentP."score")} + scalar(@replacePieces);   
		    if(length($redo{"taken"})>1){
			#then a piece was taken, reverse this
			#change to allow for double takes
			foreach(@replacePieces){
			    $hashBoard{$_} = "1";
			}
		    }
		    $hashBoard{$redo{"current"}} = "1";
		    undef %redo;
		    heavyLifting::printBoard(%hashBoard);
		    $currentP = ($currentP==1) ? 2 : 1;
		}
		elsif($toM eq 'r' and !%redo){
		    say "\nCan only redo once\n";
		}
		else{
		    undef %redo;
		    #how about if AI then dont do this, go down to movesArray and pass array of moves calculated 
		    my @movesArray;
		    if($playCompV == 0 or $currentP==1){
			my $loopBreak = 0;
			my $moveCount = 1;
			while(!$loopBreak){
			    print "Please enter destination (d for done) $moveCount: ";
			    my $dest = <>;
			    chomp $dest;
			    if($dest eq 'd'){
				$loopBreak = 1;
			    }
			    else{
				$moveCount++;
				push(@movesArray, $dest);
			    }
			}
		    }
		    else{
			#build an array here that holds the computers moves
			@movesArray = calcCompMoves();
			$toM = $movesArray[0];
			shift @movesArray;
		    }
		    my $counter = 0;
		    my $validMove = 0;
		    my $toM1 = $toM;
		    my $tmpa;
		    foreach(@movesArray){
			#currentP, Scores, HashBoard
			my $isPC    = ($playCompV == 1 and $currentP == 2) ? 1 : 0;
			my @attempt = isMoveValid::recursiveMove($_, $toM, \%hashBoard, $isPC);
			$validMove  = $attempt[0];
			%hashBoard  = %{$attempt[2]};
			$tmpa      .= " " . $attempt[3];
			$toM        = $movesArray[$counter];
			$counter++;
		    }
		    if ($validMove != 0){
			#add to moves hash here
			$globalPosition++;
			my %movehashnew = ("open" => "@openP", "current" => "$toM1", "dest" => "@movesArray", "scorew" => "$hashBoard{'p1score'}", "scoreb" => "$hashBoard{'p2score'}", "taken" => "$tmpa");
			$movesHash{"move".$globalPosition} = {%movehashnew};
			$currentP = ($currentP==1) ? 2 : 1;
			@piecesRemove = split ' ', $tmpa; 
		    }
		    heavyLifting::printBoard(%hashBoard);
		    if ($validMove != 0) {say "Last move was $toM1 to @movesArray\n\n";}	
		}
		$hashBoard{"color"} = ($currentP==1) ? 'w' : 'b';
		$hashBoard{"glob"} = $globalPosition;
		$hashBoard{"turn"} = $currentP; 
	    }
	}
	return(\%hashBoard, \%movesHash, 1);
    }
}
1;
