//
//  FourHundredView.m
//  FourHundred
//
//  Created by Andrew Toulouse on 11/20/10.
//  Copyright 2010 Andrew Toulouse. All rights reserved.
//

#import "FourHundredView.h"
#import <math.h>

@interface FourHundredView ()

- (void)createJPEGWithRect:(CGRect)pageRect filename:(NSString *)filename;

@end


@implementation FourHundredView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// JPEG because PNG opacity is broke or something.
		//[self createJPEGWithRect:frame filename:@"/Users/toulouse/test.jpeg"];
    }
    return self;
}

- (void)createJPEGWithRect:(CGRect)rect filename:(NSString *)filename // 1
{
	UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    [self drawRect:CGRectMake(0.0, 0.0, rect.size.width, rect.size.height)];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
	[imageData writeToFile:filename atomically:YES];
	UIGraphicsEndImageContext();
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context, YES);
	CGContextSetShouldAntialias(context, YES);

	// SETUP
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	
	CGFloat const borderWidth = (CGRectGetMaxY(rect)-CGRectGetMinY(rect)) / 128.0;
	CGFloat const minX = CGRectGetMinX(rect) + borderWidth, minY = CGRectGetMinY(rect) + borderWidth;
	CGFloat const maxX = CGRectGetMaxX(rect) - borderWidth, maxY = CGRectGetMaxY(rect) - borderWidth;
	CGFloat const midX = CGRectGetMidX(rect), midY = CGRectGetMidY(rect);
	CGFloat const contentHeight = maxY - minY, contentWidth = maxX - minX;
	
	// PATHS
	// Create app icon clipping path
	CGMutablePathRef appIconClipPath = CGPathCreateMutable();
	CGPathMoveToPoint(appIconClipPath, NULL, midX, CGRectGetMinY(rect));
	CGPathAddArcToPoint(appIconClipPath, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), midY, (CGRectGetMaxY(rect)-CGRectGetMinY(rect)) / 8.0);
	CGPathAddArcToPoint(appIconClipPath, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), midX, CGRectGetMaxY(rect), (CGRectGetMaxY(rect)-CGRectGetMinY(rect)) / 8.0);
	CGPathAddArcToPoint(appIconClipPath, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), midY, (CGRectGetMaxY(rect)-CGRectGetMinY(rect)) / 8.0);
	CGPathAddArcToPoint(appIconClipPath, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), midX, CGRectGetMinY(rect), (CGRectGetMaxY(rect)-CGRectGetMinY(rect)) / 8.0);
	CGPathCloseSubpath(appIconClipPath);
	
	// Create app border clipping path
	CGMutablePathRef appBorderClipPath = CGPathCreateMutable();
	CGPathMoveToPoint(appBorderClipPath, NULL, midX, minY);
	CGPathAddArcToPoint(appBorderClipPath, NULL, maxX, minY, maxX, midY, (maxY-minY) / 8.0);
	CGPathAddArcToPoint(appBorderClipPath, NULL, maxX, maxY, midX, maxY, (maxY-minY) / 8.0);
	CGPathAddArcToPoint(appBorderClipPath, NULL, minX, maxY, minX, midY, (maxY-minY) / 8.0);
	CGPathAddArcToPoint(appBorderClipPath, NULL, minX, minY, midX, minY, (maxY-minY) / 8.0);
	CGPathCloseSubpath(appBorderClipPath);
	
	// Create glossy clipping path
	CGMutablePathRef glossClipPath = CGPathCreateMutable();
	CGPathMoveToPoint(glossClipPath, NULL, minX, minY);
	CGPathAddLineToPoint(glossClipPath, NULL, minX, minY + contentHeight * 3.0 / 8.0);
	CGPathAddCurveToPoint(glossClipPath, NULL,
						  minX + contentWidth * 2.0 / 8.0, midY,
						  minX + contentWidth * 6.0 / 8.0, midY,
						  minX + contentWidth, minY + contentHeight * 3.0 / 8.0);
	CGPathAddLineToPoint(glossClipPath, NULL, maxX, minY);	
	CGPathCloseSubpath(glossClipPath);
	
	// Create clipping path for non-glossy
	CGMutablePathRef nonGlossClipPath = CGPathCreateMutable();
	CGPathMoveToPoint(nonGlossClipPath, NULL, minX, maxY);
	CGPathAddLineToPoint(nonGlossClipPath, NULL, minX, minY + contentHeight * 3.0 / 8.0);
	CGPathAddCurveToPoint(nonGlossClipPath, NULL,
						  minX + contentWidth * 2.0 / 8.0, midY,
						  minX + contentWidth * 6.0 / 8.0, midY,
						  minX + contentWidth, minY + contentHeight * 3.0 / 8.0);
	CGPathAddLineToPoint(nonGlossClipPath, NULL, maxX, maxY);	
	CGPathCloseSubpath(nonGlossClipPath);
	
	// Create house path
	const CGAffineTransform houseTransform = CGAffineTransformConcat(
																	 CGAffineTransformMakeScale(contentHeight * 3.0 / 8.0, contentHeight * 3.0 / 8.0),
																	 CGAffineTransformMakeTranslation(minX + contentHeight / 2.0, minY + contentHeight * 2.5 / 8.0)
																	 );
	CGMutablePathRef housePath = CGPathCreateMutable();
	CGPathMoveToPoint(housePath, &houseTransform, 0.0, 0.5);
	CGPathAddLineToPoint(housePath, &houseTransform, 0.5, 0.0);
	CGPathAddLineToPoint(housePath, &houseTransform, 1.0, 0.5);
	CGPathAddLineToPoint(housePath, &houseTransform, 0.8125, 0.5);
	CGPathAddLineToPoint(housePath, &houseTransform, 0.8125, 1.0);
	CGPathAddLineToPoint(housePath, &houseTransform, 0.5625, 1.0);
	CGPathAddLineToPoint(housePath, &houseTransform, 0.5625, 0.75);
	CGPathAddLineToPoint(housePath, &houseTransform, .4375, 0.75);
	CGPathAddLineToPoint(housePath, &houseTransform, .4375, 1.0);
	CGPathAddLineToPoint(housePath, &houseTransform, .1875, 1.0);
	CGPathAddLineToPoint(housePath, &houseTransform, .1875, 0.5);
	CGPathCloseSubpath(housePath);
	
	// Create egg path
	const CGAffineTransform eggTransform = 
		CGAffineTransformTranslate(
								   CGAffineTransformRotate(
														   CGAffineTransformTranslate(
																					  CGAffineTransformScale(
																											 CGAffineTransformMakeTranslation(
																																			  minX + contentHeight / 8.0, minY + contentHeight * 2.5 / 8.0
																																			  ),
																											 contentHeight * 3.0 / 8.0, contentHeight * 3.0 / 8.0
																											 ),
																					  0.5, 0.5),
														   M_PI/4),
								   -0.5, -0.5
								   );
	
	CGMutablePathRef eggPath = CGPathCreateMutable();
	CGPathMoveToPoint(eggPath, &eggTransform, 0.4, 0.05);
	CGPathAddCurveToPoint(eggPath, &eggTransform, 0.0, 0.75, 0.25, 1.0, 0.5, 1.0);
	CGPathAddCurveToPoint(eggPath, &eggTransform, 0.75, 1.0, 1.0, 0.75, 0.6, 0.05);
	CGPathAddCurveToPoint(eggPath, &eggTransform, 0.525, -0.05, 0.475, -0.05, 0.4, 0.05);
	CGPathCloseSubpath(eggPath);
	
	
	// COLORS
	CGFloat shadowColor[] = {
		0.0, 0.0, 0.0, 0.8
	};
	CGColorRef shadowCGColor = CGColorCreate(rgb, shadowColor);
	
	// GRADIENTS
	CGFloat borderColors[] = {
		1.0, 1.0, 1.0, 1.0,
		1.0, 1.0, 1.0, 0.4
	};
	CGGradientRef borderGradient = CGGradientCreateWithColorComponents(rgb, borderColors, NULL, sizeof(borderColors)/(sizeof(borderColors[0])*4));
	
	CGFloat glossyColors[] = {
		1.0, 1.0, 1.0, 0.5,
		0.8, 0.8, 0.8, 0.2
	};
	CGGradientRef glossyGradient = CGGradientCreateWithColorComponents(rgb, glossyColors, NULL, sizeof(glossyColors)/(sizeof(glossyColors[0])*4));
	
	CGFloat nonGlossyColors[] = {
		0.7, 0.7, 0.7, 1.0,
		0.9, 0.9, 0.9, 1.0,
		1.0, 1.0, 1.0, 1.0
	};
	CGGradientRef nonGlossyGradient = CGGradientCreateWithColorComponents(rgb, nonGlossyColors, NULL, sizeof(nonGlossyColors)/(sizeof(nonGlossyColors[0])*4));
	
	CGFloat houseEggColors[] = {
		0.0, 0.0, 0.6, 1.0,
		0.0, 0.0, 1.0, 1.0
	};
	CGGradientRef houseEggGradient = CGGradientCreateWithColorComponents(rgb, houseEggColors, NULL, sizeof(houseEggColors)/(sizeof(houseEggColors[0])*4));
	
	CGColorSpaceRelease(rgb);
	// END SETUP
	// PAINTING
	CGContextSaveGState(context);
	
	// Clip icon
	CGContextAddPath(context, appIconClipPath);
	CGContextClip(context);

	// Paint icon background
	CGContextSetRGBFillColor(context, 0.8, 0.0, 0.0, 1.0);
	//CGContextFillRect(context, rect);
	CGContextDrawLinearGradient(context, houseEggGradient, CGPointMake(minX, minY), CGPointMake(minX, maxY), kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	// Paint icon border
	CGContextSaveGState(context);
	CGContextAddPath(context, appIconClipPath);
	CGContextAddPath(context, appBorderClipPath);
	CGContextEOClip(context);
	
	CGContextDrawLinearGradient(context, borderGradient, CGPointMake(minX, minY), CGPointMake(minX, maxY), kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);

	// {{{
	CGContextSaveGState(context);
	CGContextScaleCTM(context, -1.0, 1.0); // This and the next line flip the draw commands horizontally.
	CGContextTranslateCTM(context, -minX-contentWidth, 0.0); // Possible bug?
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextSetShadowWithColor(context, CGSizeMake(borderWidth, borderWidth * 4.0), borderWidth * 6.0, shadowCGColor);
	
	CGContextAddPath(context, housePath);
	CGContextFillPath(context);
	CGContextAddPath(context, eggPath);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	// }}}
	
	// Draw gloss gradient
	CGContextSaveGState(context);
	CGContextSetBlendMode(context, kCGBlendModeHardLight);
	CGContextAddPath(context, glossClipPath);
	CGContextClip(context);
	
	CGContextDrawLinearGradient(context, glossyGradient, CGPointMake(minX, minY), CGPointMake(minX, minY + contentHeight / 2.0), kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
	
	// Draw non-gloss gradient
	CGContextSaveGState(context);
	CGContextSetBlendMode(context, kCGBlendModeMultiply);
	CGContextAddPath(context, nonGlossClipPath);
	CGContextClip(context);
	
	CGContextDrawLinearGradient(context, nonGlossyGradient, CGPointMake(minX, minY + contentHeight * 3.0 / 8.0), CGPointMake(minX, maxY), kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);

	// TEAR DOWN
	CGContextRestoreGState(context);
	CGPathRelease(appIconClipPath);
	CGPathRelease(appBorderClipPath);
	CGPathRelease(glossClipPath);
	CGPathRelease(nonGlossClipPath);
	CGPathRelease(eggPath);
	CGPathRelease(housePath);
	CGGradientRelease(borderGradient);
	CGGradientRelease(glossyGradient);
	CGGradientRelease(nonGlossyGradient);
	CGGradientRelease(houseEggGradient);
}

- (void)dealloc {
    [super dealloc];
}

@end
