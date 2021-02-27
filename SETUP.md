## Instructions for Setting Up and Contributing

You require a [special version of asm6f](https://github.com/nstbayless/asm6f) which has support for patching directives. Make sure this version of `asm6f` is on the PATH.

Optionally, put [ipsnect](https://github.com/nstbayless/ipsnect) on the path to generate a patch map.

First you must supply your own ROM for Castlevania II: Simon's Quest (USA).
Paste the ROM into the repo and name it `base.nes`. Then run `setup.sh`.
This will generate a `working.nes` file which you can run and edit,
which should be up-to-date with the repository patch.

Finally, place your ROM into this directory and call it `base.nes`. You can also
add `base-bisqwit.nes` (just apply bisqwit's retranslation to `base.nes`).

Then run `./build.sh`. You will need bash to do this. On windows, if you have [git installed](https://git-scm.com/download/win), you may be able to run `./build.sh` from your git terminal (which comes with bash).
You should see several files generated, including .ips and .nes files.

Additionally, if possible, please make sure your contributions are compatible
with this English localization hack as well:
http://www.romhacking.net/hacks/1983/
You can do this by applying the localization patch directly to `base.nes`.

Do not commit any .nes files to the repo which are not in the public domain!
