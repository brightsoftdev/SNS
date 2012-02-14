//
//  TKCoverflowView.m
//  Created by Devin Ross on 1/3/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "TKCoverflowView.h"
#import "TKCoverflowCoverView.h"
#import "TKGlobal.h"

#define COVER_SPACING 70.0
#define CENTER_COVER_OFFSET 70
#define SIDE_COVER_ANGLE 1.4
#define SIDE_COVER_ZPOSITION -80
#define COVER_SCROLL_PADDING 4

#pragma mark -
@interface TKCoverflowView (hidden)

- (void) animateToIndex:(int)index  animated:(BOOL)animated;
- (void) load;
- (void) setup;
- (void) newrange;
- (void) setupTransforms;
- (void) adjustViewHeirarchy;
- (void) deplaceAlbumsFrom:(int)start to:(int)end;
- (void) deplaceAlbumsAtIndex:(int)cnt;
- (BOOL) placeAlbumsFrom:(int)start to:(int)end;
- (void) placeAlbumAtIndex:(int)cnt;
- (void) snapToAlbum:(BOOL)animated;

@end

#pragma mark -

@implementation TKCoverflowView (hidden)

- (void) createLeftArrow {
    if (self.leftArrowView != nil) {
        [self.leftArrowView removeFromSuperview];
        self.leftArrowView = nil;
    }
    if (self.leftArrowLabel != nil) {
        [self.leftArrowLabel removeFromSuperview];
        self.leftArrowLabel = nil;
    }
    
    UIImage *arrowImage = [UIImage imageNamed:@"whiteArrow.png"];
    self.leftArrowView = [[[UIImageView alloc] initWithFrame:CGRectMake(arrowImage.size.height * (-1), 
                                                                        currentSize.height/2 - arrowImage.size.height/2,
                                                                        arrowImage.size.height, 
                                                                        arrowImage.size.height)] autorelease];
    self.leftArrowView.contentMode = UIViewContentModeCenter;
    self.leftArrowView.image = arrowImage;
    [self addSubview:self.leftArrowView];
    self.leftArrowView.layer.transform = CATransform3DMakeRotation(M_PI/2, 0.0f, 0.0f, 1.0f);
    
    self.leftArrowLabel = [[[UILabel alloc] initWithFrame:CGRectMake(self.leftArrowView.frame.origin.x,
                                                               self.leftArrowView.frame.origin.y + self.leftArrowView.frame.size.height,
                                                               self.leftArrowView.frame.size.width,
                                                               30)] autorelease];
    self.leftArrowLabel.textColor = [UIColor whiteColor];
    self.leftArrowLabel.backgroundColor = [UIColor clearColor];
    self.leftArrowLabel.font = [UIFont systemFontOfSize:14];
    self.leftArrowLabel.text = @"拉动刷新";
    self.leftArrowLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:self.leftArrowLabel];
}

- (void) createRightArrow {
    if (self.rightArrowView != nil) {
        [self.rightArrowView removeFromSuperview];
        self.rightArrowView = nil;
    }
    if (self.rightArrowLabel != nil) {
        [self.rightArrowLabel removeFromSuperview];
        self.rightArrowLabel = nil;
    }
    
    UIImage *arrowImage = [UIImage imageNamed:@"whiteArrow.png"];
    self.rightArrowView = [[[UIImageView alloc] initWithFrame:CGRectMake(self.contentSize.width, 
                                                                         currentSize.height/2 - arrowImage.size.height/2,
                                                                         arrowImage.size.height, 
                                                                         arrowImage.size.height)] autorelease];
    self.rightArrowView.contentMode = UIViewContentModeCenter;
    self.rightArrowView.image = arrowImage;
    [self addSubview:self.rightArrowView];
    self.rightArrowView.layer.transform = CATransform3DMakeRotation(-M_PI/2, 0.0f, 0.0f, 1.0f);
    
    self.rightArrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.rightArrowView.frame.origin.x,
                                                               self.rightArrowView.frame.origin.y + self.rightArrowView.frame.size.height,
                                                               self.rightArrowView.frame.size.width,
                                                               30)];
    self.rightArrowLabel.textColor = [UIColor whiteColor];
    self.rightArrowLabel.backgroundColor = [UIColor clearColor];
    self.rightArrowLabel.font = [UIFont systemFontOfSize:14];
    self.rightArrowLabel.text = @"载入更多";
    self.rightArrowLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:self.rightArrowLabel];
}

