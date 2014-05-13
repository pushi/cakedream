//
//  SectionHeaderView.h
//  kaoyanbao
//
//  Created by 袁 章敬 on 13-11-8.
//  Copyright (c) 2013年 袁 章敬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SectionHeaderViewDelegate;

@interface SectionHeaderView : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *arrow;
@property (nonatomic) id <SectionHeaderViewDelegate> delegate;
@property (nonatomic) BOOL open;
@property (nonatomic) NSInteger section;

-(void)toggleOpenWithUserAction:(BOOL)userAction;
@end

@protocol SectionHeaderViewDelegate<NSObject>

@optional
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;

@end