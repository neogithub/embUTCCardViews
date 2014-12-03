//
//  embViewController.m
//  embUTCCardViews
//
//  Created by Evan Buxton on 11/25/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import "embViewController.h"
#import "embUiViewCard.h"
#import <AVFoundation/AVFoundation.h>
#import "NSTimer+CVPausable.h"

@interface embViewController ()
{
	NSMutableArray *arr_HotspotInfoCards;
	UIView *uiv_HotspotInfoCardContainer;
	AVPlayer *player;
}

@property (nonatomic) NSTimer *myTimer;

@end

@implementation embViewController



//----------------------------------------------------
#pragma mark - view hierarchy
//----------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// init arrays and create avplayer
	arr_HotspotInfoCards = [[NSMutableArray alloc] init];
	[self createAVPlayer];
	
	// start player and timer, create infocards
	[self beginSequence];
}

//----------------------------------------------------
#pragma mark - start sequences
//----------------------------------------------------
/*
 start all info cards and movie in motion
 */
-(void)beginSequence
{
	[player play];
	[self addTimerToPlayer];
	[self createCards];
}

//----------------------------------------------------
#pragma mark - info cards
//----------------------------------------------------
/*
 create info cards from model
 */
-(void)createCards
{
	uiv_HotspotInfoCardContainer = [[UIView alloc] initWithFrame:CGRectZero];
	uiv_HotspotInfoCardContainer.layer.backgroundColor = [UIColor clearColor].CGColor;
	uiv_HotspotInfoCardContainer.clipsToBounds = YES;
	
	[self.view addSubview:uiv_HotspotInfoCardContainer];
	
	CGFloat tt = 0;
	
	embUiViewCard *card = [[embUiViewCard alloc] init];
	card.delay = 1;
	card.text = @"Fireworks Graphical Command Interface/Incident Management Platform";
	[card setFrame:CGRectMake(0, tt, 360, [self measureHeightOfUITextView:card.textView])];
	card.alpha = 0;
	[arr_HotspotInfoCards addObject:card];
	[uiv_HotspotInfoCardContainer addSubview:card];
	
	tt += [self measureHeightOfUITextView:card.textView];
	NSLog(@"%f",tt);
	
	card = [[embUiViewCard alloc] init];
	card.delay = 3;
	card.text = @"Monitor and control all necessary life safety network information through a graphic display of your facilities down to the detail of a single location";
	[card setFrame:CGRectMake(0, tt, 360, [self measureHeightOfUITextView:card.textView])];
	card.alpha = 0;
	[arr_HotspotInfoCards addObject:card];
	[uiv_HotspotInfoCardContainer addSubview:card];
	
	tt += [self measureHeightOfUITextView:card.textView];
	NSLog(@"%f",tt);
	
	card = [[embUiViewCard alloc] init];
	card.delay = 7;
	card.text = @"Communicates other emergency events — weather, shelter in place, chemical spill, etc. — in lieu of an unsupervised intercom system";
	[card setFrame:CGRectMake(0, tt, 360, [self measureHeightOfUITextView:card.textView])];
	card.alpha = 0;
	[arr_HotspotInfoCards addObject:card];
	[uiv_HotspotInfoCardContainer addSubview:card];
	
	tt += [self measureHeightOfUITextView:card.textView];
	
	card = [[embUiViewCard alloc] init];
	card.delay = 11;
	card.text = @"Optimum Start assures comfortable settings at time of occupancy based on building conditions and system capacity. Demand Reduction reduces energy use on a short-term basis in response to utility pricing, billing criteria, regional consumption, etc.";
	[card setFrame:CGRectMake(0, tt, 360, [self measureHeightOfUITextView:card.textView])];
	card.alpha = 0;
	[arr_HotspotInfoCards addObject:card];
	[uiv_HotspotInfoCardContainer addSubview:card];
	
	tt += [self measureHeightOfUITextView:card.textView];
	NSLog(@"%f",tt);
	
	// update container frame now that we know the heights
	uiv_HotspotInfoCardContainer.frame = CGRectMake(120, 200, 360, tt);
	
}

-(void)removeCards
{
	NSInteger i = 0;
	
	for (embUiViewCard *card in arr_HotspotInfoCards)
	{
		
		UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction;
		[UIView animateWithDuration:.2 delay:((0.05 * i) + 0.2) options:options
						 animations:^{
							 card.alpha = 0.0;
						 }
						 completion:^(BOOL finished){
							 [arr_HotspotInfoCards removeObject:card];
						 }];
		i += 1;
	}
}

//----------------------------------------------------
#pragma mark find card that should appear
//----------------------------------------------------

// find card and remove
-(void)indexOfCardToReveal:(int)index
{
	for (embUiViewCard *card in arr_HotspotInfoCards)
	{
		if (card.delay == index) {
			embUiViewCard *ccard = arr_HotspotInfoCards[[arr_HotspotInfoCards indexOfObject:card]];
			[self revealCard:ccard afterDelay:0];
		}
	}
	
}

//----------------------------------------------------
#pragma mark reveal card
//----------------------------------------------------