- (void)setLeftArrowFlipped:(BOOL)flipped {
    self.isLeftArrowLoading = flipped;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    [self.leftArrowView layer].transform = (flipped ?
                                     CATransform3DMakeRotation(-M_PI/2, 0.0f, 0.0f, 1.0f) :
                                     CATransform3DMakeRotation(M_PI/2, 0.0f, 0.0f, 1.0f));
    [UIView commitAnimations];
}

- (void)setRighttArrowFlipped:(BOOL)flipped {
    self.isRightArrowLoading = flipped;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    [self.rightArrowView layer].transform = (flipped ?
                                            CATransform3DMakeRotation(M_PI/2, 0.0f, 0.0f, 1.0f) :
                                            CATransform3DMakeRotation(-M_PI/2, 0.0f, 0.0f, 1.0f));
    [UIView commitAnimations];
}

#pragma mark Setup
- (void) setupTransforms{

	leftTransform = CATransform3DMakeRotation(coverAngle, 0, 1, 0);
	leftTransform = CATransform3DConcat(leftTransform,CATransform3DMakeTranslation(-spaceFromCurrent, 0, -300));
	
	rightTransform = CATransform3DMakeRotation(-coverAngle, 0, 1, 0);
	rightTransform = CATransform3DConcat(rightTransform,CATransform3DMakeTranslation(spaceFromCurrent, 0, -300));
	
}
- (void) load{
	self.backgroundColor = [UIColor blackColor];
	numberOfCovers = 0;
	coverSpacing = COVER_SPACING;
	coverAngle = SIDE_COVER_ANGLE;
	self.showsHorizontalScrollIndicator = NO;
	super.delegate = self;
	origin = self.contentOffset.x;
	
	yard = [[NSMutableArray alloc] init];
	views = [[NSMutableArray alloc] init];
	
	coverSize = CGSizeMake(224, 224);
	spaceFromCurrent = coverSize.width/2.4;
	[self setupTransforms];


	CATransform3D sublayerTransform = CATransform3DIdentity;
	sublayerTransform.m34 = -0.001;
	[self.layer setSublayerTransform:sublayerTransform];
	
	currentIndex = -1;
	currentSize = self.frame.size;
	
}
- (void) setup{

	currentIndex = -1;
	for(UIView *v in views) [v removeFromSuperview];
	[yard removeAllObjects];
	[views removeAllObjects];
	coverViews = nil;
	
	if(numberOfCovers < 1){
		self.contentOffset = CGPointZero;
		return;
	} 
	
	
	coverViews = [[NSMutableArray alloc] initWithCapacity:numberOfCovers];
	for (unsigned i = 0; i < numberOfCovers; i++) [coverViews addObject:[NSNull null]];
	deck = NSMakeRange(0, 0);
	
	currentSize = self.frame.size;
	margin = (self.frame.size.width / 2);
	self.contentSize = CGSizeMake( (coverSpacing) * (numberOfCovers-1) + (margin*2) , currentSize.height);
	coverBuffer = (int) ((currentSize.width - coverSize.width) / coverSpacing) + 3;
	

	movingRight = YES;
	currentSize = self.frame.size;
	currentIndex = 0;
	self.contentOffset = CGPointZero;


	[self newrange];
	[self animateToIndex:currentIndex animated:NO];
	
}


