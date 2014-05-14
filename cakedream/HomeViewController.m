//
//  HomeViewController.m
//  cakedream
//
//  Created by cui yansong on 14-5-13.
//  Copyright (c) 2014年 pushi. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "TestViewController.h"
#define Tag_LaunchView 1000

@interface HomeViewController ()


@end

@implementation HomeViewController
@synthesize subtableview;
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
    [self LoadLauchView];
}
-(void)LoadLauchView
{
    UIImageView* launchView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"启动界面底图"]];
//    if (IOS7) {
//        CGRect f=self.view.frame;
//        f.origin.y+=20;
//        f.size.height-=20;
//        launchView.frame=f;
//    }else{
//        CGSize s=self.view.frame.size;
//        launchView.frame=CGRectMake(0, 0, s.width, s.height);
//    }
    launchView.tag=Tag_LaunchView;
    [self.view addSubview:launchView];
    
//    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    btn.backgroundColor=[UIColor redColor];
//    [btn addTarget:self action:@selector(theNext) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview: btn];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
//-(void)theNext
//{
////    AppDelegate*delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    TestViewController*test=[[TestViewController alloc]init];
//    [self.navigationController pushViewController:test animated:YES];
//    
//}
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
