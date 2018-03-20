//
//  NSMutableAttributedString+XZExtension.m
//  CourierApp
//
//  Created by admin on 2018/3/13.
//  Copyright © 2018年 XZ. All rights reserved.
//

#import "NSMutableAttributedString+XZExtension.h"

#define XZColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kXZMainBgColor XZColor(241,93,93)

@implementation NSMutableAttributedString (XZExtension)

/**
 让textView的输入文字变色
 
 @param attributeText 需要变色的文本
 @param color         颜色
 */
+ (void)xz_makeWordsAnotherColor:(NSString *)attributeText color:(UIColor *)color view:(UITextView *)textView {
    // 获取当前 textView 属性文本 => 可变的
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString: attributeText];
    
    // 设置颜色属性
    NSInteger length = [attributeText length];
    if ([attributeText containsString:@"["]) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:kXZMainBgColor range:NSMakeRange(0, length)];
    }else { // 黑色
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, length)];
    }

    // 设置字体属性
    UIFont *font = textView.font;
    [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, length)];
    // 记录光标位置
    NSRange range = textView.selectedRange;
    // 将属性文本插入到当前的光标位置
    [attrStrM replaceCharactersInRange:range withAttributedString:attrStr];
    // 设置文本
    textView.attributedText = attrStrM;
    // 恢复光标位置
    NSRange rangeNow = NSMakeRange(range.location + 1, 0);
    
    textView.selectedRange = rangeNow;
}

/**
 让部分文字变大/变色
 */
+ (NSMutableAttributedString *)xz_makeWordsStrong:(CGFloat)fontSize allText:(NSString *)allText attributeText:(NSString *)attributeText defalutFont:(CGFloat)defalutFont color:(UIColor *)color defaultColor:(UIColor *)defaultColor {
    // 所有文字
    NSMutableAttributedString *attrTotal = [[NSMutableAttributedString alloc] initWithString:allText];
    NSInteger lengthFore = [allText length];
    [attrTotal addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:defalutFont] range:NSMakeRange(0, lengthFore)];
    [attrTotal addAttribute:NSForegroundColorAttributeName value:defaultColor range:NSMakeRange(0, lengthFore)];
    
    // 变大/变色的字
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString: attributeText];
    NSInteger length = [attributeText length];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:fontSize] range:NSMakeRange(0, length)];
    NSRange range = [allText rangeOfString:attributeText];
    
    [attrTotal replaceCharactersInRange:range withAttributedString:attrStr];
    
    return  attrTotal;
}

/**
 让部分文字变色
 */
+ (NSMutableAttributedString *)xz_makeWordsAnotherColor:(UIColor *)color allText:(NSString *)allText attributeText:(NSString *)attributeText defalutColor:(UIColor *)defalutColor {
    // 所有文字
    NSMutableAttributedString *attrTotal = [[NSMutableAttributedString alloc] initWithString:allText];
    NSInteger lengthFore = [allText length];
    [attrTotal addAttribute:NSForegroundColorAttributeName value:defalutColor range:NSMakeRange(0, lengthFore)];
    // 变色的字
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString: attributeText];
    NSInteger length = [attributeText length];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, length)];
    
    NSRange range = [allText rangeOfString:attributeText];
    
    [attrTotal replaceCharactersInRange:range withAttributedString:attrStr];
    
    return  attrTotal;
}

/**
 * 设置label的行间距
 
 @param     text label.text
 @return    设置好行间距的
 */
+ (NSMutableAttributedString *)setUpLabelLineSpaceWithText:(NSString *)text fontSize:(CGFloat)fontSize {
    // 创建NSMutableAttributedString实例，并将text传入
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    [style setAlignment: NSTextAlignmentCenter];
    
    //设置行距
    [style setLineSpacing: 8.0f];
    
    // 根据给定长度与style设置attStr式样
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [text length])];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize: fontSize] range:NSMakeRange(0, text.length)];
    
    return attStr;
}

@end

