use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Schoo_study',
    VERSION_FROM  => 'lib/Schoo_study.pm',
    PREREQ_PM     => {
        'Kossy' =>  '0.38',
    },
    MIN_PERL_VERSION => '5.008001'
);

