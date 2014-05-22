//
//  CHPopUpMenu.m
//  CHAnimation
//
//  Created by hangchen on 5/20/14.
//  Copyright (c) 2014 Hang Chen (https://github.com/cyndibaby905)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "CHPopUpMenu.h"
#import "CHAnimation.h"

#define CHPpopUpMenuItemSize 60

@interface CHPopUpMenu () {
    BOOL _isMenuPresented;
    CGFloat _direction;
    NSMutableArray *_iconViews;
    UIImageView* _imageView;
}
@property (nonatomic, strong) NSArray *icons;

@end

@implementation CHPopUpMenu

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame direction:0 iconArray:nil];
}

- (id) initWithFrame:(CGRect)frame direction:(CGFloat)directionInRadians iconArray:(NSArray *)icons{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isMenuPresented = NO;
        _direction = directionInRadians;
        self.icons = [[NSArray alloc]initWithArray:icons];
        
        
        [self addSubview:({
            _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plus.png"]];
            _imageView.frame = self.bounds;
            _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            _imageView;
        })];
        
        [self addTarget:self action:@selector(controlPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void) controlPressed {
    if (_isMenuPresented) {
        [self dismissSubMenu];
    }
    else {
        [self presentSubMenu];
    }
}




- (void) presentSubMenu {
    _isMenuPresented = YES;

    
    if (!_iconViews) {
        _iconViews = [[NSMutableArray alloc]init];
        for (UIImage *iconImage in self.icons) {
            [self addSubview:({
                UIImageView *iconView = [[UIImageView alloc]initWithImage:iconImage];
                iconView.frame = CGRectMake(self.bounds.size.width/2 - CHPpopUpMenuItemSize/2, self.bounds.size.height/2 - CHPpopUpMenuItemSize/2, CHPpopUpMenuItemSize, CHPpopUpMenuItemSize);
                iconView.alpha = 0.0;
                [_iconViews addObject:iconView];
                iconView;
            })];
        }

    }
    

    int nIcons = [self.icons count];
    int iconNumber = 0;
    
    CHAnimation *degree = [CHAnimation new];
    degree.fromValue = @0;
    degree.toValue = @M_PI;
    degree.duration = 0.6;
    degree.writeBlock = ^(id obj, id value) {
        _imageView.layer.transform = CATransform3DMakeRotation([value floatValue], 0, 0, 1);
    };
    [_imageView.layer ch_addAnimation:degree forKey:@"degree1"];
    
    
    
    for (UIImageView *icon in _iconViews) {
        CHAnimation *alpha = [CHAnimation new];
        alpha.fromValue = @0.0;
        alpha.toValue = @1.0;
        alpha.duration = 0.3;
        alpha.writeBlock = ^(id obj, id value) {
            icon.alpha = [value floatValue];
        };
        alpha.beginTime = CACurrentMediaTime() + iconNumber*0.1;
        [icon ch_addAnimation:alpha forKey:@"alpha1"];
        
        
        CHAnimation *push = [CHAnimation new];
        CGFloat angle = [self angleForIcon:iconNumber numberOfIcons:nIcons];
        CGFloat radius = 90;
        push.beginTime = CACurrentMediaTime() + iconNumber*0.1;
        push.duration = 0.3;
        push.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
        push.toValue = [NSValue valueWithCGPoint:CGPointMake(radius * cosf(angle) + self.bounds.size.width/2, radius * sinf(angle) + self.bounds.size.height/2)];
        push.writeBlock = ^(id obj, id value) {
            icon.center = [value CGPointValue];
        };
        [icon ch_addAnimation:push forKey:@"push1"];
        
        iconNumber += 1;
    }
}


- (void)dismissSubMenu {
    _isMenuPresented = NO;
    int iconNumber = 0;
    int nIcons = [self.icons count];

    CHAnimation *degree = [CHAnimation new];
    degree.fromValue = @M_PI;
    degree.toValue = @0;
    degree.duration = 0.6;
    degree.writeBlock = ^(id obj, id value) {
        _imageView.layer.transform = CATransform3DMakeRotation([value floatValue], 0, 0, 1);
    };
    [_imageView.layer ch_addAnimation:degree forKey:@"degree1"];
    
    
    for (UIImageView *icon in _iconViews) {
        CHAnimation *alpha = [CHAnimation new];
        alpha.toValue = @0.0;
        alpha.fromValue = @1.0;
        alpha.duration = 0.3;
        alpha.writeBlock = ^(id obj, id value) {
            icon.alpha = [value floatValue];
        };
        alpha.beginTime = CACurrentMediaTime() + iconNumber*0.1;
        [icon ch_addAnimation:alpha forKey:@"alpha2"];
        
        CHAnimation *push = [CHAnimation new];
        CGFloat angle = [self angleForIcon:iconNumber numberOfIcons:nIcons];
        CGFloat radius = 90;
        push.beginTime = CACurrentMediaTime() + iconNumber*0.1;
        push.duration = 0.3;
        
        push.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
        push.fromValue = [NSValue valueWithCGPoint:CGPointMake(radius * cosf(angle) + self.bounds.size.width/2, radius * sinf(angle) + self.bounds.size.height/2)];
        push.writeBlock = ^(id obj, id value) {
            icon.center = [value CGPointValue];
        };
        [icon ch_addAnimation:push forKey:@"push2"];
        
        iconNumber += 1;
    }
    
    
    
}

- (CGFloat) angleForIcon:(int)iconNumber numberOfIcons:(int)nIcons {
    CGFloat interSpace = M_PI_4;
    CGFloat totalAngle = (nIcons -1) * interSpace;
    CGFloat startAngle = _direction - totalAngle/2;
    
    return startAngle + iconNumber*interSpace;
}

@end
