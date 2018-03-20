//
//  ViewController.m
//  XZTextView
//
//  Created by admin on 2018/3/20.
//  Copyright © 2018年 XZ. All rights reserved.
//

#import "ViewController.h"
#import "XZEditTemplateItem.h"
#import "XZEditTemplateModel.h"
#import "NSMutableAttributedString+XZExtension.h"
#import "Masonry.h"
#import "XZTextAttachment.h"

#define XZColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kXZMainBgColor XZColor(241,93,93)

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *arrEditModel;
@property (nonatomic, strong) UITextView *textEdit;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEditTemplateView];
    // 假数据
    [self getEditDataFromNetWork];
}

#pragma mark --- 获取数据，注意修改
- (void)getEditDataFromNetWork {
    // 假数据
    NSArray *arr = @[
                     @{@"title":@"+地址",@"content":@"北京故宫太和殿",@"chs":@"[地址]"},
                     @{@"title":@"+姓名",@"content":@"A66888",@"chs":@"[小李子]"},
                     @{@"title":@"+联系电话",@"content":@"18566668888",@"chs":@"[联系电话]"},
                     @{@"title":@"+送餐公司",@"content":@"达达配送",@"chs":@"[送餐公司]"},
                     @{@"title":@"+订单号",@"content":@"123456654321",@"chs":@"[订单号]"},
                     @{@"title":@"+送餐时间",@"content":@"早8点至晚8点",@"chs":@"[送餐时间]"}];
    for (NSDictionary *dict in arr) {
        XZEditTemplateModel *modelEdit = [[XZEditTemplateModel alloc] init];
        [modelEdit setValuesForKeysWithDictionary:dict];
        [self.arrEditModel addObject:modelEdit];
    }
    [self.collectionView reloadData];
}

#pragma mark ----- UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrEditModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XZEditTemplateItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XZEditTemplateItem" forIndexPath:indexPath];
    cell.modelEdit = self.arrEditModel[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XZEditTemplateModel *modelEdit = self.arrEditModel[indexPath.item];
    
    [NSMutableAttributedString xz_makeWordsAnotherColor:modelEdit.chs color:kXZMainBgColor view:self.textEdit];
    
    [self textViewDidChange:self.textEdit];
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];

    // 获取高亮字符的位置
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];

    NSLog(@"markedTextStyle===%@",textView.markedTextStyle);

    // 如果没有高亮字符,才计算富文本,否则相当于没有输入
    if (!position) {
//        // 实时修改文字颜色
//        [self findAllKeywordsChangeColor:textView];
        // 将文字转换成图片
        [self makeTextToImage: textView];
    }
}

// 将文字转换成图片
- (void)makeTextToImage:(UITextView *)textView {
    NSString *string = textView.text;
    
    // 记录光标位置
    NSRange rangeDefault = textView.selectedRange;
    
    // 获取当前 textView 属性文本 => 可变的
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    
    [attrStrM addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range: NSMakeRange(0, string.length)];
    [attrStrM addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, string.length)];
    
    NSString *pattern = @"\\[(.*?)\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options: NSRegularExpressionCaseInsensitive error:nil];
    
    // 匹配所有项
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    NSLog(@"matches ==== %@",matches);
    
    //
    for (int i = 0; i < matches.count; i++) {
        NSTextCheckingResult *result = matches[i];
        NSRange range = [result rangeAtIndex:0];
        NSLog(@"查找合适的位置location：%lu-----%lu",range.location,range.length);
        NSString *subStr = [attrStrM.string substringWithRange:range];
        
        // 创建属性文本
        XZTextAttachment *attachment = [[XZTextAttachment alloc] init];
        attachment.image = [self makeTextToImage:subStr font: 15.0 color:kXZMainBgColor bgColor:[UIColor greenColor]];
        attachment.chs = subStr;
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString: [NSAttributedString attributedStringWithAttachment:attachment]];
        
        // 将属性文本插入到当前的光标位置
        [attrStrM replaceCharactersInRange:range withAttributedString:attrStr];
    }
    textView.attributedText = attrStrM;
    // 恢复光标位置
    NSRange rangeNow = NSMakeRange(rangeDefault.location, 0);
    textView.selectedRange = rangeNow;
}

