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
        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
        button.frame = CGRectMake(150, 100, 100, 50);
        [button addTarget:self action:@selector(pointButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    
    
    [self.view addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50, 50, 50, 50);
        [button setBackgroundColor:[UIColor redColor]];
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

    if (CGPointEqualToPoint(sender.center, CGPointMake(200, 125)) ) {
        animation1.fromValue = [NSValue valueWithCGPoint:CGPointMake(200, 125)];
        animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(250, 200)];
    }
    else {
        animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 125)];
        animation1.fromValue = [NSValue valueWithCGPoint:CGPointMake(250, 200)];
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
    
    if (CGSizeEqualToSize(sender.frame.size, CGSizeMake(50, 50)) ) {
        animation1.fromValue = [NSValue valueWithCGSize:CGSizeMake(50, 50)];
        animation1.toValue = [NSValue valueWithCGSize:CGSizeMake(150, 150)];
    }
    else {
        animation1.fromValue = [NSValue valueWithCGSize:CGSizeMake(150, 150)];
        animation1.toValue = [NSValue valueWithCGSize:CGSizeMake(50, 50)];
    }
    [sender ch_addAnimation:animation1 forKey:@"2"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
