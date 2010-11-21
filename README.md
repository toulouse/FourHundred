What kind of magic can you cook up in Core Graphics with 400 pixel sides? Here's mine..

![houseegg](https://github.com/toulouse/FourHundred/raw/master/house_egg.jpeg)

Happy Coding!

# Running it

Just run the app in your simulator to see the magic happen. You can run it on your device too - though you might consider disabling the file-saving. Also, don't forget to change the 400x400 dimensions to 320x320 so all of it is visible.

## Saving the picture

Uncomment the line in FourHundredView.m and add your own path there:

    //[self createJPEGWithRect:frame filename:@"/Users/toulouse/test.jpeg"];

Note that PNG output is weird for stuff with partial opacity, which is true for the view created here.

