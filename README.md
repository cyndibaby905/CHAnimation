## CHAnimation ##

`CHAnimation` is a project used to demonstrate how to write your own animation engine, inspired by [Facebook Pop](https://github.com/facebook/pop), with only 600 lines of Objective-C you can understand.

You can also use this project to help learning [Facebook Pop](https://github.com/facebook/pop). 



## Requirements ##

`CHAnimation` requires Xcode 5, targeting either iOS 5.0 and above, ARC-enabled.



## Types ##

Unlike [Facebook Pop](https://github.com/facebook/pop),  `CHAnimation` supports only one animation type, that is linear animation. The main purpose of this project is to help developer understand how an animation engine works, so I tried my best to keep the code small and clean. I think if you finished reading the code of `CHAnimation`, you can add more `timingFunction` as you want.

Currently, `CHAnimation` supports `CGSize`, `CGPoint` and `NSNumber` as animated values, you can add more types if you want.



## How to use ##

`CHAnimation` adopts the Core Animation explicit animation programming model, the interfaces are almost the same:


    #import "CHAnimation.h"

    CHAnimation *animation = [CHAnimation new];
    animation.duration = 0.4;
    
    animation.writeBlock = ^(id obj, id value) {
        button.center = [value CGPointValue];
    };

    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(70, 70)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(170, 170)];
    
    [button ch_addAnimation:animation forKey:@"animation"]; 


    

## Resources ##

A collection of links to external resources may help you to understand the code:

* [Apple – Core Animation Programming Guide](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html)
* [AGGeometryKit+POP - Animating Quadrilaterals with Pop](https://github.com/hfossli/aggeometrykit-pop)
* [Facebook Pop – Extensible iOS and OS X animation library](https://github.com/facebook/pop)
* [Building Paper – Full Length Event](https://www.youtube.com/watch?v=OiY1cheLpmI)




## How it looks ##
![CHAnimation] (https://raw.github.com/cyndibaby905/CHAnimation/master/CHAnimation.gif)


## Lincense ##

`CHAnimation` is available under the MIT license. See the LICENSE file for more info.

