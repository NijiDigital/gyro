# Contributing to gyro

> * How to contribute via Pull Requests
>   * How to use & test your local/modified version of gyro
>   * Unit tests / rspecs
> * How gyro works internally
> * Writing templates
>   * Liquid & filters used in gyro
>     * Patch: Handling spaces around tags
>     * Filters specific to gyro
>   * Templates directory organization
>   * Additional tips for editing templates
>     * Syntax Highlighting
>     * Auto-update output with kicker


## How to contribute via Pull Requests

* Clone the repository.
	* If you're part of the `NijiDigital` GitHub organization, you can directly clone the repo and you'll be able to push new branches to it
	* If you're not part of the `NijiDigital` GitHub organization, either ask us to be part of it (we're pretty open to adding new members, and that's our preferred way for you to contribute), or fork the repository in your own GitHub and clone your fork

* Create a new branch, make your changes in the code or template
* Try running your local, modified version of `gyro` with `bundle exec gyro` (see below) 
* Run the tests & check code style using `bundle exec rspec` & `bundle exec rubocop` (see below)
* Don't forget to add an entry in the `CHANGELOG.md` to explain your new feature or fix and credit yourself
* Once everything is ok and the tests and rubocop all pass, push your changes
* Open a Pull Request to merge your branch into `master`
	* Unless you used a fork, CircleCI will perform the tests on your PR, including running the unit tests and running `rubocop`

### How to use & test your local/modified version of gyro

* Open a terminal
* `cd` into the directory where you cloned the repo
* Run `bundle install` if you haven't run it before
	* If you don't have `bundler` installed on your machine, you'll have to install it first using `gem install bundler`.
* Use `bundle exec` to run the following commands — so that it uses the versions specified in the `Gemfile`, especially the local copy of `gyro` instead of the one installed globally on your system
	* Use `bundle exec rspec` to run the tests
	* Use `bundle exec rubocop` to check the code style of your ruby code
	* Use `bundle exec gyro …` to run the local version of gyro in this repo


```bash
bundle install      # Install any necessary ruby dependencies
bundle exec rspec   # Run the tests
bundle exec rubocop # Check for code style
bundle exec gyro -v # Run gyro -v using the local code, not the system-installed gyro
bundle exec gyro -l # Same for any gyro command you want to test
```

### Unit Tests / rspec

In ruby, unit tests are called "specs".

`gyro` uses `rspec` to run the tests and test its ruby "specs".

Those unit tests (specs) are located in the `spec` subdirectory, containing:

