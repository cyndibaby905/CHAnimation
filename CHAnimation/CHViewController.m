//
//  CHViewController.m
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

#import "CHViewController.h"
#import "CHPopUpMenu.h"

@interface CHViewController ()

@end

@implementation CHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:({
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
        imageView.frame = self.view.bounds;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView;
    })];
    
    [self.view addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 200)];
        NSString *text = @"CHAnimation is a project used to demonstrate how to write your own animation engine, inspired by Facebook Pop, with only 600 lines of Objective-C you can understand.\n\nYou can also use this project to help learning Facebook Pop.";
        label.text = text;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = [UIColor colorWithRed:94/255.0f green:38/255.0f blue:5/255.0f alpha:1.0];
        label.backgroundColor = [UIColor clearColor];

        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
        
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:28/255.0f green:160/255.0f blue:170/255.0f alpha:1.0]} range:[text rangeOfString:@"CHAnimation"]];
        
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:28/255.0f green:160/255.0f blue:170/255.0f alpha:1.0]} range:[text rangeOfString:@"Facebook Pop"]];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:28/255.0f green:160/255.0f blue:170/255.0f alpha:1.0]} range:[text rangeOfString:@"Facebook Pop" options:NSBackwardsSearch]];
        
        
        label.attributedText = attributedText;
        
        label;
    })];
    
    
    
    
    
    [self.view addSubview:({
        NSArray *icons = @[[UIImage imageNamed:@"facebook.png"],[UIImage imageNamed:@"twitter.png"],[UIImage imageNamed:@"googleplus.png"],[UIImage imageNamed:@"pinterest.png"],[UIImage imageNamed:@"linkedin.png"],[UIImage imageNamed:@"youtube.png"],[UIImage imageNamed:@"tumblr.png"],[UIImage imageNamed:@"skype.png"]];
        
        CHPopUpMenu *popUp = [[CHPopUpMenu alloc]initWithFrame:CGRectMake(145, 420, 30, 30)
                                                     direction:-M_PI/2
                                                     iconArray:icons];
        popUp;
    })];
    
    
   
    

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
