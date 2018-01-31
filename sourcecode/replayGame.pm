package replayGame;
use strict;
use heavyLifting;
no warnings;
use feature qw/say/;
my %movesHash;
my %hashBoard;
my $currentP = "b";
my @crowned;
{
    sub isInArray{
	foreach(@crowned){
	    if($_ eq @_[0]){
		return 1;
	    }
	}
	return 0;
    }

    sub repG{
	%movesHash = %{ $_[0] };
	%hashBoard = heavyLifting::bHash;#%{ $_[0]{"move0"} };
	#get whos count firsti
	#how about score
        my $counter = 1;	
	heavyLifting::printBoard(%hashBoard);
	foreach my $index (sort keys %movesHash){
	    my $tidyDest = substr($movesHash{"move".$counter}{"dest"}, length($movesHash{"move".$counter}{"dest"}) -2, 2);
	    print "\n\nPress enter to see next move: ";
	    my $inp = <>;
	    if(substr($tidyDest, length($tidyDest)-1, 1) ~~ [8, 1]){
		push(@crowned, $tidyDest);
		$currentP = ($currentP ~~ ['w', 'W'] ) ? 'B' : 'W';
	    }
	    else{
		
	        $currentP = ($currentP ~~ ['w', 'W']) ? 'b' : 'w';
	    }
	    if(isInArray($movesHash{"move".$counter}{"current"})){
		#remove it from array and add new position
		my $rem = 0;
		$rem++ until $crowned[$rem] eq $movesHash{"move".$counter}{"current"};
		splice(@crowned, $rem, 1);
		push(@crowned, $tidyDest);
		$currentP = ($currentP ~~ ['b', 'B']) ? 'B' : 'W';
	    }
	    $hashBoard{$movesHash{"move".$counter}{"current"}} = 1;	
	    #if current in crowned then remove it and add dest
	    $hashBoard{$tidyDest} = $currentP;
	    if (length($movesHash{"move".$counter}{"taken"}) >= 2){
		#split on space into string and replace both
		foreach(split ' ', $movesHash{"move".$counter}{"taken"}){
		    $hashBoard{$_} = 1;
		}
	    }
	    $hashBoard{"p1score"} = $movesHash{"move".$counter}{"scorew"};
	    $hashBoard{"p2score"} = $movesHash{"move".$counter}{"scoreb"};
	    heavyLifting::printBoard(%hashBoard);
	    $counter++;
	}
	say "\n\nReplay Over";
    }
}
1;
