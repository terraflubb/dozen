# dozen
A readable and more usable Ruby port of [`sixpair.c`](http://www.pabr.org/sixlinux/sixpair.c), a tool for the Bluetooth pairing of Sixaxis controllers with things like your phone.

This was written by Rob Fletcher, but I looked at sixpair to figure out the USB stuff.

## Usage

So, you know your phone's Bluetooth address. Let's say that it is `aa:bb:cc:dd:ee:ff`.
This will be your usecase 99% of the time.

1. Plug in your Sixaxis controller via USB
2. `ruby -Ilib bin/dozen pair aa:bb:cc:dd:ee:ff` (lol I didn't set it up as a gem yet)
3. Done! That controller is now paired with your phone. Fire up sixaxis and you're all done

## ADVANCED USAGE

So now you have 3 sixaxis controllers and want to use them all on your phone at once. Hopefully you also have an HDMI dongle, but that is beyond the scope of this document.

You could do the usage step 3 times, but ol' flubby was thoughtful enough to add an `--all` flag!

1. Plug in ALL THREE of your Sixaxis controllers at once
2. `ruby -Ilib bin/dozen pair --all aa:bb:cc:dd:ee:ff`
3. Go play Snood or something!

## SNIPER USAGE

All right then fancy pants. Now you have ... 18 Sixaxis controllers and you only want to pair one them with your phone.

1. Buy a quality series of USB hubs
2. Plug in all 18 Sixaxis controllers
3. `ruby -Ilib bin/dozen list`
4. Work out which of the 18 nearly-identical entires is the controller you want (it's #4)
5. `ruby -Ilib bin/dozen pair aa:bb:cc:dd:ee:ff --index 4` (yeah yeah, gemspec something...)
