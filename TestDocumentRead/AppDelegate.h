//
//  AppDelegate.h
//  TestDocumentRead
//
//  Created by gdlab on 12/7/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ViewController2.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) ViewController2 *viewController2;

@property (strong, nonatomic) UINavigationController *navController;


@end