// 找到所有的关键词，并修改颜色
- (void)findAllKeywordsChangeColor:(UITextView *)textView {
    
    NSString *string = textView.text;
    
    // 记录光标位置
    NSRange rangeDefault = textView.selectedRange;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString: string];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range: NSMakeRange(0, string.length)];
    
    NSString *pattern = @"\\[(.*?)\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options: NSRegularExpressionCaseInsensitive error:nil];
    
    // 匹配所有项
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    NSLog(@"matches ==== %@",matches);
    
    // NSTextCheckingResult *result in matches
    for (int i = 0; i < matches.count; i++) {
        NSTextCheckingResult *result = matches[i];
        NSRange range = [result rangeAtIndex:0];
        NSLog(@"查找合适的位置location：%lu-----%lu",range.location,range.length);
        NSString *subStr = [attrStr.string substringWithRange:range];
        NSUInteger length = subStr.length;
        [attrStr addAttribute:NSForegroundColorAttributeName value:kXZMainBgColor range:NSMakeRange(range.location, length)];
        
    }
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, string.length)];
    textView.attributedText = attrStr;
    // 恢复光标位置
    NSRange rangeNow = NSMakeRange(rangeDefault.location, 0);
    textView.selectedRange = rangeNow;
}

- (UIImage *)makeTextToImage:(NSString *)text font:(CGFloat)fontSize color:(UIColor *)color bgColor:(UIColor *)bgColor {
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    CGFloat height = font.lineHeight;
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName:font,
                               NSForegroundColorAttributeName:color,
                               NSBackgroundColorAttributeName:bgColor
                               };
    CGSize stringSize = [text sizeWithAttributes:attrDict];
    
    UIGraphicsBeginImageContextWithOptions(stringSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetCharacterSpacing(ctx, 10);
    CGContextSetTextDrawingMode (ctx, kCGTextFillStroke);
    CGContextSetRGBFillColor (ctx, 0.1, 0.2, 0.3, 1); // 6
    CGContextSetRGBStrokeColor (ctx, 0, 0, 0, 1);
    
    CGRect rect = CGRectMake(0, 2, stringSize.width , height);
    
    [text drawInRect:rect withAttributes:attrDict];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark --- 页面搭建
- (void)setupEditTemplateView {
    self.view.backgroundColor = XZColor(245,245,245);
    
    UIView *bgView = [[UIView alloc] init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset((88 + 10));
        make.height.equalTo(@320);
    }];
    bgView.layer.cornerRadius = 5.0f;
    bgView.layer.masksToBounds = YES;
    bgView.layer.borderColor = [XZColor(229,229,229) CGColor];
    bgView.layer.borderWidth = 1.0f;
    bgView.backgroundColor = [UIColor whiteColor];
    self.bgView = bgView;
    
    UITextView *textEdit = [[UITextView alloc] init];
    [self.view addSubview:textEdit];
    [textEdit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.right.equalTo(bgView).offset(-10);
        make.top.equalTo(bgView).offset(10);
        make.height.equalTo(@200);
    }];
    textEdit.delegate = self;
    textEdit.font = [UIFont systemFontOfSize:15.0];
    self.textEdit = textEdit;
    
    self.collectionView.delegate = self;
    
}

#pragma mark --- 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        CGFloat kXZScreenWidth = [UIScreen mainScreen].bounds.size.width;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (kXZScreenWidth - 40 - kXZScreenWidth * 0.08) / 3.0;
        CGFloat height = 90;
        flowLayout.itemSize = CGSizeMake(width, 40);
        flowLayout.minimumInteritemSpacing = 0.026 * kXZScreenWidth;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(10);
            make.right.equalTo(self.bgView).offset(-10);
            make.bottom.equalTo(self.bgView).offset(-10);
            make.height.equalTo(@(height));
        }];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[XZEditTemplateItem class] forCellWithReuseIdentifier:@"XZEditTemplateItem"];
    }
    
    return _collectionView;
}

- (NSMutableArray *)arrEditModel {
    if (!_arrEditModel) {
        _arrEditModel = [NSMutableArray array];
    }
    
    return _arrEditModel;
}


@end
