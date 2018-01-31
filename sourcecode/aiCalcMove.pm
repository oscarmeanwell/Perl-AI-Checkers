package aiCalcMove;
use List::Util 'shuffle';
use isMoveValid;
use strict;
no warnings;
use 5.010;
{
    sub calcCompMoves{
	#func to calc and return an array of the computers moves.
	#this builds an initial array of pieces which can be moved when the game is started.
	my %hashBoard    = %{ $_[0] };
	my $firstTime    = $_[4];
	my @piecesAdd    = @{ @_[1] };
        my @piecesRemove = @{ @_[2] }; 
	my @openP        = @{ @_[3] }; 
	my @pieces       = @{ @_[5] }; 
        my $toM          = "";
	if ($firstTime == 0 and scalar(@piecesAdd) == 0){
	    foreach(keys %hashBoard){
		$firstTime = 1;
		#if loaded first time get movable peices
		if (substr($_, 1, 1) eq '6' and $hashBoard{$_} ~~ ['B','b']){
		    push(@pieces, $_);
		}
	    }    	
	}
	#hard array should try every piece and move the one with the best move
	if(scalar(@piecesRemove) > 0){
	    #add a undo piece back in
	   foreach my $x(@piecesRemove){
	       my $toSplice = 0;
	       foreach(@pieces){
		   if($pieces[$toSplice] eq $x){
		       splice(@pieces, $toSplice, 1); #remove the pice thats been moved
		   }
		   $toSplice++;
	       }
	   }
	   undef @piecesRemove;
	}
	if(scalar(@piecesAdd) > 1){
	   foreach(@piecesAdd){
	       if(length($_) > 1){
		   push(@pieces, $_);
	       }
	   }
	   undef @piecesAdd;
	}
	my @shuffledM = shuffle(@pieces);#this ensure unpredictability.
	my $score = 0;
	my $faveMove = "";
	my $doubleJump = "";
	my $start = "";
	my $doubleJStart = "";
	my %lossMoves;
	foreach my $cPiece (@shuffledM){
	    if(length($cPiece) > 1){
		my @movesToTry;
		#now create an array of all the possible places that piece could move to. 
		#Then loop through it, passing it to IsMoveValid and whatever gets the 
		#how about calculate the next move, i.e. is a piece a danger spot.	
		if($hashBoard{$cPiece} eq 'B'){
		    #ensures pc unalises king
		    my $kingLeft = chr(ord(substr($cPiece, 0, 1))-1)  . (substr($cPiece, 1, 1)+1);
		    my $kingRight = chr(ord(substr($cPiece, 0, 1))+1)  . (substr($cPiece, 1, 1)+1);
		    my $kingRightJump = chr(ord(substr($cPiece, 0, 1))+2)  . (substr($cPiece, 1, 1)+2);
		    my $kingLeftJump = chr(ord(substr($cPiece, 0, 1))-2)  . (substr($cPiece, 1, 1)+2);
		    push(@movesToTry, $kingLeft, $kingRight, $kingRightJump, $kingLeftJump);
		}
		my $moveLeft = chr(ord(substr($cPiece, 0, 1))-1)  . (substr($cPiece, 1, 1)-1);
		my $moveRight = chr(ord(substr($cPiece, 0, 1))+1)  . (substr($cPiece, 1, 1)-1);
		my $moveRightJump = chr(ord(substr($cPiece, 0, 1))+2)  . (substr($cPiece, 1, 1)-2);
		my $moveLeftJump = chr(ord(substr($cPiece, 0, 1))-2)  . (substr($cPiece, 1, 1)-2);
		push(@movesToTry, $moveLeft, $moveRight, $moveRightJump, $moveLeftJump);
		foreach my $tryD(@movesToTry){
		    my @ai = isMoveValid::recursiveMove($tryD, $cPiece, \%hashBoard, 1);
		    my %hashT = %{$ai[2]};
		    if($ai[0] != 0 and $hashT{"p2score"} > $score){
			#if take, try and then double take
			$faveMove = $tryD; #gets fave desti
			$start = $cPiece;
			$score = $hashT{"p2score"};
			my @doubleJumps;
			if($hashBoard{$cPiece} eq 'B'){
			    my $coordRJ21 = chr(ord(substr($tryD, 0, 1))+2)  . (substr($tryD, 1, 1)+2);
			    my $coordLJ21 = chr(ord(substr($tryD, 0, 1))-2)  . (substr($tryD, 1, 1)+2);
			    push(@doubleJumps, $coordRJ21, $coordLJ21);
			}
			my $coordRJ2 = chr(ord(substr($tryD, 0, 1))+2)  . (substr($tryD, 1, 1)-2);
			my $coordLJ2 = chr(ord(substr($tryD, 0, 1))-2)  . (substr($tryD, 1, 1)-2);
			push(@doubleJumps, $coordRJ2, $coordLJ2);
			foreach my $desti(@doubleJumps){
			    #make the move or try to
			    my @ai2 = isMoveValid::recursiveMove($desti, $tryD, \%hashT, 1);
			    #if the double jump is valid, store it.
			    if($ai2[0] != 0 and $hashT{"p2score"} > $hashBoard{"p2score"}){
				#then a double jump is possible, return coord
				$doubleJump = $desti;
				$doubleJStart = $tryD;        
			    }
			}
		    }
		   elsif ($ai[0] != 0 and $hashT{"p2score"} >= $score){
			#the game will take even if it means getting taken
			#however here we need to say only move to a piece where we wont get taken
			my $c1 = chr(ord(substr($tryD, 0, 1))-1) .(substr($tryD, 1, 1)-1); #up and left
			my $c2 = chr(ord(substr($tryD, 0, 1))+1) .(substr($tryD, 1, 1)+1); #down and right, so if 1
			my $c3 = chr(ord(substr($tryD, 0, 1))-1) .(substr($tryD, 1, 1)+1); #up and left
			my $c4 = chr(ord(substr($tryD, 0, 1))+1) .(substr($tryD, 1, 1)-1); #down and right, so if 1
			if(($hashT{$c1} eq 'w' and $hashT{$c2} eq '1') or ($hashT{$c3} eq '1' and $hashT{$c4} eq 'w')){
			    #then danger piece
			    #add to array and at end if length of $faveMove is 0 then randonly select one
			    $lossMoves{$cPiece} = $tryD;
			}
			else{
			    $faveMove = $tryD; #gets fave desti
			    $start = $cPiece;
			    $score = $hashT{"p2score"};
			} 
		    }
		}
	    }
	}
	my @movesToReturn;
	if (length($doubleJump) > 1){
	    #then dj attempted
	    push(@movesToReturn, $start, $doubleJStart, $doubleJump);
	    push(@pieces, $doubleJump); #add the new piece
	}
	#do elsif here and select from hash
	elsif (length($faveMove) < 1){
	    $faveMove = $lossMoves{(keys %lossMoves)[rand keys %lossMoves]};
	    $start = (keys %lossMoves)[rand keys %lossMoves];
	}
	else{
	   push(@movesToReturn, $start, $faveMove);
	   push(@pieces, $faveMove); #add the new piece
	}
	my $rem = 0;
	$rem++ until $pieces[$rem] eq $start;
	splice(@pieces, $rem, 1); #remove the pice thats been moved

	#add newly opened pieces to the array
	if ((chr(ord(substr($start, 0, 1))-1) ~~ ["a".."h"] and chr(ord(substr($start, 0, 1))-1) ~~ ["a".."h"]) and substr($start, 1, 1)+1 ~~[1..8]){
	   my $toOpenL = chr(ord(substr($start, 0, 1))-1)  . (substr($start, 1, 1)+1);
	   my $toOpenR =  chr(ord(substr($start, 0, 1))+1)  . (substr($start, 1, 1)+1);
	   push(@pieces, $toOpenL, $toOpenR); #add opened pieces.
	}
	#remove duplicates
	my %flush = ();
	foreach(@pieces){
	    $flush{$_} ++;
	}
	@pieces = keys %flush;
	@openP = @pieces;
	return (\@movesToReturn, \@piecesAdd, \@piecesRemove, \@openP, $firstTime, \@pieces);
    }
}
1;

