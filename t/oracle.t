use Test::More tests => 4;

SKIP: {

eval {
	require DBI;
} or skip "could not load DBI module: $@", 4;

my $dbuser = $ENV{ORACLE_USERID};

skip 'environment ORACLE_USERID is not set, skipping Oracle tests', 4 unless $dbuser;


my $conn = DBI->connect('dbi:Oracle:', $dbuser, '', { PrintError => 0 , RaiseError=>1});


{
	package T1;
	eval q{
		use DBIx::ProcedureCall qw(
				sysdate
				greatest:function
				dbms_random.initialize:procedure
				);};
}



#########################

{

my $testname = 'simple call to sysdate';


ok ( T1::sysdate($conn), $testname );
		
}

#########################

{

my $testname = 'call to greatest() with positional parameters';

ok ( T1::greatest($conn, 1,2,42) == 42, $testname );
		
}

#########################

{

my $testname = 'call to dbms_random.initialize with a named parameter';

T1::dbms_random_initialize($conn, 12345678);
ok ( 1 , $testname );
		
}


#########################

{

my $testname = 'call to greatest in the wrong context but with proper declaration';

T1::greatest($conn, 12345678,11,11);
ok ( 1 , $testname );
		
}


# END SKIP
};