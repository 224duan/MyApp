//
//  DXClickAlertView.m
//  365News
//
//  Created by news365-macpro on 2017/1/19.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import "DXClickAlertView.h"
#import "DXGuideAlertView.h"
#import "DXUtil.h"
#import "UIImage+DXCate.h"

@interface DXClickAlertView()

@property(nonatomic, strong) DXGuideAlertView * alertView;

@end
@implementation DXClickAlertView

-(instancetype)initWithFrame:(CGRect)frame targetPoint:(CGPoint)targetPoint
{
    if (self = [super initWithFrame:frame]) {
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHander:)];
        [self addGestureRecognizer:tap];
        
        
//        CGRect targetViewRect = [targetView convertRect:targetView.bounds toView:self];
        CGPoint targetViewCenter = targetPoint;
        //CGPointMake(CGRectGetMidX(targetViewRect), CGRectGetMidY(targetViewRect));
        
        
        // 手指图片
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.bounds = CGRectMake(0, 0, 40, 74);
        imageView.center = targetViewCenter;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage dx_imageInKit:@"click"];
        
        CGFloat angle =[DXUtil angleBetweenLinesWithLine1Start:CGPointMake(self.center.x, 0) line1End:self.center line2Start:targetViewCenter line2End:self.center];
        if (targetViewCenter.x < self.center.x) {
            angle = 0 - angle;
        }
        [self addSubview:imageView];
        imageView.transform = CGAffineTransformMakeRotation(angle);
        
        
        // 提示内容
        CGFloat edgeFloat = 60; // 两边边界的宽度
        CGFloat margin = 14;
        
        DXGuideAlertView *alertView = [[DXGuideAlertView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//        alertView.message = message;
        [self addSubview:alertView];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            BOOL atCenter = NO;
            if (targetViewCenter.x < edgeFloat) {
                
                make.left.equalTo(imageView.right).offset(margin);
                make.right.equalTo(self.right).offset(-margin);
                alertView.arrowDirection = DXGuideAlertViewArrowDirectionLeft;
                
            }else if (targetViewCenter.x < (self.frame.size.width - edgeFloat)){
                
                atCenter = YES;
                make.left.equalTo(self.left).offset(margin);
                make.right.equalTo(self.right).offset(-margin);
                alertView.arrowPosition = targetViewCenter.x / self.frame.size.width;
                
            }else{
                
                make.left.equalTo(self.left).offset(margin);
                make.right.equalTo(imageView.left).offset(-margin);
                alertView.arrowDirection = DXGuideAlertViewArrowDirectionRight;
            }
            
            
            if (targetViewCenter.y > self.center.y) { // 在下面
                
                if (atCenter) { // 在中间区域
                    make.bottom.equalTo(imageView.top).offset(-margin * 0.5);
                    alertView.arrowDirection = DXGuideAlertViewArrowDirectionDown;
                }else{ // 在两边边界
                    make.bottom.equalTo(imageView.top).offset(imageView.frame.size.height * 0.5);
                    alertView.arrowPosition = 1.0;
                }
                
            }else{ // 在上面
                
                if (atCenter) { // 在中间区域
                    make.top.equalTo(imageView.bottom).offset(margin * 0.5);
                    alertView.arrowDirection = DXGuideAlertViewArrowDirectionUp;
                }else{ // 在两边边界
                    make.top.equalTo(imageView.top).offset(imageView.frame.size.height * 0.5);
                    alertView.arrowPosition = 0.0;
                }
            }
        }];
        self.alertView = alertView;
        
    }
    return self;
}

-(void)setMessage:(NSString *)message
{
    _message = message;
    self.alertView.message = _message;
}


-(void)tapHander:(UITapGestureRecognizer *)sender
{
    if (_tapHander) {
        _tapHander(self);
    }
}

@end
