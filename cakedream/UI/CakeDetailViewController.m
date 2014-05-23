//
//  CakeDetailViewController.m
//  cakedream
//
//  Created by cui yansong on 14-5-14.
//  Copyright (c) 2014年 pushi. All rights reserved.
//

#import "CakeDetailViewController.h"

@interface CakeDetailViewController ()<UIScrollViewDelegate>
{
    UIScrollView*scrolltableview;
}

@end

@implementation CakeDetailViewController
@synthesize cakeimg;
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
    scrolltableview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    scrolltableview.contentSize=CGSizeMake(self.view.frame.size.width, 320*2+200);
    scrolltableview.scrollEnabled=YES;
    scrolltableview.delegate=self;
    [self.view addSubview:scrolltableview];
    
    UIImageView*bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320 , 320)];
    [bg setImage:[UIImage imageNamed:@"cakedetailbg"]];
    [scrolltableview addSubview:bg];
    
    cakeimg.frame=CGRectMake(65, 60, 190, 190);
    cakeimg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    cakeimg.layer.masksToBounds = YES;
    cakeimg.layer.cornerRadius = 100.0;
    cakeimg.layer.borderColor = [UIColor whiteColor].CGColor;
    cakeimg.layer.borderWidth = 3.0f;
    cakeimg.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cakeimg.layer.shouldRasterize = YES;
    cakeimg.clipsToBounds = YES;

    [bg addSubview:cakeimg];
    
    UIImageView*flowerbg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 320, 320 , 320)];
    [flowerbg setImage:[UIImage imageNamed:@"flowerbg.jpg"]];
    [scrolltableview addSubview:flowerbg];
    UIImageView*flowerbg1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 640, 320 , 320)];
    [flowerbg1 setImage:[UIImage imageNamed:@"flowerbg.jpg"]];
    [scrolltableview addSubview:flowerbg1];
    
    UIImageView*touming=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"透明背景"]];
    touming.frame=CGRectMake(0,320, 320, 640);
    touming.alpha=1;
    [scrolltableview addSubview:touming];
    
    UILabel*cakebook=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 200, 60)];
    cakebook.backgroundColor=[UIColor clearColor];
    cakebook.textColor=[UIColor whiteColor];
    cakebook.font=[UIFont fontWithName:@"RTWS DingDing Demo"  size:35];
    [cakebook setText:@"订购信息："];
    [touming addSubview:cakebook];
    
    UILabel*cakeprice=[[UILabel alloc]initWithFrame:CGRectMake(10, 130, 200, 60)];
    cakeprice.backgroundColor=[UIColor clearColor];
    cakeprice.textColor=[UIColor whiteColor];
    cakeprice.font=[UIFont fontWithName:@"RTWS DingDing Demo"  size:35];
    [cakeprice setText:@"蛋糕简介："];
    [touming addSubview:cakeprice];
    
    UILabel*cakepeisong=[[UILabel alloc]initWithFrame:CGRectMake(10, 200, 250, 60)];
    cakepeisong.backgroundColor=[UIColor clearColor];
    cakepeisong.textColor=[UIColor whiteColor];
    cakepeisong.font=[UIFont fontWithName:@"RTWS DingDing Demo"  size:35];
    [cakepeisong setText:@"配送范围及收费标准："];
    [touming addSubview:cakepeisong];



    
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
