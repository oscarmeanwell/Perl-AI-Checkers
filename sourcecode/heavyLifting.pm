no warnings;
use 5.010;
use LWP::Simple qw(getstore);
package heavyLifting;
{
    my @board= split //, "0w0w0w0ww0w0w0w00w0w0w0w1010101001010101b0b0b0b00b0b0b0bb0b0b0b0";
    sub bHash{
        #build the hash from the string @baord
	    my %newB;
        my @alpha = split //, "abcdefgh";
        my $step = 0;
        for my $line (1..8){
            for my $index (1..8){
                $newB{$alpha[$index-1].$line} = $board[$step];
                $step++;
            }
        }
       $newB{"p1score"} = 0;
       $newB{"p2score"} = 0;
       $newB{"glob"} = 0;
       $newB{"turn"} = 1;
       $newB{"color"} = 'w';
       $newB{"computer"} = 0;
       return %newB;
    }

    sub printBoard{
	my %hashBoard = @_;
	print "\n\n";
	my $tmp = "";
	print "\t   a b c d e f g h\n";
	print "\t  -----------------\n\t";
	my @alpha = split //, "abcdefgh";
	for my $ln (1..8){
	    print $ln . " ";
	    for my $col (1..8){
		 $tmp = ($hashBoard{$alpha[$col-1] . $ln} ~~ ["0", "1"]) ? " " : $hashBoard{$alpha[$col-1] . $ln};
		 print "|" . $tmp;
	    }
	    print "|\n\t  -----------------\n\t";
	}
	print "\n\n";
	print "Player One: " . $hashBoard{'p1score'} . " Player 2: " . $hashBoard{'p2score'} . "\n";   
	return;
    }
    sub installJ{
	    print "\nYou are missing the JSON perl Library needed to play this game\n";
	    print "\nInstall now? (y/n): ";
	    my $inp = <>;
	    if($inp ~~ ['y', 'Y']){
		my $d1 = 'http://search.cpan.org/CPAN/authors/id/I/IS/ISHIGAKI/JSON-2.94.tar.gz';
		getstore($d1,"JSON-2.94.tar.gz") or die("$!");
		system("tar -zxvf JSON-2.94.tar.gz");
		chdir "JSON-2.94";
		system("perl Makefile.PL");
		system("make");
		system("make test");
		system("sudo make install");
	    }
	    else{
		print "\nThats a shame, sorry to see you go.\n\n";
		exit;
	    }
    }
}
1;
