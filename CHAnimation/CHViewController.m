//
//  CHViewController.m
//  CHAnimation
//
//  Created by hangchen on 5/20/14.
//  Copyright (c) 2014 hangchen. All rights reserved.
//

#import "CHViewController.h"
#import "CHAnimation.h"

@interface CHViewController ()

@end

@implementation CHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, 20, 100, 100);
        [button setBackgroundColor:[UIColor blueColor]];
        [button setTitle:@"Tap!" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pointButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    
    
    [self.view addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100, 300, 100, 100);
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitle:@"Tap!" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sizeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    

}

- (void)pointButtonAction:(UIButton*)sender;
{
    CHAnimation *animation1 = [CHAnimation new];
    animation1.duration = 0.4;
    
    animation1.writeBlock = ^(id obj, id value) {
        sender.center = [value CGPointValue];
    };

    if (CGPointEqualToPoint(sender.center, CGPointMake(70, 70)) ) {
        animation1.fromValue = [NSValue valueWithCGPoint:CGPointMake(70, 70)];
        animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(170, 170)];
    }
    else {
        animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(70, 70)];
        animation1.fromValue = [NSValue valueWithCGPoint:CGPointMake(170, 170)];
    }
    [sender ch_addAnimation:animation1 forKey:@"1"];

}


- (void)sizeButtonAction:(UIButton*)sender;
{
    CHAnimation *animation1 = [CHAnimation new];
    animation1.duration = 0.4;
    
    animation1.writeBlock = ^(id obj, id value) {
        CGPoint center = sender.center;
        CGSize size = [value CGSizeValue];
        sender.frame = CGRectMake(center.x - size.width/2, center.y - size.height/2, size.width, size.height);
    };
    
    if (CGSizeEqualToSize(sender.frame.size, CGSizeMake(100, 100)) ) {
        animation1.fromValue = [NSValue valueWithCGSize:CGSizeMake(100, 100)];
        animation1.toValue = [NSValue valueWithCGSize:CGSizeMake(200, 200)];
    }
    else {
        animation1.toValue = [NSValue valueWithCGSize:CGSizeMake(100, 100)];
        animation1.fromValue = [NSValue valueWithCGSize:CGSizeMake(200, 200)];
    }
    [sender ch_addAnimation:animation1 forKey:@"2"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
