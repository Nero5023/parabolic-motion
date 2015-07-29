//
//  ViewController.m
//  horizontal_throw
//
//  Created by Nero Zuo on 15/7/29.
//  Copyright (c) 2015年 Nero Zuo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollisionBehaviorDelegate>
@property (weak, nonatomic) IBOutlet UIView *animationView;

@end

@implementation ViewController{
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UICollisionBehavior *_collision;
    UIDynamicItemBehavior *_itemBehavior;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self horizontalProjectileMotionWithView:self.animationView in:self.view from:CGPointMake(24, 54)  to:CGPointMake(330, 300)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)horizontalProjectileMotionWithView:(UIView *)motionView in:(UIView *)referenceView from:(CGPoint)fromPoint to:(CGPoint)toPotint {
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView: referenceView];
    _collision = [[UICollisionBehavior alloc] initWithItems:@[motionView]];
    _itemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[motionView]];
    _itemBehavior.elasticity = 0.0;
    _itemBehavior.resistance = 0.0;
    _collision.collisionDelegate = self;
    CGRect screenRect = [UIScreen mainScreen].bounds;
    if (fromPoint.y == toPotint.y) {
        CGFloat screenHeight = screenRect.size.height;
        CGFloat vel = (toPotint.x - fromPoint.x) / 0.35f;  //0.35 is animation duration
        CGFloat boundX = toPotint.x + motionView.frame.size.width;
        [_collision addBoundaryWithIdentifier:@"vertical bounds" fromPoint:CGPointMake(boundX, 0.0) toPoint:CGPointMake(boundX, screenHeight)];
        [_itemBehavior addLinearVelocity:CGPointMake(vel, 0) forItem:motionView];
        [_animator addBehavior:_collision];
        [_animator addBehavior:_itemBehavior];
        return;
    }
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[motionView]];
    
    _gravity.magnitude = 1.0;    //set magnitude to change Gravitational acceleration
    CGFloat screenWidth = screenRect.size.width;
    [_collision addBoundaryWithIdentifier:@"horizontal bounds" fromPoint:CGPointMake(-100.0, toPotint.y + motionView.frame.size.height) toPoint:CGPointMake(screenWidth + 100.0, toPotint.y + motionView.frame.size.height)];
    [_animator addBehavior:_gravity];
    [_animator addBehavior:_collision];
    CGPoint vel = CGPointMake([self horizontalSpeedFromPoint:fromPoint to:toPotint], 0.0);
    [_itemBehavior addLinearVelocity:vel forItem:motionView];
   
    [_animator addBehavior:_itemBehavior];
    
}

- (CGFloat)horizontalSpeedFromPoint:(CGPoint)fromPoint to:(CGPoint)toPoint {
    
    CGFloat verticalSpace = toPoint.y - fromPoint.y;
    CGFloat duration = sqrt(verticalSpace* 2.0f / (1000.0f * _gravity.magnitude)) ;
    CGFloat horizontalSpace = toPoint.x - fromPoint.x;
    CGFloat horizontalSpeed = horizontalSpace / duration;
    return horizontalSpeed;
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    CGPoint vel = [_itemBehavior linearVelocityForItem:item];
    [_itemBehavior addLinearVelocity:CGPointMake(-vel.x, -vel.y) forItem:item];//when collision happened make velocity to 0
    
}

@end
