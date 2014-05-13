//
//  SectionHeaderView.m
//  kaoyanbao
//
//  Created by 袁 章敬 on 13-11-8.
//  Copyright (c) 2013年 袁 章敬. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView
@synthesize titleLabel;
@synthesize arrow;
@synthesize delegate;
@synthesize section;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:CGRectMake(0, 0, 320, 40)];
        UILabel* line=[[UILabel alloc] initWithFrame:CGRectMake(0, 39, 320, 1.0)];
        line.backgroundColor=[UIColor colorWithWhite:0.9f alpha:1.0f];
        [self addSubview:line];
        self.open=NO;
        self.backgroundColor=[UIColor colorWithWhite:0.8f alpha:1.0f];
        self.arrow=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 24, 30)];
        [self.arrow setImage:[UIImage imageNamed:@"arrow"]];
        [self addSubview:self.arrow];
        
        self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 0, 320, 40)];
        self.titleLabel.backgroundColor=[UIColor clearColor];
        self.titleLabel.textColor=[UIColor blackColor];
        [self addSubview:titleLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];

    }
    return self;
}

-(void)toggleOpen:(id)sender {
    [self toggleOpenWithUserAction:YES];
}

-(void)toggleOpenWithUserAction:(BOOL)userAction{
    // Toggle the disclosure button state.
    self.open = !self.open;
    [UIView beginAnimations:@"rotate" context:Nil];
    [UIView setAnimationDuration:0.25f];
    self.arrow.transform=CGAffineTransformMakeRotation(self.open?M_PI/2:0);
    [UIView commitAnimations];
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (self.open) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}
@end