#pragma mark Manage Visible Covers
- (void) deplaceAlbumsFrom:(int)start to:(int)end{
	if(start >= end) return;
	
	for(int cnt=start;cnt<end;cnt++)
		[self deplaceAlbumsAtIndex:cnt];

}
- (void) deplaceAlbumsAtIndex:(int)cnt{
	if(cnt >= [coverViews count]) return;
	
	if([coverViews objectAtIndex:cnt] != [NSNull null]){
		
		UIView *v = [coverViews objectAtIndex:cnt];
		[v removeFromSuperview];
		[views removeObject:v];
		[yard addObject:v];
		[coverViews replaceObjectAtIndex:cnt withObject:[NSNull null]];
		
	}
}
- (BOOL) placeAlbumsFrom:(int)start to:(int)end{
	if(start >= end) return NO;
	for(int cnt=start;cnt<= end;cnt++) 
		[self placeAlbumAtIndex:cnt];
	return YES;
}
- (void) placeAlbumAtIndex:(int)cnt{
	if(cnt >= [coverViews count]) return;
	
	if([coverViews objectAtIndex:cnt] == [NSNull null]){
		
		TKCoverflowCoverView *cover = [dataSource coverflowView:self coverAtIndex:cnt];
		[coverViews replaceObjectAtIndex:cnt withObject:cover];
		
		CGRect r = cover.frame;
		r.origin.y = currentSize.height / 2 - (coverSize.height/2) - (coverSize.height/16);
		r.origin.x = (currentSize.width/2 - (coverSize.width/ 2)) + (coverSpacing) * cnt;
		cover.frame = r;
		
		[self addSubview:cover];
		if(cnt > currentIndex){
			cover.layer.transform = rightTransform;
			[self sendSubviewToBack:cover];
		}
		else 
			cover.layer.transform = leftTransform;
		
		[views addObject:cover];
		
	}
}

#pragma mark Manage Range and Animations
- (void) newrange{
	
	int loc = deck.location, len = deck.length, buff = coverBuffer;
	int newLocation = currentIndex - buff < 0 ? 0 : currentIndex-buff;
	int newLength = currentIndex + buff > numberOfCovers ? numberOfCovers - newLocation : currentIndex + buff - newLocation;
	
	if(loc == newLocation && newLength == len) return;
	
	if(movingRight){
		[self deplaceAlbumsFrom:loc to:MIN(newLocation,loc+len)];
		[self placeAlbumsFrom:MAX(loc+len,newLocation) to:newLocation+newLength];
		
	}else{
		[self deplaceAlbumsFrom:MAX(newLength+newLocation,loc) to:loc+len];
		[self placeAlbumsFrom:newLocation to:newLocation+newLength];
	}
	
	NSRange spectrum = NSMakeRange(0, numberOfCovers);
	deck = NSIntersectionRange(spectrum, NSMakeRange(newLocation, newLength));
	
	
}
- (void) adjustViewHeirarchy{

	int i = currentIndex-1;
	if (i >= 0) 
		for(;i > deck.location;i--) 
			[self sendSubviewToBack:[coverViews objectAtIndex:i]];
	
	i = currentIndex+1;
	if(i<numberOfCovers-1) 
		for(;i < deck.location+deck.length;i++) 
			[self sendSubviewToBack:[coverViews objectAtIndex:i]];
	
	UIView *v = [coverViews objectAtIndex:currentIndex];
	if((NSObject*)v != [NSNull null])
		[self bringSubviewToFront:[coverViews objectAtIndex:currentIndex]];
	
	
}
- (void) snapToAlbum:(BOOL)animated{
	
	UIView *v = [coverViews objectAtIndex:currentIndex];
	
	if((NSObject*)v!=[NSNull null]){
		[self setContentOffset:CGPointMake(v.center.x - (currentSize.width/2), 0) animated:animated];
	}else{		
		[self setContentOffset:CGPointMake(coverSpacing*currentIndex, 0) animated:animated];
	}
	
}
- (void) animateToIndex:(int)index animated:(BOOL)animated{
	
	NSString *string = [NSString stringWithFormat:@"%d",currentIndex];
	if(velocity> 200) animated = NO;
	
	if(animated){
		float speed = 0.2;
		if(velocity>80)speed=0.05;
		[UIView beginAnimations:string context:nil];
		[UIView setAnimationDuration:speed];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)]; 
	}

	for(UIView *v in views){
		int i = [coverViews indexOfObject:v];
		if(i < index) v.layer.transform = leftTransform;
		else if(i > index) v.layer.transform = rightTransform;
		else v.layer.transform = CATransform3DIdentity;
	}
	
	if(animated) [UIView commitAnimations];
	else [coverflowDelegate coverflowView:self coverAtIndexWasBroughtToFront:currentIndex];

}
- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{

	if([finished boolValue]) [self adjustViewHeirarchy];
	
	if([finished boolValue] && [animationID intValue] == currentIndex) [coverflowDelegate coverflowView:self coverAtIndexWasBroughtToFront:currentIndex];
	
}

