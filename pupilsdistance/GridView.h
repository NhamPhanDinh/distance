//
//  GridView.h
//  PupilsDistance
//
//  Created by duongtv on 3/25/15.
//  Copyright (c) 2015 Trinh Van Duong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridView : UIView{
    
}

@property (nonatomic, assign) int numberOfColumns;
@property (nonatomic, assign) int numberOfRows;
@property (nonatomic) BOOL blackBorder;


-(id) initWithBlackBorder:(BOOL) b;
@end
