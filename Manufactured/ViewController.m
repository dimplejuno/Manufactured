//
//  ViewController.m
//  Manufactured
//
//  Created by Steve Park on 2013. 6. 21..
//  Copyright (c) 2013년 Steve Park. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate>
{
    UICollisionBehavior* collisionBehavior;
    UIPushBehavior* pushBehavior;
}

@property (nonatomic, weak) UIImageView *twitter;
@property (nonatomic) UIDynamicAnimator* animator;

@end

@implementation ViewController

-(void)makeView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 10, self.view.frame.size.height/2 - 10, 20, 20)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    view.layer.borderWidth = 2;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.cornerRadius = CGRectGetHeight(view.bounds) / 2;
    view.clipsToBounds = YES;
    
    [self.view addSubview:view];
}


-(void)loadView {
    [super loadView];
    
    UIImageView *twitter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconmonstr-twitter-icon"]];
    twitter.tag = 18;
    self.twitter = twitter;
    
    self.twitter.tintColor = [UIColor redColor];
    self.twitter.center = self.view.center;
    
    [self.view addSubview:twitter];
    
    for(int i=0; i<100; i++) {
        [self makeView];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.view.gestureRecognizers = @[tapRecognizer];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:[self.view subviews]];
    collisionBehavior.collisionDelegate = self;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.twitter] mode:UIPushBehaviorModeInstantaneous];
    
    pushBehavior.angle = 0.0;
    pushBehavior.magnitude = 0.0;

    [self.animator addBehavior:pushBehavior];
    [self.animator addBehavior:collisionBehavior];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    CGPoint p = [gesture locationInView:self.view];
    
    CGPoint o = self.twitter.center;
    
    CGFloat distance = sqrtf(powf(p.x-o.x, 2.0)+powf(p.y-o.y, 2.0));
    
    CGFloat angle = atan2(p.y-o.y, p.x-o.x);
    
    distance = MIN(distance, 100.0);
    
     
    // These two lines change the actual force vector.
    [pushBehavior setMagnitude:distance / 100.0];
    [pushBehavior setAngle:angle];
    [pushBehavior setActive:TRUE];

    
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p {
    UIView *twitter = (UIView*)item1;
    if(twitter.tag == 18) {
        UIView *view = (UIView *)item2;
        switch(arc4random()%3) {
            case 0:
                view.backgroundColor = [UIColor blueColor];
                break;
            case 1:
                view.backgroundColor = [UIColor redColor];
                break;
            case 2:
                view.backgroundColor = [UIColor greenColor];
                break;
        }
        
    }
    
}



- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 {
    
    UIView *view = (UIView *)item2;
    view.backgroundColor = [UIColor lightGrayColor];
}


@end