@end


#pragma mark -
@implementation TKCoverflowView
@synthesize coverflowDelegate, dataSource, coverSize, numberOfCovers, coverSpacing, coverAngle;
@synthesize leftArrowView;
@synthesize isLeftArrowLoading;
@synthesize isRightArrowLoading;
@synthesize arrowLoadingDelegate;
@synthesize leftArrowLoadingCallback;
@synthesize rightArrowLoadingCallback;
@synthesize rightArrowView;
@synthesize leftArrowLabel;
@synthesize rightArrowLabel;

- (id) initWithFrame:(CGRect)frame {
	if(!(self=[super initWithFrame:frame])) return nil;
	[self load];
	currentSize = frame.size;
    
    [self createLeftArrow];
    
    return self;
}
- (void) dealloc {	
	
	yard = nil;
	views = nil;
	coverViews = nil;
	
	currentTouch = nil;
	coverflowDelegate = nil;
	dataSource = nil;
	
    [leftArrowView release];
    [rightArrowView release];
    [leftArrowLabel release];
    [rightArrowLabel release];
}

- (void) layoutSubviews{
	
	if(self.frame.size.width == currentSize.width && self.frame.size.height == currentSize.height) return;
	currentSize = self.frame.size;
	
	

	
	margin = (self.frame.size.width / 2);
	self.contentSize = CGSizeMake( (coverSpacing) * (numberOfCovers-1) + (margin*2) , self.frame.size.height);
	coverBuffer = (int)((currentSize.width - coverSize.width) / coverSpacing) + 3;
	
	

	for(UIView *v in views){
		v.layer.transform = CATransform3DIdentity;
		CGRect r = v.frame;
		r.origin.y = currentSize.height / 2 - (coverSize.height/2) - (coverSize.height/16);
		v.frame = r;

	}

	for(int i= deck.location; i < deck.location + deck.length; i++){
		
		if([coverViews objectAtIndex:i] != [NSNull null]){
			UIView *cover = [coverViews objectAtIndex:i];
			CGRect r = cover.frame;
			r.origin.x = (currentSize.width/2 - (coverSize.width/ 2)) + (coverSpacing) * i;
			cover.frame = r;
		}
	}
	


	[self newrange];
	[self animateToIndex:currentIndex animated:NO];
	

}


#pragma mark Public Methods

- (TKCoverflowCoverView *) coverAtIndex:(int)index{
	if([coverViews objectAtIndex:index] != [NSNull null]) return [coverViews objectAtIndex:index];
	return nil;
}
- (NSInteger) indexOfFrontCoverView{
	return currentIndex;

}
- (void) bringCoverAtIndexToFront:(int)index animated:(BOOL)animated{
	
	if(index == currentIndex) return;
	
    currentIndex = index;
    [self snapToAlbum:animated];
	[self newrange];
	[self animateToIndex:index animated:animated];
}
- (TKCoverflowCoverView*) dequeueReusableCoverView{
	
	if([yard count] < 1)  return nil;
	
	TKCoverflowCoverView *v = [[yard lastObject] retain];
	v.layer.transform = CATransform3DIdentity;
	[yard removeLastObject];

	return v;
}

