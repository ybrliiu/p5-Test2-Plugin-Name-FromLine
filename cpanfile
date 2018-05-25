requires 'perl', '5.010001';
requires 'Test2::Suite', '0.000114';
requires 'Path::Tiny', '0.104';

on 'test' => sub {
    requires 'Test::Simple', '1.302136';
};

