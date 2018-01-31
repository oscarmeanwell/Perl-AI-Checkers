# Checkers Game #

* A text based Checkers/Draughts game
* Written in Perl 5

### How do I get set up? ###

* Clone the repo to a unix based machine
* Providing Perl 5 is installed, use the command line to navigate to the sourcecode
  directory and type "perl checkers.pl"
* The only additional requirement for this program is a JSON module from CPAN
  every time you run the game it will check if this module is installed and if
  not it will install it. If the install fails a manual install may be necessary.
  The Module - http://search.cpan.org/~ishigaki/JSON-2.94/lib/JSON.pm .
* If you want to run the program from a shell script, navigate to the executable
  directory, change the permission of the script "runme.sh" so that you can execute
  it. To do this - "chmod +x runme.sh", to then execute ./runme.sh

### How do I play? ###
* There is a section within the main menu called rules, one called help - these will
  explain everything you need to know. It is also possible at most points in the game
  to press a key for help, then the system will explain what input it wants from you
  and ask again. 
  
### I have to install the JSON module myself, how? ###

* Run these commands in the shown order,then re-run the program.
* wget http://search.cpan.org/CPAN/authors/id/I/IS/ISHIGAKI/JSON-2.94.tar.gz
* tar -zxvf JSON-2.94.tar.gz
* cd JSON-2.94
* perl Makefile.PL
* make
* make test
* sudo make install

### Who do I talk to? ###

* Oscar Meanwell - oscarmeanwell@gmail.com