#pragma mark Touch Events
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	if(touch.view != self &&  [touch locationInView:touch.view].y < coverSize.height){
		currentTouch = touch.view;
	}

}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	UITouch *touch = [touches anyObject];
	
	if(touch.view == currentTouch){
		if(touch.tapCount > 1 && currentIndex == [coverViews indexOfObject:currentTouch]){

			if([coverflowDelegate respondsToSelector:@selector(coverflowView:coverAtIndexWasDoubleTapped:)])
				[coverflowDelegate coverflowView:self coverAtIndexWasDoubleTapped:currentIndex];
			
		}else{
			int index = [coverViews indexOfObject:currentTouch];
			[self setContentOffset:CGPointMake(coverSpacing*index, 0) animated:YES];
		}
		

	}
	
	currentTouch = nil;
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	if(currentTouch!= nil) currentTouch = nil;
}

#pragma mark UIScrollView Delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    float leftArrowOffset = self.leftArrowView.frame.size.width * (-1);
    float rightArrowOffset = self.contentSize.width + self.rightArrowView.frame.size.width;
    if (self.contentOffset.x < leftArrowOffset) {
        [self setLeftArrowFlipped:YES];
    }
    else if (self.contentOffset.x > leftArrowOffset && 
             self.contentOffset.x < 0) {
        [self setLeftArrowFlipped:NO];
    }
    
    if (self.contentOffset.x + 320 > rightArrowOffset) {
        [self setRighttArrowFlipped:YES];
    }
    else if (self.contentOffset.x + 320 > self.contentSize.width &&
             self.contentOffset.x + 320 < rightArrowOffset) {
        [self setRighttArrowFlipped:NO];
    }
    
    
	velocity = abs(pos - scrollView.contentOffset.x);
	pos = scrollView.contentOffset.x;
	movingRight = self.contentOffset.x - origin > 0 ? YES : NO;
	origin = self.contentOffset.x;

	CGFloat num = numberOfCovers;
	CGFloat per = scrollView.contentOffset.x / (self.contentSize.width - currentSize.width);
	CGFloat ind = num * per;
	CGFloat mi = ind / (numberOfCovers/2);
	mi = 1 - mi;
	mi = mi / 2;
	int index = (int)(ind+mi);
	index = MIN(MAX(0,index),numberOfCovers-1);
	

	if(index == currentIndex) return;
	
	currentIndex = index;
	[self newrange];
	
	
	if(velocity < 180 || currentIndex < 15 || currentIndex > (numberOfCovers - 16))
		[self animateToIndex:index animated:YES];

}


- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	if(!scrollView.tracking && !scrollView.decelerating){
		[self snapToAlbum:YES];
		[self adjustViewHeirarchy];
	} 
}
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
	if(!self.decelerating && !decelerate){
		[self snapToAlbum:YES];
		[self adjustViewHeirarchy];
	}
    
    if (self.isLeftArrowLoading) {
        if (self.arrowLoadingDelegate && [self.arrowLoadingDelegate respondsToSelector:self.leftArrowLoadingCallback]) {
            [self.arrowLoadingDelegate performSelector:self.leftArrowLoadingCallback];
        }
    }
    if (self.isRightArrowLoading) {
        if (self.arrowLoadingDelegate && [self.arrowLoadingDelegate respondsToSelector:self.rightArrowLoadingCallback]) {
            [self.arrowLoadingDelegate performSelector:self.rightArrowLoadingCallback];
        }
    }
}


#pragma mark Properties
- (void) setNumberOfCovers:(int)cov{
	numberOfCovers = cov;
	[self setup];
    
    [self createRightArrow];
}
- (void) setCoverSpacing:(float)space{
	coverSpacing = space;
	[self setupTransforms];
	[self setup];
	[self layoutSubviews];
}
- (void) setCoverAngle:(float)f{
	coverAngle = f;
	[self setupTransforms];
	[self setup];
}
- (void) setCoverSize:(CGSize)s{
	coverSize = s;
	spaceFromCurrent = coverSize.width/2.4;
	[self setupTransforms];
	[self setup];
}
- (void) setCurrentIndex:(NSInteger)index{
	[self bringCoverAtIndexToFront:index animated:NO];
}
- (NSInteger) currentIndex{
	return currentIndex;
}

@end