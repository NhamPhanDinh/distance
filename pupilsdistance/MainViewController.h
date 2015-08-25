//
//  MainViewController.h
//  PupilsDistance
//
//  Created by Trinh Van Duong on 2/12/15.
//  Copyright (c) 2015 Trinh Van Duong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewRectCard.h"

#define WIDTH_CARD  85.60f

@interface MainViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
}

@property (strong, nonatomic) ViewRectCard *rectCard;
@property (weak, nonatomic) IBOutlet UIView *recLeft;
@property (weak, nonatomic) IBOutlet UIView *recRight;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)panLeftRect:(id)sender;
- (IBAction)panRighRect:(id)sender;

@end
