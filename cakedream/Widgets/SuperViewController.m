//
//  SuperViewController.m
//  kaoyanbao
//
//  Created by 袁 章敬 on 13-11-5.
//  Copyright (c) 2013年 袁 章敬. All rights reserved.
//

#import "SuperViewController.h"
#import "MLNavigationController.h"
#import "HomeViewController.h"
@interface SuperViewController ()<MBProgressHUDDelegate>{
    UIButton* more;
//    UILabel* backLabel;
}

@end

@implementation SuperViewController
@synthesize MBhud;
@synthesize navtitle;
@synthesize type;
@synthesize backLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel* titlelabel=[(MLNavigationController*)self.navigationController backLabel];
    CGRect f = titlelabel.frame;
    f.origin.x=10;
    titlelabel.frame=f;
//    titlelabel.alpha=0;
//    titlelabel.textAlignment=UITextAlignmentLeft;
//    CGRect f = titlelabel.frame;
//    f.origin.x=100;
//    titlelabel.frame=f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:0.5f];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame =  CGRectMake(0, 0, 65, 44);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:(MLNavigationController *)self.navigationController action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
   


//    f.origin.x=0;
//    titlelabel.frame=f;
//    titlelabel.alpha=1.0f;
//    [UIView commitAnimations];
}
-(void)showMoreButton{
    more=[[UIButton alloc] initWithFrame:CGRectMake(320-65, 0, 65, 44)];
    [more setBackgroundImage:[UIImage imageNamed:@"tripledot"] forState:UIControlStateNormal];
    [more setBackgroundImage:[UIImage imageNamed:@"tripledotChosen"] forState:UIControlStateHighlighted];
    [more addTarget:self action:@selector(showMoreView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:more];
}
-(void)showMoreView{
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UILabel* titlelabel=[(MLNavigationController*)self.navigationController backLabel];
    if (self.navigationController.viewControllers.count==2) {
        titlelabel.text=@"主页";
    }else{
        titlelabel.text=@"返回";
    }
    ((MLNavigationController*)self.navigationController).titleLabel.text=self.navtitle;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    backLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 0, 50, 44)];
    backLabel.text=@"返回";
    backLabel.textAlignment=UITextAlignmentCenter;
    backLabel.backgroundColor=[UIColor clearColor];
    backLabel.textColor=[UIColor whiteColor];
    backLabel.font=[UIFont boldSystemFontOfSize:14.0f];
    [self.navigationController.navigationBar addSubview:backLabel];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [backLabel removeFromSuperview];
    [more removeFromSuperview];
    more=Nil;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.MBhud hide:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 异步加载
/**
 开始加载数据，并显示加载进度条
 **/
-(void)startLoad:(NSString*)hudTitle
{
    MBhud=[[MBProgressHUD alloc]initWithView:self.view];
    MBhud.dimBackground = NO;
    MBhud.delegate=self;
    [self.view addSubview:MBhud];
    if (hudTitle) {
        MBhud.labelText=hudTitle;
    }else{
    MBhud.labelText=@"加载中";
    }
    MBhud.mode=MBProgressHUDModeIndeterminate;
    MBhud.square=NO;
    MBhud.labelFont=[UIFont systemFontOfSize:14];
    MBhud.minSize=CGSizeMake(150, 70);
    MBhud.animationType=MBProgressHUDAnimationFade;
    [MBhud showWhileExecuting:@selector(loadDataFromServer) onTarget:self withObject:nil animated:YES];
}
-(void)loadDataFromServer{
    //重写专用
}
-(void)hudWasHidden:(MBProgressHUD *)hud{
    //重写专用
}
@end
