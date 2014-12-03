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
	CALayer *mlayer;
	NSMutableArray *cards;
	NSMutableArray *pauseTime;
	CGFloat movieLength;
	AVPlayer *player;
	CGFloat prevXCardCenter;
	UIView *cardContainer;
}

@property (nonatomic) NSTimer *myTimer;

@end

@implementation embViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	cards = [[NSMutableArray alloc] init];
	pauseTime = [[NSMutableArray alloc] init];
	
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
	
	[self timerandcards];
}

-(void)timerandcards
{
	[player play];
	[self addTimerToPlayer];
	[self createCards];
}

-(void)createCards
{
	cardContainer = [[UIView alloc] initWithFrame:CGRectZero];
	cardContainer.layer.backgroundColor = [UIColor clearColor].CGColor;
	cardContainer.clipsToBounds = YES;
	
	[self.view addSubview:cardContainer];
	
	CGFloat tt = 0;
	
	embUiViewCard *card = [[embUiViewCard alloc] init];
	card.delay = 1;
	card.text = @"Fireworks Graphical Command Interface/Incident Management Platform";
	[card setFrame:CGRectMake(0, tt, 360, [self measureHeightOfUITextView:card.textView])];
	card.alpha = 0;
	[cards addObject:card];
	[cardContainer addSubview:card];
	
	tt += [self measureHeightOfUITextView:card.textView];
	NSLog(@"%f",tt);
	
	card = [[embUiViewCard alloc] init];
	card.delay = 3;
	card.text = @"Monitor and control all necessary life safety network information through a graphic display of your facilities down to the detail of a single location";
	[card setFrame:CGRectMake(0, tt, 360, [self measureHeightOfUITextView:card.textView])];
	card.alpha = 0;
	[cards addObject:card];
	[cardContainer addSubview:card];
	
	tt += [self measureHeightOfUITextView:card.textView];
	NSLog(@"%f",tt);
	
	card = [[embUiViewCard alloc] init];
	card.delay = 7;
	card.text = @"Communicates other emergency events — weather, shelter in place, chemical spill, etc. — in lieu of an unsupervised intercom system";
	[card setFrame:CGRectMake(0, tt, 360, [self measureHeightOfUITextView:card.textView])];
	card.alpha = 0;
	[cards addObject:card];
	[cardContainer addSubview:card];
	
	tt += [self measureHeightOfUITextView:card.textView];
	
	card = [[embUiViewCard alloc] init];
	card.delay = 11;
	card.text = @"Optimum Start assures comfortable settings at time of occupancy based on building conditions and system capacity. Demand Reduction reduces energy use on a short-term basis in response to utility pricing, billing criteria, regional consumption, etc.";
	[card setFrame:CGRectMake(0, tt, 360, [self measureHeightOfUITextView:card.textView])];
	card.alpha = 0;
	[cards addObject:card];
	[cardContainer addSubview:card];
	
	tt += [self measureHeightOfUITextView:card.textView];
	NSLog(@"%f",tt);
	
	// update container frame now that we know the heights
	cardContainer.frame = CGRectMake(120, 200, 360, tt);

}

-(void)playerItemLoop:(NSNotification *)notification
{
	AVPlayerItem *p = [notification object];
	[p seekToTime:kCMTimeZero];
	
		
	[self timerandcards];
}

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

//- (CGFloat)heightForTextView:(embUiViewCard*)card containingString:(NSString*)string
//{
//    float horizontalPadding = 24;
//    float verticalPadding = 15;
//	// float widthOfTextView = card.textView.contentSize.width - horizontalPadding;
//	//float height = [string sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(360, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
//	CGFloat fontSize = 17;
//	CGRect r = [card.text boundingRectWithSize:CGSizeMake(360, 0)
//								  options:NSStringDrawingUsesDeviceMetrics
//							   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
//								  context:nil];
//	
//	float height = r.size.height + verticalPadding;
//	
//	NSLog(@"fontSize = %f\tbounds = (%f x %f)",
//		  fontSize,
//		  r.size.width,
//		  r.size.height);
//	
//    return height;
//}
//
//-(void)textHeight:(NSString*)text
//{
//	for (NSNumber *n in @[@(0.0f), @(0.0f), @(17.0f)]) {
//		CGFloat fontSize = [n floatValue];
//		CGRect r = [text boundingRectWithSize:CGSizeMake(200, 0)
//										   options:NSStringDrawingUsesLineFragmentOrigin
//										attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
//										   context:nil];
////		NSLog(@"fontSize = %f\tbounds = (%f x %f)",
////			  fontSize,
////			  r.size.width,
////			  r.size.height);
//	}
//
//}

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

