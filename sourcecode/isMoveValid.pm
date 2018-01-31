package isMoveValid;
no warnings;
use feature qw/say/;
use Data::Dumper;
{
    sub recursiveMove{
	my $dest          = $_[0];
	my $toM           = $_[1];
        my %hashBoard     = %{$_[2]};
        my $comp          = $_[3];
	my $color         = $hashBoard{"color"};
        my $currentP      = $hashBoard{"turn"};
        my $newCoord      = "";
	my $dirtyFlag     = 0;
	my $badFlag       = 0;
	my $opponentC     = ($currentP==1) ? 'b' : 'w';
	my $jumpAttempted = 0;
	my $king          = 0;
        my @taken;

	if ($hashBoard{$toM} ~~ ['W', 'B']){
	    $king = 1;
	    $color = ($hashBoard{$toM} eq 'W')? 'W' : 'B';
	}
	if($hashBoard{$toM} ne $color and $hashBoard{$toM} ne (uc $color)){
	    #stop moving other players pieces
            if($comp!=1) {say "You can only move you're own color";}
	 }
	elsif($hashBoard{$dest} eq '0'){
	    #stops moving onto white squares
	    if($comp!=1) {say "You can only move on black squares";}
	}
	elsif($color eq 'w' and (substr($dest, 1, 1) < substr($toM, 1, 1)) and !$king){
	    #stops white moving backwards
	    if($comp!=1) {say "Cannot move backwards unless king";}
	}
	elsif($color eq 'b' and (substr($dest, 1, 1) > substr($toM, 1, 1)) and !$king){
	    #stops black moving backwards
	    if($comp!=1) {say "Cannot move backwards unless king";}
	}
	elsif($hashBoard{$dest} ne '1'){
	    #if dest has a piece on it
	    if($comp!=1) {say "Cannot move onto another piece";}
	}
	else{
	    $badFlag = 1;
	    if (($color eq 'w' or $king) and substr($dest,1,1) - substr($toM,1,1) > 1){
		$jumpAttempted = 1;
		if (ord(substr($dest, 0, 1)) > ord(substr($toM, 0, 1))){
		    #if white and moving right
		    $newCoord = chr(ord(substr($toM, 0, 1))+1) . (substr($toM, 1, 1) + 1);
		}
		if (ord(substr($dest, 0, 1)) < ord(substr($toM, 0, 1))){
		   #if white and moving left
		   $newCoord = chr(ord(substr($toM, 0, 1))-1) . (substr($toM, 1, 1) + 1);
		}
	    }
	    if(($color eq 'b' or $king) and substr($toM,1,1) - substr($dest,1,1) > 1){#and jump attempted must be added so if differnce is > 1
		$jumpAttempted = 1;
		if (ord(substr($dest, 0, 1)) > ord(substr($toM, 0, 1))){
		    #if black and moving right
		    $newCoord = chr(ord(substr($toM, 0, 1))+1) . (substr($toM, 1, 1) - 1);
		}
		if (ord(substr($dest, 0, 1)) < ord(substr($toM, 0, 1))){
		   #if black and moving left
		   $newCoord = chr(ord(substr($toM, 0, 1))-1) . (substr($toM, 1, 1) - 1);
		}
	    }
	    if(($hashBoard{$newCoord} eq $opponentC or $hashBoard{$newCoord} eq (uc $opponentC)) and $jumpAttempted==1){
		$hashBoard{$newCoord} = '1'; #remove the taken piece
		push(@taken, $newCoord);
                if($comp != 1){
		    say "Piece Taken!";
                }
                if($currentP==1){
		    $hashBoard{"p1score"} = $hashBoard{"p1score"} + 1;
		}
		else{
		    $hashBoard{"p2score"} = $hashBoard{"p2score"} + 1;
		}
	    }
	    elsif (($hashBoard{$newCoord} ne $opponentC and $hashBoard{$newCoord} ne (uc $opponentC)) and $jumpAttempted==1){
		if ($comp != 1) {say "Move Invalid - illegal jump";}
		$dirtyFlag = 1;
		$badFlag = 0;
	    }
	    if (!$dirtyFlag){
		$hashBoard{$toM} = '1';
		$hashBoard{$dest} = $color;
		#add if become king
		if($color eq 'w' and substr($dest,1,1) == 8){
		    $hashBoard{$dest} = 'W';
		}
		if($color eq 'b' and substr($dest, 1, 1) == 1){
		    $hashBoard{$dest} = 'B';
		}
	    }
	}
	return ($badFlag, $color, \%hashBoard, @taken);
    }
}
1;
