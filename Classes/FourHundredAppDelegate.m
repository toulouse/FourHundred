//
//  FourHundredAppDelegate.m
//  FourHundred
//
//  Created by Andrew Toulouse on 11/20/10.
//  Copyright 2010 Andrew Toulouse. All rights reserved.
//

#import "FourHundredAppDelegate.h"
#import "FourHundredView.h"

@implementation FourHundredAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	window.backgroundColor = [UIColor blackColor];

	CGFloat viewWidth = 400.0;
	CGFloat viewHeight = 400.0;
	CGFloat viewX = (self.window.frame.size.width - viewWidth) / 2.0;
	CGFloat viewY = (self.window.frame.size.height - viewHeight) / 2.0;

	UIView *fourHundredView = [[[FourHundredView alloc] initWithFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)] autorelease];
	[window addSubview:fourHundredView];
    [window makeKeyAndVisible];
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