- (void)displayMyCurrentTime:(NSTimer *)timer
{
	
	//NSLog(@"displayMyCurrentTime");
	
//  float dur = CMTimeGetSeconds([player currentTime]);
//  float durInMiliSec = 1000.0 * dur;
//  if (durInMiliSec > 0.0) NSLog(@"CMT %0.3f", durInMiliSec);

	movieLength = CMTimeGetSeconds([player currentTime]);
//  if (movieLength > 0.0) NSLog(@"CMT %f Seconds", movieLength);
	
	//embUiViewCard *ccard;
	int y = movieLength;
	NSLog(@"seconds %i",y);
	
	if (y == 13) {
		[self removeCards];
	}
	
	[self indexOfCardToReveal:y];
}

-(void)indexOfCardToReveal:(int)index
{
	for (embUiViewCard *card in cards)
	{
		if (card.delay == index) {
			embUiViewCard *ccard = cards[[cards indexOfObject:card]];
			[self revealCard:ccard afterDelay:0];
		}
	}
	
	/*
	switch (index) {
		case 3:
			ccard = cards[0];
			
			break;
			
		case 5:
			ccard = cards[1];
			break;
			
		case 7:
			ccard = cards[2];
			break;
			
		case 11:
			ccard = cards[3];
			break;
			
		default:
			break;
	}

	[self revealCard:ccard afterDelay:0];
	 */
}

-(void)revealCard:(embUiViewCard*)card afterDelay:(CGFloat)delay
{
	
	//__block CGFloat newX;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				
		card.alpha = 1.0;
		CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		
		NSLog(@"%@",[card description]);

		
		// get index of card to know whether
		// to animate it bouncing/falling
		
		NSUInteger index = [cards indexOfObject:card];
		NSLog(@"%i",index);
		
		embUiViewCard *ccard;
		ccard =  [cards objectAtIndex:index];
		
//if (index == 0)
//{
//	NSLog(@"asdas");
//	int previndex = (int)index - 1;
//	NSLog(@"%i",previndex);
//	
//	ccard =  [cards objectAtIndex:index];
//	//prevXCardCenter = ccard.center.y;
//	
//	CGRect aRect = CGRectMake(280., 235, ccard.frame.size.width , ccard.frame.size.height);
//	NSLog(@"aRect: %@", NSStringFromCGRect(aRect));
//
//}
		
		CGFloat startValueX = card.frame.origin.x;
		CGFloat startValueY = card.frame.origin.y;
		
		CGFloat startPointX = card.center.x;
		CGFloat startPointY = card.center.y;

		NSLog(@"rect1: %f", startPointY);
		

		UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(card.frame.origin.x, card.frame.origin.y, 360, card.frame.size.height+20)];
		
		// ...position maskView...
		//maskView.layer.position = CGPointMake(CGRectGetMidX([self.view bounds]), CGRectGetMidY([self.view bounds]));
		
		maskView.layer.backgroundColor = [UIColor clearColor].CGColor;
		
		maskView.clipsToBounds = YES;

		[maskView addSubview:card];
		
		[cardContainer addSubview:maskView];


		
