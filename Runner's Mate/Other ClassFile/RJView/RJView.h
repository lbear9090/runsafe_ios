//  Created by JigneshRadadiya on 28/11/15.
//  Copyright © 2016 Pvb. All rights reserved.

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RJView : UIView

@property (nonatomic) IBInspectable UIColor *startColor;
@property (nonatomic) IBInspectable UIColor *midColor;
@property (nonatomic) IBInspectable UIColor *endColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable BOOL isHorizontal;

@end
