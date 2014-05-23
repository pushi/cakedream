//
//  LaughViewController.m
//  cakedream
//
//  Created by cui yansong on 14-5-22.
//  Copyright (c) 2014年 pushi. All rights reserved.
//

#import "LaughViewController.h"
#import "MLNavigationController.h"
@interface LaughViewController ()<UIWebViewDelegate>
{
    UILabel*backLabel;
    UILabel*waitlable;
}

@end

@implementation LaughViewController

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
    ((MLNavigationController*)self.navigationController).titleLabel.text=@"笑一笑";
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame =  CGRectMake(0, 0, 65, 44);
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:(MLNavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backBarButton;
    }

    
    self.view.backgroundColor=[UIColor whiteColor];
    waitlable=[[UILabel alloc]initWithFrame:CGRectMake(50, 100, 200, 60)];
    waitlable.backgroundColor=[UIColor clearColor];
    waitlable.textColor=[UIColor colorWithRed:0 green:182.0f/255.0f blue:193.0f/255.0f alpha:1];
    waitlable.font=[UIFont fontWithName:@"RTWS DingDing Demo"  size:50];
    [waitlable setText:@"玩儿命加载中。。。"];

  UIWebView*webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    webview.delegate=self;
    webview.userInteractionEnabled=YES;
    webview.opaque=YES;
    [webview addSubview:waitlable];
    NSURL *url = [NSURL URLWithString:@"http://www.qiushibaike.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:300];
    [webview loadRequest:request];
    NSLog(@"广告 ismain:%@",[[NSThread currentThread] isMainThread]?@"YES":@"NO");
    [self.view addSubview:webview];


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

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [waitlable removeFromSuperview];
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
