//
//  MeasureViewController.h
//  PupilsDistance
//
//  Created by duongtv on 2/25/15.
//  Copyright (c) 2015 Trinh Van Duong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GridView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface MeasureViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIScrollViewDelegate, UIAlertViewDelegate,MFMailComposeViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>{
    UIImage *_imageCapture;
    UIImage *_imageCapture2;
    UIImagePickerController *imagePicker;
    int state;
    int color;
    int typeSize;
    int _typeFlowView;
    BOOL _isSavePhotoPD5;

    float _saveZoomScale;
    float _originalDistance;
    float _targetSize;
    float _distanceBetweenFaceAndCamera;
//    float valueReferencingDistance;
    NSString *_clinicalWorkDistanceValue;

    BOOL isStartDistance;
    BOOL _isMoveView;
    BOOL _isFlowWithVideo;
    BOOL _isUseWDVideo, _isUseWD, _isUseIPDVideo, _isUseIPD;
    
    NSArray *_listValueWD, *_listValueIPD;
    NSMutableArray *_pickerData;
    NSString *_pickerValue;
    int _pickerTag;
    BOOL _isAddMore;
}

//Picker view
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIButton *btnDone;
@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UILabel *labelClinicalWork;
@property (strong, nonatomic) IBOutlet UIView *viewGuideZoom;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIView *viewArea;
@property (strong, nonatomic) ALAssetsLibrary* library;

//@property (weak, nonatomic) IBOutlet UIView *viewControlImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageSelected;
@property (weak, nonatomic) IBOutlet UIView *navigationToolBar;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnNext2;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *leftSightView;
@property (weak, nonatomic) IBOutlet UIView *rightSightView;
@property (weak, nonatomic) IBOutlet UIView *rightArrowView;

@property (weak, nonatomic) IBOutlet UIView *leftArrowView;
@property (weak, nonatomic) IBOutlet UILabel *labelDistanceValue;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

- (IBAction)saveActionSelected:(id)sender;
- (IBAction)backActionSelected:(id)sender;
- (IBAction)nextSelected:(id)sender;
- (IBAction)panRightSight:(id)sender;
- (IBAction)panLeftSight:(id)sender;
- (IBAction)panRightArrow:(id)sender;
- (IBAction)panLeftArrow:(id)sender;
- (IBAction)tapGesture:(id)sender;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

-(UIImage *) imageWithView:(UIView *)view;

@property (weak, nonatomic) IBOutlet UIImageView *leftSightImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightSightImage;
@property (weak, nonatomic) IBOutlet UIImageView *leftArrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImage;
@property (weak, nonatomic) IBOutlet UIView *leftLineArrow;
@property (weak, nonatomic) IBOutlet UIView *rightLineArrow;

//New version
@property (strong, nonatomic) IBOutlet UIView *screen1;
@property (strong, nonatomic) IBOutlet UIView *screen2;
@property (strong, nonatomic) IBOutlet UIView *screen3;
@property (strong, nonatomic) IBOutlet UIView *screen5;
@property (strong, nonatomic) IBOutlet UIView *screenPlayVideo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollScreenPD5;
@property (strong, nonatomic) IBOutlet UIView *screenPD5;
@property (weak, nonatomic) IBOutlet UIImageView *imagePD5;
@property (weak, nonatomic) IBOutlet UILabel *labelClinicalDistancePD5;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFieldPD5;
@property (weak, nonatomic) IBOutlet UITextField *emailTextFieldPD5;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFieldPD5;

@property (weak, nonatomic) IBOutlet UITextField *nameFieldNew;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UILabel *labelDistanceNew;
@property (strong, nonatomic) IBOutlet UIView *screenWelcome;
@property (strong, nonatomic) IBOutlet UIView *screenThanks;
@property (weak, nonatomic) IBOutlet UIButton *backToMenu;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDistanceValue;
@property (weak, nonatomic) IBOutlet UITextField *textFieldInchOrCm;
@property (weak, nonatomic) IBOutlet UITextField *textFieldValueReference;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLabelReferencing;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewScreen1;
@property (strong, nonatomic) IBOutlet UIView *screenWD1;
@property (strong, nonatomic) IBOutlet UIView *screenWD2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWD;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewEmail;

- (IBAction)email:(id)sender;
- (IBAction)backToMainMenu:(id)sender;
- (IBAction)openVideoClinicalWork:(id)sender;
- (IBAction)startClinicalWork:(id)sender;
- (IBAction)openVideoIPD:(id)sender;
- (IBAction)startIPD:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnVideoClinical;
@property (weak, nonatomic) IBOutlet UIButton *btnStartClinical;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoIPD;
@property (weak, nonatomic) IBOutlet UIButton *btnStartIPD;
@property (weak, nonatomic) IBOutlet UIButton *btnFuture1;
@property (weak, nonatomic) IBOutlet UIView *lineBetweenArrows;
@property (weak, nonatomic) IBOutlet UIButton *btnFuture2;
- (IBAction)resetAllCase:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)changeClinicalValue:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *dotViewLeft;
@property (weak, nonatomic) IBOutlet UIView *dotViewRight;
@property (weak, nonatomic) IBOutlet UILabel *lbRQName1;
@property (weak, nonatomic) IBOutlet UILabel *lbRQEmail1;
@property (weak, nonatomic) IBOutlet UILabel *lbRQPhone1;
@property (weak, nonatomic) IBOutlet UILabel *lbREName2;
@property (weak, nonatomic) IBOutlet UILabel *lbRQEmail2;
@property (weak, nonatomic) IBOutlet UILabel *lbRQPhone2;
@property (weak, nonatomic) IBOutlet UIImageView *imageAddMore;
@property (weak, nonatomic) IBOutlet UIImageView *imageSmallPD5;
- (IBAction)longPressSelected:(id)sender;
- (IBAction)addMorePhotoSelected:(id)sender;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *textViewPD7;
@property (weak, nonatomic) IBOutlet UIButton *addMorePhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendInfoPD5Btn;
@property (weak, nonatomic) IBOutlet UIImageView *imageAdMorePD7;
@property (weak, nonatomic) IBOutlet UIImageView *imageSmallPD7;
@property (weak, nonatomic) IBOutlet UIButton *btnAdMorePD7;
@property (weak, nonatomic) IBOutlet UIButton *sendEmailPD7;
- (IBAction)call:(id)sender;

@end