* `spec/fixtures/xcdatamodel`: the input xcdatamodel used as input test fixtures of the various the tests
* `spec/fixtures/<lang>`: the output fixtures (the output expected for each test) for various templates (currently: `java`, `kotlin`, `swift`
* `spec/gyro`: the tests themselves

The tests in `spec/gyro` consist of invoking `gyro` with various input `xcdatamodel` and various options, letting gyro generate the output in a temporary folder, then compare the generated output with the expected one found in `spec/fixtures/<lang>`.

This means that the specs for `gyro` are only based on textual comparison, checking that it generates the expected… text. They **don't** check if what is generated will actually compile in Swift/Java/Kotlin (that would require to embed a swift, java & kotlin compiler just for that…)

**So when you update the Unit Tests, be sure to test the code you make `gyro` generate (the one located in `spec/fixtures/<lang>`) with an actual compiler to be sure that it will actually compile.**

## How gyro works internally

Gyro is composed of two parts:

* Parsers, which takes an input model and outputs an intermediate representation of that model
	* Today `gyro` has only one parser, to parse `xcdatamodel` files. Maybe we'll add more parsers to support more input formats in the future
* Generators, whose role are to transform the intermediate representation (see model classes in `lib/gyro/parser/xcdatamodel/*.rb`) into some output (either JSON or using a template engine)
	* Today `gyro` only has two generators, one to use Liquid templates to generate its output, and one to generate JSON output.

This allows us to be flexible about input and outputs we support.

* Source code for Parsers are located in `lib/gyro/parser`
* Source code for Generators are located in `lib/gyro/generator`
* The Liquid generator uses templates to define what code to generate. Gyro comes with bundled templates which can be found in `lib/templates/*`

## Writing templates

### Liquid & filters used in gyro

`gyro` uses Liquid 3.0, because Liquid 4.0 requires ruby 2.0 which was not installed by default until macOS High Sierra (previous versions of macOS had ruby 1.8 installed by default) — and we didn't want to impose that requirement of ruby 2.0 to use `gyro`.

> Once macOS High Sierra will be widespread enough, we'll probably migrate to Liquid 4.0, making `gyro` require ruby 2.0, but as of today that's not the case yet.

However, we extended Liquid 3.0 inside gyro to patch it and add some filters (see below)

#### Patch: Handling spaces around tags

Our whitespace patch to Liquid 3.0 (see `lib/gyro/generator/liquid/whitespace_patch.rb`) allows to support `{%-` and `-%}` in addition of `{%` and `%}` (like Liquid 4 does).

Using those allows to remove whitespaces before/after the tag on the generated text. This allows to have more readable templates conserving some indentation in the template for things like `{%- if … -%}` and `{%- for … -%}` tags without adding extra whitespaces in the generated code

#### Filters specific to gyro

`gyro` also add some filters to Liquid (see `lib/gyro/generator/liquid/filters.rb`) that you can then use inside your `*.liquid` templates. This includes filters like:

* `escape_quotes` to turn `"` into `\"`
* `snake_to_camel_case` to turn `hello_world` into `HelloWorld`
* `snake_case` to turn `HelloWorld` into `hello_world`
* `uncapitalize` to turn `HelloWorld` into `helloWorld`
* `titleize` to turn `helloWorld` into `HelloWorld`
* `delete_objc_prefix` to remove uppercase prefixes and turn `ABCFidelityCard` into `FidelityCard`

### Templates directory organization

If you plan to write your own templates:

* It's generally easier to duplicate an existing template and adapt it than starting from scratch
* You can find the documentation for the Liquid templating language [here](http://shopify.github.io/liquid/) and elsewhere on the net
* Each template is represented by a folder which must at least contain:
	* Ideally, a `README.md` file documenting the template
	* an `entity.liquid` file representing the template to use for each entity
	* an `entity_filename.liquid` file which must only contain one line, representing the template to use to generate the file name for each given entity
	* an `enum.liquid` file representing the template to use for each enum used in the model, if the entities of your model contains enum attributes
	* an `enum_filename.liquid` file which must only contain one line, representing the template to use to generate the file name for each enum

### Additional tips for editing templates

#### Syntax Highligting

Liquid is a well known templating language, so chances are your favorite text editor (Sublime Text, Atom, …) has a syntax highlighting plugin for Liquid files. Be sure to check and install it, that will make editing your `.liquid` files way more readable!

Liquid is more commonly used to generate HTML output rather than Swift/Java/Kotlin/… so some of those syntax highlighting plugins might be named "HTML+Liquid" or "HTML Liquid", but that is still better than monochrome text 😉

#### Auto-update output with kicker

If you find yourself going back and forth between your text editor to modify a template and your terminal to run `bundle exec gyro` to test your template and see what is genenerated, there are some solutions to improve that.

One of them is [kicker](https://github.com/alloy/kicker), which allows you to "watch" a directory for changes (typically the directory of the template you're editing) and automatically execute an arbitrary command (typically `bundle exec gyro -t your_template_being_tested -o /tmp/gyro_test -m spec/fixtures/xcdatamodel/some_model.xcdatamodel`) when one of the file is changed.

That way, you can easily open side-by-side in your favorite editor both your template and the output generated in some temp folder, and let `kicker` run in the background to auto-update the output without having to switch back to the Terminal each time 👍

_Kicker is not the only solution allowing to do that (just one of them), some editors might even have a similar feature embedded directly_
