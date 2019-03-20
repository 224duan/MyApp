//
//  DXGuideAlertView.m
//  IENews_test
//
//  Created by news365-macpro on 2017/1/16.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//


#import "UIImage+DXCate.h"
#import "DXGuideAlertView.h"

NSInteger const KLabelMargin = 20;

@interface DXGuideAlertView()
@property(nonatomic, strong) UILabel * label;
@property(nonatomic, strong) NSMutableParagraphStyle *paragraphSpacing;
@end
@implementation DXGuideAlertView

-(NSMutableParagraphStyle *)paragraphSpacing
{
    if (_paragraphSpacing == nil) {
        _paragraphSpacing = [[NSMutableParagraphStyle alloc] init];
        _paragraphSpacing.lineSpacing = 4;
        _paragraphSpacing.alignment = NSTextAlignmentCenter;
    }
    return _paragraphSpacing;
}


-(UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        _label.textColor = [UIColor blackColor];
        _label.numberOfLines = 6;
        [self addSubview:_label];
        
        [_label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(KLabelMargin, KLabelMargin, KLabelMargin, KLabelMargin));
        }];
    }
    return _label;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowRadius = 4;
    }
    return self;
}

-(void)setMessage:(NSString *)message
{
    _message = message;
    if (message) {
        [self.label setAttributedText:[[NSAttributedString alloc] initWithString:message attributes:@{NSParagraphStyleAttributeName: self.paragraphSpacing}]];
    }
}


-(void)setArrowDirection:(DXGuideAlertViewArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    
    if (arrowDirection != DXGuideAlertViewArrowDirectionNone) {
        
        UIEdgeInsets edge = UIEdgeInsetsZero;
        
        switch (_arrowDirection) {
            case DXGuideAlertViewArrowDirectionUp:
                edge = UIEdgeInsetsMake(KLabelMargin + 12, KLabelMargin, KLabelMargin, KLabelMargin);
                break;
            
            case DXGuideAlertViewArrowDirectionDown:
                edge = UIEdgeInsetsMake(KLabelMargin, KLabelMargin, KLabelMargin + 12, KLabelMargin);
                break;
                
            case DXGuideAlertViewArrowDirectionLeft:
                edge = UIEdgeInsetsMake(KLabelMargin, KLabelMargin + 12, KLabelMargin, KLabelMargin);
                break;
                
            case DXGuideAlertViewArrowDirectionRight:
                edge = UIEdgeInsetsMake(KLabelMargin, KLabelMargin, KLabelMargin, KLabelMargin + 12);
                break;
                
            default:
                break;
        }
        
        [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(edge);
        }];
    }
}

-(void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat minM = MIN(width, height) / 6.0 - 4;
    
    if (_arrowDirection != DXGuideAlertViewArrowDirectionNone && minM > 0) {
        
        CGFloat margin = minM > 6 ? 6 : minM;
        
        CGFloat arrowSlideH = 4 * margin;
        CGFloat arrowSlideW = 3 * margin;
        CGFloat insetDx = 0.0;
        CGFloat insetDy = 0.0;
        CGFloat offsetDx = 0.0;
        CGFloat offsetDy = 0.0;
        
        CGPoint arrowPointOne = CGPointZero;
        CGPoint arrowPointTwo = CGPointZero;
        CGPoint arrowPointThree = CGPointZero;
        
        switch (_arrowDirection) {
            case DXGuideAlertViewArrowDirectionUp:
            {
                insetDy         = margin;
                offsetDy        = margin;
                arrowPointOne   = CGPointMake(width * _arrowPosition, 0);
                arrowPointTwo   = CGPointMake(arrowPointOne.x - _arrowPosition * arrowSlideW, arrowSlideH);
                arrowPointThree = CGPointMake(arrowPointTwo.x + arrowSlideW, arrowPointTwo.y);
                
            }break;
             
            case DXGuideAlertViewArrowDirectionDown:
            {
                insetDy         = margin;
                offsetDy        = -margin;
                arrowPointOne   = CGPointMake(width * _arrowPosition, height);
                arrowPointTwo   = CGPointMake(arrowPointOne.x - _arrowPosition * arrowSlideW, height - arrowSlideH);
                arrowPointThree = CGPointMake(arrowPointTwo.x + arrowSlideW, arrowPointTwo.y);
                
            }break;
                
            case DXGuideAlertViewArrowDirectionLeft:
            {
                insetDx         = margin;
                offsetDx        = margin;
                arrowPointOne   = CGPointMake(0, height * _arrowPosition);
                arrowPointTwo   = CGPointMake(arrowSlideH, arrowPointOne.y - _arrowPosition * arrowSlideW);
                arrowPointThree = CGPointMake(arrowPointTwo.x, arrowPointTwo.y +  + arrowSlideW);
                
            }break;
                
            case DXGuideAlertViewArrowDirectionRight:
            {
                insetDx         = margin;
                offsetDx        = -margin;
                arrowPointOne   = CGPointMake(width, height * _arrowPosition);
                arrowPointTwo   = CGPointMake(width - arrowSlideH, arrowPointOne.y - _arrowPosition * arrowSlideW);
                arrowPointThree = CGPointMake(arrowPointTwo.x, arrowPointTwo.y +  + arrowSlideW);
                
            }break;
                
            default:
                break;
        }
        
        CGRect drawRect = CGRectOffset(CGRectInset(rect, insetDx ,insetDy), offsetDx, offsetDy);
        
        UIColor *color = [UIColor whiteColor];
        [color set];
        
        // 背景
        UIBezierPath *bezierPathOne = [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:2 * margin];
        [bezierPathOne fill];
        
        // 箭头
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:arrowPointOne];
        [bezierPath addLineToPoint:arrowPointTwo];
        [bezierPath addLineToPoint:arrowPointThree];
        [bezierPath closePath];
        [bezierPath fill];
        
    }
}


@end
