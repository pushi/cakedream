//
//  SuperViewController.h
//  kaoyanbao
//
//  Created by 袁 章敬 on 13-11-5.
//  Copyright (c) 2013年 袁 章敬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface SuperViewController : UIViewController

@property (strong,nonatomic) MBProgressHUD* MBhud;
@property (strong,nonatomic) NSString* navtitle;
@property (nonatomic) int type;

-(void)startLoad:(NSString*)hudTitle;

-(void)loadDataFromServer;

-(void)hudWasHidden:(MBProgressHUD *)hud;

-(void)showMoreButton;
-(void)showMoreView;
@end
