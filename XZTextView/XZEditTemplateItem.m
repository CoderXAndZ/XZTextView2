//
//  XZEditTemplateItem.m
//  CourierApp
//
//  Created by XZ on 2018/3/17.
//  Copyright © 2018年 XZ. All rights reserved.
//  编辑模板cell

#import "XZEditTemplateItem.h"
#import "XZEditTemplateModel.h"
#import "Masonry.h"

#define XZColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kXZBgColor XZColor(82,82,82)

@interface XZEditTemplateItem()

@property (nonatomic, strong) UILabel *labelTitle;

@end

@implementation XZEditTemplateItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupEditTemplateItem];
    }
    
    return self;
}

- (void)setModelEdit:(XZEditTemplateModel *)modelEdit {
    _modelEdit = modelEdit;
    
    self.labelTitle.text = modelEdit.title;
}

- (void)setupEditTemplateItem {
    
    self.contentView.backgroundColor = kXZBgColor;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0f;
    
    UILabel *labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(2);
        make.right.equalTo(self.contentView).offset(-2);
        make.centerY.equalTo(self.contentView);
    }];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont systemFontOfSize:14.0f];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    self.labelTitle = labelTitle;
    
}

@end
