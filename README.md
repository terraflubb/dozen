# dozen
A tool to pair your Sixaxis controller with an arbitrary Bluetooth device. A more readable and more usable Ruby port of [`sixpair.c`](http://www.pabr.org/sixlinux/sixpair.c)

This was written by Rob Fletcher, but I looked at sixpair to figure out the USB stuff.

## What does it do?

All this tool will do is tell your Sixaxis controller who it's Bluetooth master is. This is often called *pairing*. This should work with stock Ruby that comes with all OS X installations.

### I'm confused if this is what I need!

With USB devices, you can just plug it in, and it will send data. It knows where to go, just follow the wire. With Bluetooth, you need to jump through a few hoops in order for the device to know where to send data. Most devices make this easy... you can scan for Bluetooth devices, find the one you want, and you're good. The PS3 didn't really have to, since the Sixaxis controller came with a Mini-USB port, so you could just plug it into your PS3, it would pair itself silently, and when you unplugged it would remember where to send the data.

If you want a PS3 controller to send data to something ELSE (like a phone or a tablet) it can be bit more awkward. If you have a device without a USB port, it's entirely awkward.

That's what this will do. I have a Nexus 4 and it has a very useless USB port, but I wanted to pair my Sixaxis with it. The tools for Linux and OS X linked to from [Dancing Pixel Studios](http://www.dancingpixelstudios.com/sixaxiscontroller/tool.html) weren't the greatest. I can't even remember why I gave up trying to build the tool, but I think it was the super-old version of libusb that was required.

But if you just plug your PS3 controller into your computer (I've only tested this on OS X) and run this, you can tell it to pair with any Bluetooth device address you want. I put in my phone's Bluetooth address (helpfully listed right from the [Sixaxis](https://play.google.com/store/apps/details?id=com.dancingpixelstudios.sixaxiscontroller&hl=en) app or if you dig into your settings. I suspect that's what most people will use this for.

### What doesn't this do

All this does is pair the controller with something. It's not a driver. The thing you're pairing your controller with has to know what to do with the device. So if you're using this for an Android device, that probably means you need to root your phone and buy the super handy [Sixaxis](https://play.google.com/store/apps/details?id=com.dancingpixelstudios.sixaxiscontroller&hl=en).

I don't know what it takes to get a Sixaxis controller paired via Bluetooth to be recognized by whatever OS you've got, but this won't do it.

## Getting started

**TODO: Install the gem... that should do it once that's done**

## Basic Usage
So, you know your phone's Bluetooth address. Let's say that it is `aa:bb:cc:dd:ee:ff`.
This will be your usecase 99% of the time.

1. Plug in your Sixaxis controller via USB
2. `ruby -Ilib bin/dozen pair aa:bb:cc:dd:ee:ff` (lol I didn't set it up as a gem yet)
3. Done! That controller is now paired with your phone. Fire up sixaxis and you're all done

## Advanced Features

### Pair multiple controllers at once!
So now you have 3 sixaxis controllers and want to use them all on your phone at once. Hopefully you also have an HDMI dongle, but that is beyond the scope of this document.

You could do the usage step 3 times, but ol' flubby was thoughtful enough to add an `--all` flag!

1. Plug in ALL THREE of your Sixaxis controllers at once
2. `ruby -Ilib bin/dozen pair --all aa:bb:cc:dd:ee:ff`
3. Go play Snood or something!

### Sniper usage

All right then fancy pants. Now you have ... 18 Sixaxis controllers and you only want to pair one them with your phone.

1. Buy a quality series of USB hubs
2. Plug in all 18 Sixaxis controllers
3. `ruby -Ilib bin/dozen list`
4. Work out which of the 18 nearly-identical entires is the controller you want (it's #4)
5. `ruby -Ilib bin/dozen pair aa:bb:cc:dd:ee:ff --index 4` (yeah yeah, gemspec something...)


# TO DO

* Test coverage
* Make it a proper gem
