//
//  WPViewController.m
//  WPDelegates
//
//  Created by wupeng03 on 01/22/2022.
//  Copyright (c) 2022 wupeng03. All rights reserved.
//

#import "WPViewController.h"
#import <WPDelegates/WPDelegates.h>
#import "WPSubBizModule.h"
#import "WPModel3.h"
#import "WPModelX.h"
#import "WPModelY.h"
#import "WPModelS.h"

@interface WPViewController ()

@property (nonatomic, strong) WPDelegates<WPSubBizModule> *delegates;

@property (nonatomic, strong) WPModel3 *model3;
@property (nonatomic, strong) WPModelX *modelX;
@property (nonatomic, strong) WPModelY *modelY;
@property (nonatomic, strong) WPModelS *modelS;

@end

@implementation WPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.model3 = [[WPModel3 alloc] init];
    self.modelX = [[WPModelX alloc] init];
    self.modelY = [[WPModelY alloc] init];
    self.modelS = [[WPModelS alloc] init];
    self.delegates = [[WPDelegates<WPSubBizModule> alloc] init];
    
    [self.delegates addDelegate:self.model3];
    [self.delegates addDelegate:self.modelX];
    [self.delegates addDelegate:self.modelY];
    [self.delegates addDelegate:self.modelS];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.delegates startCharging];
}

@end
