//
//  DetailHistoryViewController.h
//  PupilsDistance
//
//  Created by Trinh Van Duong on 2/28/15.
//  Copyright (c) 2015 Trinh Van Duong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface DetailHistoryViewController : UIViewController<MFMailComposeViewControllerDelegate>{
    NSString *_imageName;
    float _pupilsDistance;
}
- (IBAction)emailImage:(id)sender;
- (IBAction)saveImageToLibrary:(id)sender;
- (IBAction)helpSelected:(id)sender;
- (IBAction)backSelected:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewController;
@property (weak, nonatomic) IBOutlet UIView *viewNavBar;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewHelp;
@property (weak, nonatomic) IBOutlet UIImageView *imageHelp;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnHelp;
- (id)initWithFileName:(NSString*)imageName;

@end
