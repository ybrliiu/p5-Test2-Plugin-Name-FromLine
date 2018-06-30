requires 'Path::Tiny';
requires 'Test2::API';
requires 'Test2::Formatter::TAP';
requires 'Test2::Util::HashBase';
requires 'feature';
requires 'parent';
requires 'perl', '5.014004';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test2::Bundle::More';
    requires 'Test2::Tools::Exception';
    requires 'Test::More';
};