// reveal card
-(void)revealCard:(embUiViewCard*)card afterDelay:(CGFloat)delay
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				
		card.alpha = 1.0;
		CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		
		NSLog(@"%@",[card description]);

		
		// get index of card to know whether
		// to animate it bouncing/falling
		
		NSUInteger index = [arr_HotspotInfoCards indexOfObject:card];
		
		embUiViewCard *ccard;
		ccard =  [arr_HotspotInfoCards objectAtIndex:index];
		
		CGFloat startPointX = card.center.x;
		CGFloat startPointY = card.center.y;

		NSLog(@"rect1: %f", startPointY);
		

		UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(card.frame.origin.x, card.frame.origin.y, 360, card.frame.size.height+20)];
		maskView.layer.backgroundColor = [UIColor clearColor].CGColor;
		maskView.clipsToBounds = YES;
		[maskView addSubview:card];
		[uiv_HotspotInfoCardContainer addSubview:maskView];
		
		NSArray *values;
		
		if (index == 0) { // no animation of falling/bouncing
			values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(startPointX, startPointY)],
					  [NSValue valueWithCGPoint:CGPointMake(startPointX, startPointY)], nil];
		} else {
			values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(startPointX, -card.frame.size.height/2)],
					  [NSValue valueWithCGPoint:CGPointMake(startPointX, card.frame.size.height/1.9)],
					  [NSValue valueWithCGPoint:CGPointMake(startPointX, card.frame.size.height/2.1)],
					  [NSValue valueWithCGPoint:CGPointMake(startPointX, card.frame.size.height/1.95)],
					  [NSValue valueWithCGPoint:CGPointMake(startPointX, card.frame.size.height/2)], nil];
		}

		[anim setValues:values];
		[anim setDuration:1.0]; //seconds
		anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

		[card.layer addAnimation:anim forKey:@"position"];

		[card setCenter:CGPointMake(startPointX, card.frame.size.height/2)];
				
		NSLog(@"rect1: %@", NSStringFromCGRect(card.frame));
		
		CALayer *mask = [CALayer layer];
		mask.contents = (id)[[UIImage imageNamed:@"card_mask.png"] CGImage];
		
		if (index == 0) {
			mask.frame = CGRectMake(0, 0, 0, 0);
			mask.anchorPoint = CGPointMake(0, 0);
			
			card.layer.mask = mask;
			
			CGRect oldBounds = mask.bounds;
			CGRect newBounds = card.bounds;
			
			CABasicAnimation* revealAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
			revealAnimation.fromValue = [NSValue valueWithCGRect:oldBounds];
			revealAnimation.toValue = [NSValue valueWithCGRect:newBounds];
			revealAnimation.duration = 0.33;
			
			// Update the bounds so the layer doesn't snap back when the animation completes.
			mask.bounds = newBounds;
			
			[mask addAnimation:revealAnimation forKey:@"revealAnimation"];
			
		}

	});
}

//----------------------------------------------------
#pragma mark pause card animations
//----------------------------------------------------
/*
 actions for pausing and resuming animations
 */



- (IBAction)pauseAnimation
{
	[_myTimer pauseOrResume];
	
	[player pause];
		
	for (embUiViewCard *card in arr_HotspotInfoCards)
	{
		[self pauseLayer:card.layer];
	}
}

- (IBAction)resumeAnimation
{
	[player play];
	
	if (_myTimer.isPaused) {
		[_myTimer pauseOrResume];
	}
	
	for (embUiViewCard *card in arr_HotspotInfoCards)
	{
		[self resumeLayer:card.layer];
	}
}

-(void)pauseLayer:(CALayer*)layer
{
	CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
	layer.speed = 0.0;
	layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

//----------------------------------------------------
#pragma mark - movie player
//----------------------------------------------------
-(void)createAVPlayer
{
	NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"05_HOTSPOT_A_COATED_STEEL_BELTS" withExtension:@"mov"];
	AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
	AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
	
	player = [AVPlayer playerWithPlayerItem:playerItem];
	AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
	playerLayer.frame = CGRectMake(0, 0, 1024, 768);
	playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	
	NSString *selectorAfterMovieFinished;
	selectorAfterMovieFinished = @"playerItemLoop:";
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:NSSelectorFromString(selectorAfterMovieFinished)
												 name:AVPlayerItemDidPlayToEndTimeNotification
											   object:[player currentItem]];
	
	[self.view.layer insertSublayer:playerLayer atIndex:0];
}

//----------------------------------------------------
#pragma mark movie loop
//----------------------------------------------------
/*
 movie in the background
 */
-(void)playerItemLoop:(NSNotification *)notification
{
	AVPlayerItem *p = [notification object];
	[p seekToTime:kCMTimeZero];
	
	
	[self beginSequence];
}

//----------------------------------------------------
#pragma mark - timer
//----------------------------------------------------
/*
 keeps track of number seconds elapsed
 to help sync which card to reveal next
 */

-(void)addTimerToPlayer
{
	if (_myTimer) {
		[self.myTimer invalidate];
        self.myTimer = nil;
	}
	
	self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(displayMyCurrentTime:)
                                                  userInfo:nil
                                                   repeats:YES];
	
	NSLog(@"start timer");
}


//----------------------------------------------------
#pragma mark - utilties
//----------------------------------------------------
/*
 calculate height of
 */
- (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if ([textView respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
		
        CGRect frame = textView.bounds;
		
        // Take account of the padding added around the text.
		
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
		
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
		
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
		
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
		
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
		
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
		
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:18.5], NSParagraphStyleAttributeName : paragraphStyle };
		
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(360, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
		
		NSLog(@"fontSize = \tbounds = (%f x %f)",
			  size.size.width,
			  size.size.height);
		
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
		
		NSLog(@"measuredHeight %f)",
			  measuredHeight);
		
        return measuredHeight;
    }
    else
    {
        return textView.contentSize.height;
    }
}

/*
 as each second passes check if the seconds
 match the reveal delay
 */
- (void)displayMyCurrentTime:(NSTimer *)timer
{
	CGFloat movieLength = CMTimeGetSeconds([player currentTime]);
	
	int y = movieLength;
	NSLog(@"seconds %i",y);
	
	if (y == 13) {
		[self removeCards];
	}
	
	// check if the seconds match the reveal delay
	[self indexOfCardToReveal:y];
}


//----------------------------------------------------
#pragma mark - boilerplate
//----------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
