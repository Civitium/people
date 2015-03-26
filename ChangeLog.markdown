# 0.4.2 2015-03-25
* match Dutch names (see: https://github.com/mericson/people/issues/2)
* fix some matching with other complex last names
* update specs to rpec 3
* added triple dotted initials from @djudd


# 0.4.1 2015-03-21
* moved title and suffixes to constants
* made title and suffixes regex's
* added test for multiple suffixes
* optimized some title/suffix searching (maybe?)
* removed parse_type variable/key as it seemed to be only used for tests
* added note about ruby version (> 2.1.0) or get other gems
*

# 0.4.0 2015-03-18
* added pull requests to original with contributions from @perryjg, @musicglue, @stringsn88keys
* updated gemspec, rakefile, readme
* use bundler
* added Gemfile, version file
* started re-org
* updated to rspec 3

# people 0.3.1, 2013-03-07
* Added a lengthy list of medical suffixes.
* Added a name format to capture middle names.
* Added several test scenarios.
* Realized that I was trying to use redo instead of retry, and that retry no longer works for loops.

# people 0.3.0, 2013-03-06

* Fixed handling for Last_name, First_name Middle
* Added support for multiple suffixes
* Will now collect multiple middle names.
