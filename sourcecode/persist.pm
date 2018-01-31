package persist;
use JSON;
use Cwd;
no warnings;
use feature qw/say/;
use POSIX qw(strftime);
use strict;
{
    sub loadGame{
	say "\nLoading game...\n";
	#get hash from file
	#get json and convert to has %hasboard
	#list dir contents and select file to  load
	#parse date into readable format using split on index
	opendir my $dir, (getcwd() . "/.saved") or die "Cannot open directory: $!";
	my @fin;
	my $count = 1;
	foreach(readdir $dir){
	    if ($_ =~ m/.json/){ #filter out non json files
		my $tmp = $_;
		#format tmp to date
		$tmp =~ s/.json//g; #remove file extention
		my $date = substr($tmp, 6, 2) . "/" . substr($tmp, 4, 2) . "/" . substr($tmp, 0, 4);
		my $time = substr($tmp, 8, 2) . ":" . substr($tmp, 10, 2) . ":" . substr($tmp, 12, 2);
		say "\t" . $count . " - " . substr($tmp, 14) . " on (" . $date . " at " . $time . ")";
		push(@fin, $_);
		$count++;
	    }
	}
	closedir $dir;

	#ask what number then do array pos -1 to get filename
	if (scalar(@fin) < 1){
	    say "Please play and save a game first";
	    return
        }
	print "\nWhich game would you like to open?: ";
	my $inp = <>;
	#get len of fin and if inp < 1 or > array len + 1 ask againi
	while($inp < 1 or $inp > scalar(@fin)){
	    print "\nPlease enter a valid game to load: ";
	    $inp = <>;
	}
	my $t = @fin[$inp-1];
	chomp $t;
	my $json = do {
	    open my $fh2, '<', (".saved/".$t) or die "$!";
	    local $/;
	    <$fh2>
	};
	my $tmpHash = decode_json($json);
	print "Would you like to delete the game file now that its loaded? (y/n): ";
	my $newInp = <>;
	chomp $newInp;
	 if ($newInp eq 'y'){
	    system("rm .saved/$t");
	    say "Deleted.";
	}
	return %$tmpHash;
    }

    sub saveGame{
	#will be moved into own pm but here for now
	#take %hashBoard and save it to file
	my %hashBoard = @_;
	#my %moves = @_[1];
	print "\n\nEnter a name to save the game under (q to quit): ";
	my $gName = <>;
	chomp $gName;
	if($gName eq 'q') {exit;}
	my $dateStr = strftime "%F%X", localtime;
	$dateStr =~ s/(-|:|PM|AM| )//g;
	mkdir ".saved" unless(-d ".saved");
	open my $fh, ">", (".saved/". $dateStr . $gName . ".json");
	print $fh encode_json(\%hashBoard);
	close $fh;
    }
}
1;