//		// MASK WORKS
//		CALayer *mask = [CALayer layer];
//		mask.contents = (id)[[UIImage imageNamed:@"card_mask.png"] CGImage];
//		
////		if (index == 0) {
////			mask.frame = CGRectMake(0, 0, 0, 0);
////			mask.anchorPoint = CGPointMake(0, 0);
////		} else {
//			mask.frame = CGRectMake(0, startValueY, 360, card.frame.size.height);
////			mask.anchorPoint = CGPointMake(.5, 0);
////		}
//		
//		card.layer.mask = mask;
//		
//		CGRect oldBounds = mask.bounds;
//		CGRect newBounds = card.bounds;
//		
//		CABasicAnimation* revealAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
//		revealAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 360, card.frame.size.height)];
//		revealAnimation.toValue = [NSValue valueWithCGRect:newBounds];
//		revealAnimation.duration = 0.33;
//		
//		// Update the bounds so the layer doesn't snap back when the animation completes.
//		mask.bounds = newBounds;
//		
//		[mask addAnimation:revealAnimation forKey:@"revealAnimation"];
//		// END MASK WORKS
		
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
		
		//card.layer.position = CGPointMake(280, 235+prevXCardCenter);
		
		NSLog(@"rect1: %@", NSStringFromCGRect(card.frame));
		
		
		
// KIND OF WORKS
//				int index = [cards indexOfObject:card];
//
//				newX = index*95;
//		
//			
//				CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//				
//		//NSArray *times = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.33], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:1.0], nil];
//				//		[anim setKeyTimes:times];
//			NSArray *values;
//			if (index == 0) {
//				values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(280., 200.)],
//						  [NSValue valueWithCGPoint:CGPointMake(280., 235+newX)], nil];
//			} else {
//				values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(280., 235.+newX)],
//						  [NSValue valueWithCGPoint:CGPointMake(280., 235+newX)], nil];
//			}
//			
//			[anim setValues:values];
//			[anim setDuration:.33]; //seconds
//			//[anim setCalculationMode:kCAAnimationCubicPaced];
//			
//			[card.layer addAnimation:anim forKey:@"position"];
// END KIND OF WORKS

		
// MASK WORKS
//			CALayer *mask = [CALayer layer];
//			mask.contents = (id)[[UIImage imageNamed:@"card_mask.png"] CGImage];
//			
//			if (index == 0) {
//				mask.frame = CGRectMake(0, 0, 0, 0);
//				mask.anchorPoint = CGPointMake(0, 0);
//			} else {
//				mask.frame = CGRectMake(0, 0, 360, 0);
//				mask.anchorPoint = CGPointMake(.5, 0);
//			}
//			
//			card.layer.mask = mask;
//			
//			CGRect oldBounds = mask.bounds;
//			CGRect newBounds = card.bounds;
//			
//			CABasicAnimation* revealAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
//			revealAnimation.fromValue = [NSValue valueWithCGRect:oldBounds];
//			revealAnimation.toValue = [NSValue valueWithCGRect:newBounds];
//			revealAnimation.duration = 0.33;
//			
//			// Update the bounds so the layer doesn't snap back when the animation completes.
//			mask.bounds = newBounds;
//			
//			[mask addAnimation:revealAnimation forKey:@"revealAnimation"];
// END MASK WORKS
		
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

		
		//[card setCenter:CGPointMake(280., 235)];
		//[card setCenter:CGPointMake(280., 235+card.center.y+card.frame.size.height)];

		//NSLog(@"rect1: %@", NSStringFromCGRect(card.frame));

	});
}

- (IBAction)pauseAnimation
{
	[_myTimer pauseOrResume];
	
	[player pause];
		
	for (embUiViewCard *card in cards)
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
	
	for (embUiViewCard *card in cards)
	{
		[self resumeLayer:card.layer];
	}
}

-(void)removeCards
{
	NSInteger i = 0;

	for (embUiViewCard *card in cards)
	{
		
		UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction;
		[UIView animateWithDuration:.2 delay:((0.05 * i) + 0.2) options:options
						 animations:^{
							 card.alpha = 0.0;
						 }
						 completion:^(BOOL finished){
							 [cards removeObject:card];
						 }];
	
		i += 1;
	}
}


-(void)pauseLayer:(CALayer*)layer
{
    
		CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
		layer.speed = 0.0;
		layer.timeOffset = pausedTime;
	
	CGFloat t = pausedTime;
	
	[pauseTime addObject:[NSNumber numberWithFloat:t]];

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end