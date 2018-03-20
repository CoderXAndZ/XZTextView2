//
//  NSMutableAttributedString+XZExtension.h
//  CourierApp
//
//  Created by admin on 2018/3/13.
//  Copyright © 2018年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (XZExtension)
/**
 让textView的输入文字变色
 
 @param attributeText 需要变色的文本
 @param color         颜色
 */
+ (void)xz_makeWordsAnotherColor:(NSString *)attributeText color:(UIColor *)color view:(UITextView *)textView;
/**
 让部分文字变大/变色
 */
+ (NSMutableAttributedString *)xz_makeWordsStrong:(CGFloat)fontSize allText:(NSString *)allText attributeText:(NSString *)attributeText defalutFont:(CGFloat)defalutFont color:(UIColor *)color defaultColor:(UIColor *)defaultColor;

/**
 让部分文字变色
 */
+ (NSMutableAttributedString *)xz_makeWordsAnotherColor:(UIColor *)color allText:(NSString *)allText attributeText:(NSString *)attributeText defalutColor:(UIColor *)defalutColor;
/**
 * 设置label的行间距
 
 @param     text label.text
 @return    设置好行间距的
 */
+ (NSMutableAttributedString *)setUpLabelLineSpaceWithText:(NSString *)text fontSize:(CGFloat)fontSize;

@end

