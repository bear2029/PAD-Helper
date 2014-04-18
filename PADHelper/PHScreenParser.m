//
//  PHScreenParser.m
//  PADHelper
//
//  Created by kt on 4/17/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import "PHScreenParser.h"

@implementation PHScreenParser


/*
 Main constructor
 */
-(id)initWithImage:(UIImage *) image
{
	if (self = [super init]){
		self.chosenImage = image;
	}
	return self;
}

/*
 Sets the screenshot to use for parsing orbs
 @param screenShot UIImage of the screen shot
 */
-(void)setScreenShot:(UIImage *) screenShot
{
    self.chosenImage = screenShot;
}

-(void)parseScreenShot{
    int rowCount = 5;
    int colCount = 6;
    NSString* matrix[rowCount][colCount];
    for(int r = 0; r < rowCount; r++) {
        for (int c = 0; c < colCount; c++) {
            NSLog(@"row:%d, col:%d",r,c);
            NSString* domCol = [self getColorCodeOf:r : c];
            matrix[r][c] = domCol;
            NSLog(@"%@, ", domCol);
        }
    };
}

/* 
 Gets the color code of the specific row, col
 @param row
 @param col
 @return color code
 */
-(NSString *)getColorCodeOf:(int)row :(int)column
{
    //There is a 1px border around each orb box
    //(gridStartX,gridStartY,orbWidth,orbHeight) = 4,611,105,105
    NSInteger square = 105;
    NSInteger startX = 4 + column * square;
    NSInteger startY = 611 + row * square;
    NSInteger centerSquare = 5;
    CGImageRef ref = CGImageCreateWithImageInRect(self.chosenImage.CGImage, CGRectMake(startX + square/2 - centerSquare/2, startY + square/2 - centerSquare/2, centerSquare, centerSquare));
    UIImage *img = [UIImage imageWithCGImage:ref];
    UIColor* colorResult = [self mergedColor:img];
    return [self mapAverageColor:colorResult];
}

/* Tries to match the average color to our prefixed set of orb colors
 @param avgCol The average color to match against
 @return selectedColor The color code that was matched
 */
-(NSString *)mapAverageColor: (UIColor *) avgCol
{
    NSDictionary *colors =
        @{
          @"R": [UIColor colorWithRed:1 green:0.482980 blue:0.280627 alpha:1],
          @"B": [UIColor colorWithRed:0.257255 green:0.729569 blue:0.996078 alpha:1],
          @"G":[UIColor colorWithRed: 0.272941 green:0.983216 blue:0.416157 alpha:1],
          @"Y": [UIColor colorWithRed:1 green:1 blue:0.541961 alpha:1],
          @"P":  [UIColor colorWithRed:0.718118 green:0.371137 blue:0.711686 alpha:1],
          @"H":  [UIColor colorWithRed:0.883922 green:0.177725 blue:0.536784 alpha:1]
          };
    CGFloat red, green, blue;
    [avgCol getRed:&red green:&green blue:&blue alpha:NULL];
    //NSLog(@"r:%f, b:%f, g:%f", red, blue, green);
    NSString* selectedColor = @"";
    float smallestDistance = 0;
    for(id color in colors) {
        UIColor* colDef = [colors objectForKey:color];
        float distance = [UIColorProcess findDistanceBetweenTwoColor:colDef secondColor:avgCol];
        //  NSLog(@"distance for %@= %f",color, distance);
        if (smallestDistance == 0 || distance < smallestDistance) {
            smallestDistance = distance;
            selectedColor = color;
        }
    }
    return selectedColor;
}

/* Method 1 Gets average color, this one is faster
 @param orbRect UIImage of the orb
 @return average color in UIColor
 */
-(UIColor *)mergedColor: (UIImage *)orbRect
{
	CGSize size = {1, 1};
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
	[orbRect drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];
	uint8_t *data = CGBitmapContextGetData(ctx);
	UIColor *color = [UIColor colorWithRed:data[2] / 255.0f
									 green:data[1] / 255.0f
									  blue:data[0] / 255.0f
									 alpha:1];
	UIGraphicsEndImageContext();
	return color;
}

/* Method 2 Gets average color, this one is faster
 @param orbRect UIImage of the orb
 @return average color in UIColor
 */
-(UIColor *)averageColor: (UIImage *)orbRect
{
    CGImageRef rawImageRef = orbRect.CGImage;
    
    // This function returns the raw pixel values
	CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(rawImageRef));
    const UInt8 *rawPixelData = CFDataGetBytePtr(data);
    
    NSUInteger imageHeight = CGImageGetHeight(rawImageRef);
    NSUInteger imageWidth  = CGImageGetWidth(rawImageRef);
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(rawImageRef);
	NSUInteger stride = CGImageGetBitsPerPixel(rawImageRef) / 8;
    
    // Here I sort the R,G,B, values and get the average over the whole image
    unsigned int red   = 0;
    unsigned int green = 0;
    unsigned int blue  = 0;
    
	for (int row = 0; row < imageHeight; row++) {
		const UInt8 *rowPtr = rawPixelData + bytesPerRow * row;
		for (int column = 0; column < imageWidth; column++) {
            red    += rowPtr[0];
            green  += rowPtr[1];
            blue   += rowPtr[2];
			rowPtr += stride;
            
        }
    }
	CFRelease(data);
    
	CGFloat f = 1.0f / (255.0f * imageWidth * imageHeight);
	return [UIColor colorWithRed:f * red  green:f * green blue:f * blue alpha:1];
}

@end
