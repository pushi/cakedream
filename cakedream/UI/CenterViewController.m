//
//  CenterViewController.m
//  cakedream
//
//  Created by cui yansong on 14-5-23.
//  Copyright (c) 2014年 pushi. All rights reserved.
//

#import "CenterViewController.h"
#import "MLNavigationController.h"

@interface CenterViewController ()<UIScrollViewDelegate>
{
    UILabel*backLabel;
    UIScrollView*scrollview;

}

@end

@implementation CenterViewController

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
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    ((MLNavigationController*)self.navigationController).titleLabel.text=@"个人中心";
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame =  CGRectMake(0, 0, 65, 44);
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:(MLNavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backBarButton;
    }
    
    {
        UIImageView*bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableviewbgxuhua.jpg"]];
        bg.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
        [self.view addSubview:bg];
    }
    {
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    scrollview.contentSize=CGSizeMake(320, 500);
    [self.view addSubview:scrollview];
    }
    {
    UIImageView*touming=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"透明背景"]];
    touming.frame=CGRectMake(10,20, 300, 200);
//    touming.alpha=1;
    [scrollview addSubview:touming];
    }
    {
        UIImageView*touming=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"透明背景"]];
        touming.frame=CGRectMake(10,250, 300, 200);
        //    touming.alpha=1;
        [scrollview addSubview:touming];
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    backLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 0, 50, 44)];
    backLabel.text=@"主菜单";
    backLabel.textAlignment=UITextAlignmentCenter;
    backLabel.backgroundColor=[UIColor clearColor];
    backLabel.textColor=[UIColor whiteColor];
    backLabel.font=[UIFont boldSystemFontOfSize:14.0f];
    [self.navigationController.navigationBar addSubview:backLabel];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [backLabel removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
