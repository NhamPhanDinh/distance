//
//  MeasureViewController.m
//  PupilsDistance
//
//  Created by duongtv on 2/25/15.
//  Copyright (c) 2015 Trinh Van Duong. All rights reserved.
//

#import "MeasureViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "NWRequestController.h"
#import "MBProgressHUD.h"
#import "Helper.h"
#import "UIImage+Resize.h"

//setting view
#define PICKER_HEIGHT                       162
#define SETTING_DONE_HEIGHT                 40
#define PICKER_BUTTON_WIDTH                 50
#define PICKER_BUTTON_HEIGHT                30

@interface MeasureViewController (){
@private
    ALAssetsLibrary     * assetsLibrary_;
}

@property (nonatomic, strong) ALAssetsLibrary     * assetsLibrary;

@end

@implementation MeasureViewController
@synthesize assetsLibrary        = assetsLibrary_;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Demo
//    [self getDateJP];
//    [self convert];
    
    CGRect frame;
    _isSavePhotoPD5 = NO;
    _isAddMore = NO;
    self.imageAddMore.hidden = YES;
    self.imageSmallPD5.hidden = YES;
    self.imageSmallPD7.hidden = YES;
    self.imageAdMorePD7.hidden = YES;
    
    frame = self.viewArea.frame;
    frame.size.height = [Helper getScreenSize].size.height - self.navigationToolBar.frame.size.height - 20;
    frame.origin.y = self.navigationToolBar.frame.size.height + 20;
    self.viewArea.frame = frame;
    
    frame = self.scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = -20;
    frame.size.height = self.viewArea.frame.size.height + 20;
    self.scrollView.frame = frame;
    
    frame = self.imageSelected.frame;
    frame.size.height = self.viewArea.frame.size.height;
    frame.origin.y = 0;
    self.imageSelected.frame = frame;
    self.imageSelected.image = nil;
    
    //Setup scrollView
    CGSize size = self.scrollView.contentSize;
    size.height = self.imageSelected.frame.size.height;
    self.scrollView.contentSize = size;
    self.btnBack.hidden = YES;
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 5.0f;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.userInteractionEnabled = NO;

    //Arrow hidden
    _leftArrowView.hidden = YES;
    _rightArrowView.hidden = YES;
    _rightSightView.hidden = YES;
    _leftSightView.hidden = YES;
    _viewLine.hidden = YES;
    _lineBetweenArrows.hidden = YES;
    _labelDistanceValue.hidden = YES;
    
    [_leftArrowView removeFromSuperview];
    [_rightArrowView removeFromSuperview];
    [_leftSightView removeFromSuperview];
    [_rightSightView removeFromSuperview];
    [_viewLine removeFromSuperview];
    [_labelDistanceValue removeFromSuperview];
    [_lineBetweenArrows removeFromSuperview];

    [self.imageSelected addSubview:_leftSightView];
    [self.imageSelected addSubview:_rightSightView];
    [self.imageSelected addSubview:_leftArrowView];
    [self.imageSelected addSubview:_rightArrowView];
    [self.imageSelected addSubview:_labelDistanceValue];
    [self.imageSelected addSubview:_viewLine];
    [self.imageSelected addSubview:_lineBetweenArrows];
    
//    [self.imageSelected setUserInteractionEnabled:YES];
    [self.imageSelected setExclusiveTouch:YES];
    
    self.scrollView.canCancelContentTouches = NO;

    [self.leftArrowView setExclusiveTouch:YES];
    [self.rightArrowView setExclusiveTouch:YES];
    [self.leftSightView setExclusiveTouch:YES];
    [self.rightSightView setExclusiveTouch:YES];

    [_leftSightView setBackgroundColor:[UIColor clearColor]];
    [_rightSightView setBackgroundColor:[UIColor clearColor]];
    [_leftArrowView setBackgroundColor:[UIColor clearColor]];
    [_rightArrowView setBackgroundColor:[UIColor clearColor]];
    [_dotViewLeft setBackgroundColor:[UIColor clearColor]];
    [_dotViewRight setBackgroundColor:[UIColor clearColor]];
    
    //View guide
    frame = self.viewGuideZoom.frame;
    frame.size.width = self.viewArea.frame.size.width;
    self.viewGuideZoom.frame = frame;
    [self.viewArea addSubview:self.viewGuideZoom];
    self.viewGuideZoom.hidden = YES;
    
    frame = self.navigationToolBar.frame;
    frame.origin.y = 20;
    self.navigationToolBar.frame = frame;
    [self.navigationToolBar removeFromSuperview];
    [self.view addSubview:self.navigationToolBar];
    
    //State not image
    state = 0;
    isStartDistance = NO;
    
    //New version
    state = 0;
//    self.viewControlImage.hidden = NO;
    self.btnBack.hidden = YES;
    self.btnNext2.hidden = YES;
    self.resetButton.hidden = YES;
    self.resetButton.backgroundColor = [UIColor clearColor];
    
    self.screenPlayVideo.frame = self.viewArea.frame;
    self.screen2.frame = self.viewArea.frame;
    self.screen3.frame = self.viewArea.frame;
    self.screenWD1.frame = self.viewArea.frame;
    self.screenWD2.frame = self.viewArea.frame;
    
    frame = self.screen5.frame;
    frame.size.height = [Helper getScreenSize].size.height - self.tabBarController.tabBar.frame.size.height - self.navigationToolBar.frame.size.height - 20;
    frame.origin.y = self.navigationToolBar.frame.size.height + 20;
 
    self.screen5.frame = frame;
    self.screen1.frame = frame;
    self.screenThanks.frame = frame;
    self.screenWelcome.frame = frame;
    self.screenPD5.frame = frame;
    
    frame = self.scrollViewScreen1.frame;
    frame.size = self.screen1.frame.size;
    self.scrollViewScreen1.frame = frame;
    size = self.scrollViewScreen1.contentSize;
    size.height = 430;
    self.scrollViewScreen1.contentSize = size;
    
    frame = self.scrollViewEmail.frame;
    frame.size = self.screen5.frame.size;
    self.scrollViewEmail.frame = frame;
    size = self.scrollViewEmail.contentSize;
    size.height = 710;
    self.scrollViewEmail.contentSize = size;
    
    frame = self.scrollScreenPD5.frame;
    frame.size = self.screenPD5.frame.size;
    self.scrollScreenPD5.frame = frame;
    size = _scrollScreenPD5.contentSize;
    size.height = 700;
    self.scrollScreenPD5.contentSize = size;

//    self.screenWelcome.hidden = YES;
    self.screen1.hidden = YES;
    self.screen2.hidden = YES;
    self.screen3.hidden = YES;
    self.screenPD5.hidden = YES;
    self.screen5.hidden = YES;
    self.screenThanks.hidden = YES;
    self.screenPlayVideo.hidden = YES;
    self.screenWD1.hidden = YES;
    self.screenWD2.hidden = YES;

    _textFieldLabelReferencing.hidden = YES;
    _textFieldInchOrCm.hidden = YES;
    _textFieldValueReference.hidden = YES;
    _textFieldDistanceValue.hidden = YES;
    
    //Frame buttons
    CGPoint center = self.btnFuture1.center;
    self.btnFuture1.frame = self.btnStartClinical.frame;
    self.btnFuture1.center = center;
    
    center = self.btnFuture2.center;
    self.btnFuture2.frame = self.btnStartClinical.frame;
    self.btnFuture2.center = center;
    
//    [self.viewArea setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.screen1];
    [self.view addSubview:self.screen2];
    [self.view addSubview:self.screen3];
    [self.view addSubview:self.screenPD5];
    [self.view addSubview:self.screen5];
    [self.view addSubview:self.screenWelcome];
    [self.view addSubview:self.screenThanks];
    [self.view addSubview:self.screenPlayVideo];
    [self.view addSubview:self.screenWD1];
    [self.view addSubview:self.screenWD2];
    
    _isMoveView = NO;
    
    [self setupPickerView];
    [self checkCaseUsed];
    [self checkUserInfo];
    
    [_btnDone setExclusiveTouch:YES];
    [_btnCancel setExclusiveTouch:YES];
    [_btnBack setExclusiveTouch:YES];
    [_btnNext2 setExclusiveTouch:YES];
    [_btnStartClinical setExclusiveTouch:YES];
    [_btnVideoClinical setExclusiveTouch:YES];
    [_btnStartIPD setExclusiveTouch:YES];
    [_btnVideoIPD setExclusiveTouch:YES];
    [_textFieldWD setExclusiveTouch:YES];
    [_emailField setExclusiveTouch:YES];
    [_nameFieldNew setExclusiveTouch:YES];
    [_phoneField setExclusiveTouch:YES];
    [_textView setExclusiveTouch:YES];
    [_textViewPD7 setExclusiveTouch:YES];
    [_emailTextFieldPD5 setExclusiveTouch:YES];
    [_phoneTextFieldPD5 setExclusiveTouch:YES];

    [_btnAdMorePD7 setExclusiveTouch:YES];
    [_addMorePhotoBtn setExclusiveTouch:YES];
    [_sendEmailPD7 setExclusiveTouch:YES];
    [_sendInfoPD5Btn setExclusiveTouch:YES];

}

- (void)sendInfo{
    BOOL check = NO;
    if(state == 5){
        if([_nameTextFieldPD5.text length] == 0 || [_emailTextFieldPD5.text length] == 0 || [_phoneTextFieldPD5.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info error!" message:@"Please, fill the box with your information before sending. Thank you" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }else{
            check = YES;
        }
    }else{
        if([_nameFieldNew.text length] == 0 || [_emailField.text length] == 0 || [_phoneField.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info error!" message:@"Please, fill the box with your information before sending. Thank you" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }else{
            check = YES;
        }
    }
    
    if(check == YES){
        [self saveUserInfo];
        
        NSData *data;
        if (state == 5)
        {
            //self.imageAddMore.image = [chosenImage resizedImage:CGSizeMake(800, 800*percent) interpolationQuality:kCGInterpolationMedium];
            
            UIImage *scaleImage = [self.imageSelected.image resizedImage:CGSizeMake(self.imageSelected.image.size.width/(self.imageSelected.image.size.height/1000), 1000) interpolationQuality:kCGInterpolationDefault];
            
            
            data = UIImageJPEGRepresentation(scaleImage, 0.92f);
        }
        else
        {
            data = UIImageJPEGRepresentation(_imageCapture, 0.92f);
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDate *createdDate = [NSDate date];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
        NSString *theDateCreated = [dateFormat stringFromDate:createdDate];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            id obj;
            if(state == 5){
                obj = [self uploadImage:_nameTextFieldPD5.text andMail:_emailTextFieldPD5.text andPhone:_phoneTextFieldPD5.text andClinical:_clinicalWorkDistanceValue andDistance:@" " andNote:self.textView.text andFileName:theDateCreated  andPathImage:data];
                
            }else{
                obj = [self uploadImage:_nameFieldNew.text andMail:_emailField.text andPhone:_phoneField.text andClinical:_clinicalWorkDistanceValue andDistance:[NSString stringWithFormat:@"%.2fmm",_originalDistance] andNote:self.textViewPD7.text andFileName:theDateCreated andPathImage:data];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if  (obj && [obj isKindOfClass:[NSDictionary class]]){
                    int status = [(obj[@"success"]) intValue] ;
                    
                    if (status == 1) {
                        // save last edit
                        // save last edit
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Great! Email has been successfully sent to"
                                                                        message:@"loupes@lumadent.com"
                                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        NSLog(@"Success upload");
                        alert.tag = 1;
                        [alert show];
                    } else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"Send Email Fail! Please try it again"
                                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        
                        [alert show];
                        NSLog(@"upload fail");
                    }
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"Send Email Fail! Please try it again"
                                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                    NSLog(@"upload fail");
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            _isSavePhotoPD5 = NO;
            _typeFlowView = 0;
            _isAddMore = NO;
            
            self.resetButton.hidden = NO;
            self.btnBack.hidden = NO;
            self.btnNext2.hidden = YES;
            self.screen1.hidden = NO;
            self.screen2.hidden = YES;
            self.screen3.hidden = YES;
            self.screen5.hidden = YES;
            self.screenPD5.hidden = YES;
            self.screenWelcome.hidden = YES;
            self.screenThanks.hidden = YES;
            self.imageSelected.image = nil;
            
            _leftArrowView.hidden = YES;
            _rightArrowView.hidden = YES;
            _leftArrowView.hidden = YES;
            _rightArrowView.hidden = YES;
            _leftSightView.hidden = YES;
            _rightSightView.hidden = YES;
            _lineBetweenArrows.hidden = YES;
            _viewLine.hidden = YES;
            
            state = 1;
        }
    }
}

- (void)checkUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"nameUser"]){
        self.nameFieldNew.text = [defaults objectForKey:@"nameUser"];
        self.nameTextFieldPD5.text = [defaults objectForKey:@"nameUser"];
        self.lbRQName1.hidden = YES;
        self.lbREName2.hidden = YES;
    }else{
        self.nameFieldNew.text = @"";
        self.nameTextFieldPD5.text = @"";
        self.lbRQName1.hidden = NO;
        self.lbREName2.hidden = NO;
    }
    
    if([defaults objectForKey:@"emailUser"]){
        self.emailField.text = [defaults objectForKey:@"emailUser"];
        self.emailTextFieldPD5.text = [defaults objectForKey:@"emailUser"];
        self.lbRQEmail1.hidden = YES;
        self.lbRQEmail2.hidden = YES;
    }else{
        self.emailField.text = @"";
        self.emailTextFieldPD5.text = @"";
        self.lbRQEmail1.hidden = NO;
        self.lbRQEmail2.hidden = NO;
    }
    
    if([defaults objectForKey:@"phoneUser"]){
        self.phoneField.text = [defaults objectForKey:@"phoneUser"];
        self.phoneTextFieldPD5.text = [defaults objectForKey:@"phoneUser"];
        self.lbRQPhone1.hidden = YES;
        self.lbRQPhone2.hidden = YES;
    }else{
        self.phoneField.text = @"";
        self.phoneTextFieldPD5.text = @"";
        self.lbRQPhone1.hidden = NO;
        self.lbRQPhone2.hidden = NO;
    }
}

- (void)saveUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([self.nameTextFieldPD5.text length]>0){
        [defaults setObject:self.nameTextFieldPD5.text forKey:@"nameUser"];
    }else{
        [defaults setObject:self.nameFieldNew.text forKey:@"nameUser"];
    }
    
    if([self.emailTextFieldPD5.text length] > 0){
        [defaults setObject:self.emailTextFieldPD5.text forKey:@"emailUser"];
    }else{
        [defaults setObject:self.emailField.text forKey:@"emailUser"];
    }
    
    if([self.phoneTextFieldPD5.text length] > 0){
        [defaults setObject:self.phoneTextFieldPD5.text forKey:@"phoneUser"];
    }else{
        [defaults setObject:self.phoneField.text forKey:@"phoneUser"];
    }
    [defaults synchronize];
}


- (void)checkCaseUsed{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"case1"]){
        NSLog(@"USED CASE 1");
        [self.btnVideoClinical setImage:[UIImage imageNamed:@"btnMenuVideoOverViewTicked.png"] forState:UIControlStateNormal];
    }else{
        NSLog(@"NOT USED CASE 1 YET");
        [self.btnVideoClinical setImage:[UIImage imageNamed:@"btnMenuVideoOverView.png"] forState:UIControlStateNormal];
    }
    
    if([defaults objectForKey:@"case2"]){
        NSLog(@"USED CASE 2");
        [self.btnStartClinical setImage:[UIImage imageNamed:@"btnMenuReadyStartTicked.png"] forState:UIControlStateNormal];
    }else{
        NSLog(@"NOT USED CASE 2 YET");
        [self.btnStartClinical setImage:[UIImage imageNamed:@"btnMenuReadyStart.png"] forState:UIControlStateNormal];
    }
    
    if([defaults objectForKey:@"case3"]){
        NSLog(@"USED CASE 3");
        [self.btnVideoIPD setImage:[UIImage imageNamed:@"btnMenuVideoOverViewTicked.png"] forState:UIControlStateNormal];
    }else{
        NSLog(@"NOT USED CASE 3 YET");
        [self.btnVideoIPD setImage:[UIImage imageNamed:@"btnMenuVideoOverView.png"] forState:UIControlStateNormal];
    }
    
    if([defaults objectForKey:@"case4"]){
        NSLog(@"USED CASE 4");
        [self.btnStartIPD setImage:[UIImage imageNamed:@"btnMenuReadyStartTicked.png"] forState:UIControlStateNormal];
    }else{
        NSLog(@"NOT USED CASE 4 YET");
        [self.btnStartIPD setImage:[UIImage imageNamed:@"btnMenuReadyStart.png"] forState:UIControlStateNormal];
    }
}

- (void)setupPickerView{
    _listValueWD = @[@"Measure and select",@"13 INCHES = 33 CM", @"15 INCHES = 38 CM",@"17 INCHES = 43 CM",@"19 INCHES = 48 CM",@"22 INCHES = 56 CM"];
    _listValueIPD = @[@"Cm",@"Inch"];
    _clinicalWorkDistanceValue = @"Measure and select";
    
    //init picker view
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self.view addSubview: _pickerView];
    _pickerData = [[NSMutableArray alloc] init];
    
    //button
    _btnDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnDone setTitle:@"Done" forState:0];
    [_btnDone addTarget:self action:@selector(pickerDoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnCancel setTitle:@"Cancel" forState:0];
    [_btnCancel addTarget:self action:@selector(pickerCancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnDone];
    [self.view addSubview:_btnCancel];
    
    CGRect pickerFrame = self.view.frame;
    pickerFrame.origin.y = [Helper getScreenSize].size.height;
    pickerFrame.size.width = [Helper getScreenSize].size.width;
    pickerFrame.size.height = PICKER_HEIGHT;
    [_pickerView setFrame:pickerFrame];
    [_pickerView setBackgroundColor:[UIColor lightGrayColor]];
    
    //button frame
    CGRect btnFrame = pickerFrame;
    btnFrame.origin.x = pickerFrame.size.width - PICKER_BUTTON_WIDTH;
    btnFrame.size.width = PICKER_BUTTON_WIDTH;
    btnFrame.size.height = PICKER_BUTTON_HEIGHT;
    [_btnDone setFrame: btnFrame];
    btnFrame.origin.x = 10;
    [_btnCancel setFrame:btnFrame];
    
    //set source for pickerview
    self.textFieldInchOrCm.inputView = _pickerView;
    self.textFieldWD.inputView = _pickerView;
}

- (void)showPickerView {
    [self.view endEditing:YES];
    
    [_pickerView selectRow:0 inComponent:0 animated:NO];
    
    [UIView animateWithDuration:0.5f animations:^{
        CGRect pickerFrame = _pickerView.frame;
        pickerFrame.origin.y -= PICKER_HEIGHT;
        CGRect btnDoneFrame = _btnDone.frame;
        CGRect btnCancelFrame = _btnCancel.frame;
        btnDoneFrame.origin.y = pickerFrame.origin.y;
        btnCancelFrame.origin.y = pickerFrame.origin.y;
        _pickerView.frame = pickerFrame;
        _btnDone.frame = btnDoneFrame;
        _btnCancel.frame = btnCancelFrame;
    } completion:^(BOOL finished) {
        [self.textFieldInchOrCm setUserInteractionEnabled:NO];
        [self.textFieldWD setUserInteractionEnabled:NO];
    }];
}

- (void)hidenPickerView {
    if (_isMoveView) {
        _isMoveView = NO;
        [UIView animateWithDuration:0.5f animations:^{
            CGRect pickerFrame = _pickerView.frame;
            pickerFrame.origin.y += PICKER_HEIGHT;
            CGRect btnDoneFrame = _btnDone.frame;
            CGRect btnCancelFrame = _btnCancel.frame;
            btnDoneFrame.origin.y = pickerFrame.origin.y;
            btnCancelFrame.origin.y = pickerFrame.origin.y;
            _pickerView.frame = pickerFrame;
            _btnDone.frame = btnDoneFrame;
            _btnCancel.frame = btnCancelFrame;
            
            if(_typeFlowView == 0){
                [UIView animateWithDuration:0.4f animations:^{
                    CGRect viewFrame = self.screenWD2.frame;
                    viewFrame.origin.y += (PICKER_HEIGHT);
                    self.screenWD2.frame = viewFrame;
                }];
                
            }
            
        } completion:^(BOOL finished) {
            [self.textFieldInchOrCm setUserInteractionEnabled:YES];
            [self.textFieldWD setUserInteractionEnabled:YES];
        }];
    }
}


- (IBAction)pickerDoneButtonClick:(id)sender {
    if(_pickerTag == 4){
        _clinicalWorkDistanceValue = _pickerValue;
        self.textFieldWD.text = _pickerValue;

        [self.labelClinicalDistancePD5 setText:[NSString stringWithFormat:@"CLINICAL WORKING DISTANCE: %@",_clinicalWorkDistanceValue]];
        [self.labelClinicalWork setText:[NSString stringWithFormat:@"CLINICAL WORKING DISTANCE: %@",_clinicalWorkDistanceValue]];
    }else if(_pickerTag == 2){
        self.textFieldInchOrCm.text = _pickerValue;
    }

    [self hidenPickerView];
    
    if (_typeFlowView == 1) {
//        valueReferencingDistance = [self.textFieldValueReference.text floatValue];
        
//        if(valueReferencingDistance < 0){
//            valueReferencingDistance = 0;
//        }

        [self updateDistance];
    }
}

- (IBAction)pickerCancelButtonClick:(id)sender {
    [self hidenPickerView];
}

#pragma mark - UIPickerView datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}
#pragma mark - UIPicker delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pickerValue = _pickerData[row];

    //    NSLog(@"SELECTED");
//    if(_pickerTag == 4){
//        self.textFieldWD.text = _pickerValue;
//    }else if (_pickerTag == 2){
//        self.textFieldInchOrCm.text = _pickerValue;
//    }
}


- (void)playVideo:(int)type{
    [_moviePlayer.view removeFromSuperview];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"videoDemo" ofType:@"mp4"]];
    
    MPMoviePlayerController *player1 = [[MPMoviePlayerController alloc]initWithContentURL:url];
    [player1 prepareToPlay];
    [player1 setControlStyle:MPMovieControlStyleNone];
    player1.backgroundView.hidden = YES;
    [player1 setRepeatMode:MPMovieRepeatModeOne];
    self.moviePlayer = player1;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:player1];
    
    
    [_moviePlayer.view setFrame: CGRectMake(0, self.screenPlayVideo.frame.size.height*0.2, self.screenPlayVideo.frame.size.width, self.screenPlayVideo.frame.size.height*0.6f)];
    [_moviePlayer.view setAutoresizesSubviews:YES];
    [_moviePlayer.view setClipsToBounds:YES];
    [_moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
//    [_moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    [_moviePlayer.view setUserInteractionEnabled:YES];
    [_moviePlayer.view setMultipleTouchEnabled:NO];
//    [_moviePlayer.view setBackgroundColor:[UIColor colorWithRed:215.0f/255.0f green:212.0f/212.0f/215.0f blue:212.0f/215.0f alpha:1.0f]];
    
    [[[self.moviePlayer view] subviews] enumerateObjectsUsingBlock:^(id view, NSUInteger idx, BOOL *stop) {
        [[view gestureRecognizers] enumerateObjectsUsingBlock:^(id pinch, NSUInteger idx, BOOL *stop) {
            if([pinch isKindOfClass:[UIPinchGestureRecognizer class]]) {
                [view removeGestureRecognizer:pinch];
            }
        }];
    }];
    
    [self.screenPlayVideo addSubview:_moviePlayer.view];
    [self.screenPlayVideo sendSubviewToBack:_moviePlayer.view];
    
    [_moviePlayer play];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *str;

    switch ([AppDelegate shareApp].typeColor) {
        case 0:
            str = @"_white.png";
            self.labelDistanceValue.textColor = [UIColor whiteColor];
            [self.leftLineArrow setBackgroundColor:[UIColor whiteColor]];
            [self.rightLineArrow setBackgroundColor:[UIColor whiteColor]];
            [self.viewLine setBackgroundColor:[UIColor whiteColor]];
            break;
        case 1:
            str = @"_black.png";
            self.labelDistanceValue.textColor = [UIColor blackColor];
            [self.leftLineArrow setBackgroundColor:[UIColor blackColor]];
            [self.rightLineArrow setBackgroundColor:[UIColor blackColor]];
            [self.viewLine setBackgroundColor:[UIColor blackColor]];
            break;
        case 2:
            str = @"_yellow.png";
            self.labelDistanceValue.textColor = [UIColor yellowColor];
            [self.leftLineArrow setBackgroundColor:[UIColor yellowColor]];
            [self.rightLineArrow setBackgroundColor:[UIColor yellowColor]];
            [self.viewLine setBackgroundColor:[UIColor yellowColor]];
            break;
        case 3:
            str = @"mark.png";
            self.labelDistanceValue.textColor = [UIColor colorWithRed:234.0f/255.0f green:0 blue:0 alpha:1.0f];
            [self.leftLineArrow setBackgroundColor:[UIColor colorWithRed:234.0f/255.0f green:0 blue:0 alpha:1.0f]];
            [self.rightLineArrow setBackgroundColor:[UIColor colorWithRed:234.0f/255.0f green:0 blue:0 alpha:1.0f]];
            [self.viewLine setBackgroundColor:[UIColor colorWithRed:234.0f/255.0f green:0 blue:0 alpha:1.0f]];
            break;
        case 4:
            str = @"_blue.png";
            self.labelDistanceValue.textColor = [UIColor colorWithRed:7.0f/255.0f green:213.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
            [self.leftLineArrow setBackgroundColor:[UIColor colorWithRed:7.0f/255.0f green:213.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
            [self.rightLineArrow setBackgroundColor:[UIColor colorWithRed:7.0f/255.0f green:213.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
            [self.viewLine setBackgroundColor:[UIColor colorWithRed:7.0f/255.0f green:213.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
            break;
        case 5:
            str = @"_grey.png";
            self.labelDistanceValue.textColor = [UIColor grayColor];
            [self.leftLineArrow setBackgroundColor:[UIColor grayColor]];
            [self.rightLineArrow setBackgroundColor:[UIColor grayColor]];
            [self.viewLine setBackgroundColor:[UIColor grayColor]];
            break;
            
        default:
            break;
    }
    
    [self.leftSightImage setImage:[UIImage imageNamed:@"mark.png"]];
    [self.rightSightImage setImage:[UIImage imageNamed:@"mark.png"]];
//    [self.leftArrowImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leftArrow%@",str]]];
//    [self.rightArrowImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rightArrow%@",str]]];
    
    if([AppDelegate shareApp].typeTargetSize == 0){
        _targetSize = 86.5f;
    }else if([AppDelegate shareApp].typeTargetSize == 1){
        _targetSize = 90.0f;
    }else if([AppDelegate shareApp].typeTargetSize == 2){
        _targetSize = 100.0f;
    }else{
        _targetSize = 86.5f;
    }
    
    if(state == 5){
        [self updateDistance];
    }
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [UIView setAnimationsEnabled:NO];
    
    [coordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [UIView setAnimationsEnabled:YES];
    }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)centerScrollViewContents {
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageSelected.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageSelected.frame = contentsFrame;
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

#pragma ScrollView delegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return self.imageSelected;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

///

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.library = nil;
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        viewController.navigationController.navigationBar.translucent = NO;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)showcamera {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.navigationController.navigationBar.translucent = NO;
    
    //Open photo view
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        
        CGRect frame = imagePicker.view.frame;
        //frame.origin.y = 0;
        frame.origin.y = 40+31;
        frame.size.height = 1.33333333333*frame.size.width;
        
        GridView *grid;
        if (!_isAddMore)
        {
            grid = [[GridView alloc] initWithBlackBorder:YES];
        }
        else
        {
            grid = [[GridView alloc] initWithBlackBorder:NO];
        }
        
        grid.frame = frame;
        
        grid.numberOfColumns = 2;
        grid.numberOfRows = 2;
        [grid setBackgroundColor:[UIColor clearColor]];
        
        if (self.view.bounds.size.width == 320)
        {
            imagePicker.cameraViewTransform = CGAffineTransformTranslate(imagePicker.cameraViewTransform, 0, 31);
        }
        else
        {
            imagePicker.cameraViewTransform = CGAffineTransformTranslate(imagePicker.cameraViewTransform, 0, 44);
        }
        
         imagePicker.showsCameraControls = true;
        
        //Create camera overlay
        // CGRect f = imagePicker.view.bounds;
        // f.size.height -= imagePicker.navigationBar.bounds.size.height;
        // CGFloat barHeight = (f.size.height - f.size.width) / 2;
        // barHeight = imagePicker.navigationBar.bounds.size.height;

//        imagePicker.view.layer.borderColor = (__bridge CGColorRef)([UIColor redColor]);
//        imagePicker.view.layer.borderWidth = 2.0f;
        
        // UIGraphicsBeginImageContext(f.size);
        // [[UIColor colorWithWhite:0 alpha:0.3] set];
        
        // UIRectFillUsingBlendMode(CGRectMake(0, 0, f.size.width, barHeight), kCGBlendModeNormal);
        
//        NSLog(@"%f",imagePicker.toolbar.frame.size.height);
        // UIRectFillUsingBlendMode(CGRectMake(0,imagePicker.view.frame.size.height - barHeight - 110, f.size.width, barHeight), kCGBlendModeNormal);
        
        // UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
        // UIGraphicsEndImageContext();
        
        // UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:imagePicker.view.bounds];
        // overlayIV.image = overlayImage;
        // [overlayIV addSubview:grid];
        // [imagePicker.cameraOverlayView addSubview:overlayIV];
        
        
        
        [imagePicker setCameraOverlayView:grid];

    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (UIImage *)cropImage:(UIImage*)img rect:(CGRect)rect {
    
    rect = CGRectMake(rect.origin.x*img.scale,
                      rect.origin.y*img.scale,
                      rect.size.width*img.scale,
                      rect.size.height*img.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:img.scale
                                    orientation:img.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage  *chosen = [info[UIImagePickerControllerOriginalImage] fixOrientation];
    UIImage *chosenImage;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if (!_isAddMore)
        {
            chosenImage = [self cropImage:chosen rect:CGRectMake(0, chosen.size.height/3, chosen.size.width, chosen.size.height/3)];
        }
        else
        {
            chosenImage = chosen;
        }
        [self saveImage:chosenImage];
    }
    else
    {
        chosenImage = chosen;
    }
    
    
    if(_isAddMore){
        
        //[self saveImage:chosenImage];
        
        float percent = chosenImage.size.height/chosenImage.size.width;
        
        //self.imageAddMore.image = [chosenImage resizedImage:CGSizeMake(800, 800*percent) interpolationQuality:kCGInterpolationMedium];
        
        self.imageAddMore.image = chosenImage;
        self.imageSmallPD5.image = self.imagePD5.image;
        self.imagePD5.hidden = YES;
        self.addMorePhotoBtn.hidden = YES;
        self.imageSmallPD5.hidden = NO;
        self.imageAddMore.hidden = NO;
        
        self.imageAdMorePD7.image = chosenImage;
//        NSData *imageData = UIImageJPEGRepresentation(self.imageAdMorePD7.image, 1);
//        NSLog(@"image data: %ld",imageData.length);
        self.imageSmallPD7.image = self.imageViewEmail.image;
        self.imageViewEmail.hidden = YES;
        self.imageSmallPD7.hidden = NO;
        self.imageAdMorePD7.hidden = NO;
        self.btnAdMorePD7.hidden = YES;
        
        CGRect frame = self.sendInfoPD5Btn.frame;
        frame.origin.y = self.imageAddMore.frame.origin.y + self.imageAddMore.frame.size.height + 20;
        self.sendInfoPD5Btn.frame = frame;
        
        CGSize size = _scrollScreenPD5.contentSize;
        size.height = 550;
        self.scrollScreenPD5.contentSize = size;
        
        frame = self.sendEmailPD7.frame;
        frame.origin.y = self.imageAdMorePD7.frame.origin.y + self.imageAdMorePD7.frame.size.height + 20;
        self.sendEmailPD7.frame = frame;
        
        size = _scrollViewEmail.contentSize;
        size.height = 550;
        self.scrollViewEmail.contentSize = size;
    }else{
        //New version
        self.imageSelected.image = chosenImage;
        
        [self.scrollView setBackgroundColor:[UIColor grayColor]];
        self.scrollView.userInteractionEnabled = YES;
        
        self.viewGuideZoom.hidden = NO;
        _leftArrowView.hidden = YES;
        _rightArrowView.hidden = YES;
        _leftArrowView.hidden = YES;
        _rightArrowView.hidden = YES;
        _leftSightView.hidden = YES;
        _rightSightView.hidden = YES;
        _lineBetweenArrows.hidden = YES;
        _viewLine.hidden = YES;
        
        _textFieldLabelReferencing.hidden = YES;
        _textFieldInchOrCm.hidden = YES;
        _textFieldValueReference.hidden = YES;
        _textFieldDistanceValue.hidden = YES;
        
        NSLog(@"SIZE1 : %f - SIZE2: %f",self.scrollView.frame.size.height,self.scrollView.contentSize.height);
        
        state = 4;
    }
    
        [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if(_isAddMore){
        _isAddMore = NO;
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.screen1.hidden = YES;
    self.screen2.hidden = YES;
    self.screen3.hidden = NO;
    state = 3;
}

- (IBAction)saveActionSelected:(id)sender {
    if(state == 5){
        //Save image
        [self.scrollView setBackgroundColor:[UIColor whiteColor]];
        
        UIGraphicsBeginImageContextWithOptions(self.viewArea.bounds.size, self.viewArea.opaque, 0.0);
        [self.viewArea.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *pngData = UIImagePNGRepresentation(img);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"imageSaved.png"]]; //Add the file name
        [pngData writeToFile:filePath atomically:YES]; //Write the file
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setFloat:_originalDistance forKey:_fieldName.text];
//        [defaults synchronize];
        
        //Reset control
        self.btnBack.hidden = YES;
        self.imageSelected.image = nil;
        self.scrollView.zoomScale = 1.0f;
        [self.scrollView setBackgroundColor:[UIColor clearColor]];
        
//        self.viewControlImage.hidden = YES;
        self.btnNext2.hidden = YES;

        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 5.0f;
        self.scrollView.zoomScale = 1.0;
        self.scrollView.userInteractionEnabled = NO;
        [self centerScrollViewContents];

        _leftArrowView.hidden = YES;
        _rightArrowView.hidden = YES;
        _rightSightView.hidden = YES;
        _leftSightView.hidden = YES;
        _viewLine.hidden = YES;
        _labelDistanceValue.hidden = YES;
        isStartDistance = NO;
        
        self.tabBarController.selectedIndex = 1;
        state = 0;
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Measurements" message:@"Please add a measurement to this image before saving" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

-(UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(self.viewArea.bounds.size, self.viewArea.opaque, 0.0);
    [self.viewArea.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    return img;
}

- (IBAction)backActionSelected:(id)sender {
    [self.view endEditing:YES];
    if(_typeFlowView == 1 && _isMoveView){
        [self hidenPickerView];
    }
    _isMoveView = NO;
    
    if(_typeFlowView == 0){
        if(state == 3){
//            self.viewControlImage.hidden = NO;
            self.btnNext2.hidden = NO;
            self.screenWelcome.hidden = YES;
            self.screenWD2.hidden = YES;
            self.screenWD1.hidden = NO;
        }
        else if(state == 2){
            if(_isFlowWithVideo && self.screenPlayVideo.hidden){
//                self.viewControlImage.hidden = NO;
                self.btnBack.hidden = NO;
                self.screenWelcome.hidden = YES;
                self.btnNext2.hidden = NO;
                self.screenWD1.hidden = YES;
                self.screenWD2.hidden = YES;
                self.screenPlayVideo.hidden = NO;
                [self playVideo:1];
                
                return;
            }else if(_isFlowWithVideo && !self.screenPlayVideo.hidden){
                self.screenPlayVideo.hidden = YES;
                [_moviePlayer stop];
                self.btnNext2.hidden = YES;
                self.screen1.hidden = NO;
                self.resetButton.hidden = NO;
                self.screenWD1.hidden = YES;
                self.screenWD2.hidden = YES;
            }
            else if(!_isFlowWithVideo){
                self.btnNext2.hidden = YES;
                self.screen1.hidden = NO;
                self.resetButton.hidden = NO;
                self.screenWD1.hidden = YES;
                self.screenWD2.hidden = YES;
            }
        }else if(state == 1){
            self.resetButton.hidden = YES;
            self.btnNext2.hidden = YES;
            self.btnBack.hidden = YES;
            self.screen1.hidden = YES;
            self.screen2.hidden = YES;
            self.screen3.hidden = YES;
            self.screenWelcome.hidden = NO;
        }
    }else if(_typeFlowView == 1){
        ///New version
        if(state == 7){
            self.screen5.hidden = YES;
            self.btnNext2.hidden = NO;
            
            if ([self.emailField.text length] > 0) {
                self.emailTextFieldPD5.text = self.emailField.text;
                self.lbRQEmail2.hidden = YES;
            }
            
            if ([self.nameFieldNew.text length] > 0){
                self.nameTextFieldPD5.text = self.nameFieldNew.text;
                self.lbREName2.hidden = YES;
            }
            
            if([self.phoneField.text length] > 0){
                self.phoneTextFieldPD5.text = self.phoneField.text;
                self.lbRQPhone2.hidden = YES;
            }
            
        }else if (state == 6){
            _leftArrowView.hidden = YES;
            _rightArrowView.hidden = YES;
            _leftArrowView.hidden = YES;
            _rightArrowView.hidden = YES;
            _leftSightView.hidden = YES;
            _rightSightView.hidden = YES;
            _lineBetweenArrows.hidden = YES;
            
            _textFieldLabelReferencing.hidden = YES;
            _textFieldInchOrCm.hidden = YES;
            _textFieldValueReference.hidden = YES;
            _textFieldDistanceValue.hidden = YES;
            
            _viewLine.hidden = YES;
            _labelDistanceValue.hidden = YES;

            [self captureScreenAfterDistance];
            self.screenPD5.hidden = NO;
            _longPressGesture.enabled = YES;
            self.btnNext2.hidden = YES;
        }
        else if (state == 5){
            _longPressGesture.enabled = NO;
            self.btnNext2.hidden = NO;
            self.screenPD5.hidden = YES;
            _viewGuideZoom.hidden = NO;
         //            self.scrollView.userInteractionEnabled = YES;
//            self.scrollView.scrollEnabled = YES;
        }else if (state == 4) {
            _isAddMore = NO;
            _isSavePhotoPD5 = NO;
            _viewGuideZoom.hidden = YES;
            self.screen1.hidden = YES;
            self.screen2.hidden = YES;
            self.screen3.hidden = NO;
            self.imageSelected.image = nil;
        }else if(state == 3){
            self.btnNext2.hidden = NO;
            self.screenWelcome.hidden = YES;
            self.screen1.hidden = YES;
            self.screen2.hidden = NO;
            self.screen3.hidden = YES;
        }
        else if(state == 2){
            [self checkCaseUsed];
            if(_isFlowWithVideo && self.screenPlayVideo.hidden){
                self.btnBack.hidden = NO;
                self.screenWelcome.hidden = YES;
                self.btnNext2.hidden = NO;
                self.screen1.hidden = YES;
                self.screen2.hidden = YES;
                self.screen3.hidden = YES;
                self.screenPlayVideo.hidden = NO;
                [self playVideo:1];
                
                return;
            }else if(_isFlowWithVideo && !self.screenPlayVideo.hidden){
                self.screenPlayVideo.hidden = YES;
                [_moviePlayer stop];
                self.btnNext2.hidden = YES;
                self.screen1.hidden = NO;
                self.resetButton.hidden = NO;
                self.screen2.hidden = YES;
                self.screen3.hidden = YES;
            }
            else if(!_isFlowWithVideo){
                self.btnNext2.hidden = YES;
                self.screen1.hidden = NO;
                self.resetButton.hidden = NO;
                self.screen2.hidden = YES;
                self.screen3.hidden = YES;
            }
        }else if(state == 1){
            self.btnNext2.hidden = YES;
            self.btnBack.hidden = YES;
            self.screen1.hidden = YES;
            self.screen2.hidden = YES;
            self.screen3.hidden = YES;
            self.resetButton.hidden = YES;
            self.screenWelcome.hidden = NO;
        }
    }
    
    if(state > 0){
        state --;
    }
    NSLog(@"STATE: %d",state);
}

- (IBAction)nextSelected:(id)sender {
    if(_typeFlowView == 1 && _isMoveView){
        [self hidenPickerView];
    }
    _isMoveView = NO;
    
    //New version
    if(state == 0){
        self.btnBack.hidden = NO;
        self.screenWelcome.hidden = YES;
        self.btnNext2.hidden = YES;
        self.resetButton.hidden = NO;
//        self.viewControlImage.hidden = YES;
        self.screen1.hidden = NO;
        self.screen2.hidden = YES;
        self.screen3.hidden = YES;
    }
        
    if(_typeFlowView == 0){
        if(state == 2){
            if(!self.screenPlayVideo.hidden){
                self.screenPlayVideo.hidden = YES;
                [_moviePlayer stop];
                
//                self.viewControlImage.hidden = NO;
                self.btnNext2.hidden = NO;
                self.screenWelcome.hidden = YES;
                self.screenWD1.hidden = NO;
                self.screenWD2.hidden = YES;
                return;
            }else{
                self.screenWD1.hidden = YES;
                self.screenWD2.hidden = NO;
            }

        }else if(state == 3){
            self.screenWelcome.hidden = YES;
            self.btnNext2.hidden = YES;
            self.resetButton.hidden = NO;
//            self.viewControlImage.hidden = YES;
            self.screen1.hidden = NO;
            self.screenWD1.hidden = YES;
            self.screenWD2.hidden = YES;
            state = 1;
            return;
        }
    }
    else if(_typeFlowView == 1){
        if(state == 1){

        }else if(state == 2){
            if(!self.screenPlayVideo.hidden){
                self.screenPlayVideo.hidden = YES;
                [_moviePlayer stop];
                
//                self.viewControlImage.hidden = NO;
                self.btnNext2.hidden = NO;
                self.screenWelcome.hidden = YES;
                self.screen1.hidden = YES;
                self.screen2.hidden = NO;
                self.screen3.hidden = YES;
                
                return;
            }else{
                self.screen1.hidden = YES;
                self.screen2.hidden = YES;
                self.screen3.hidden = NO;
            }
        }else if(state == 3){
            self.screen1.hidden = YES;
            self.screen2.hidden = YES;
            self.screen3.hidden = YES;
            
            [self showcamera];
        }else if(state == 4){
            if(!_isAddMore){
                self.imageSmallPD5.hidden = YES;
                self.imageAddMore.hidden = YES;
                self.addMorePhotoBtn.hidden = NO;
                self.imagePD5.hidden = NO;
                self.imageAddMore.image = nil;
                
                CGRect frame = self.addMorePhotoBtn.frame;
                frame.origin.y = self.imagePD5.frame.origin.y + self.imagePD5.frame.size.height + 20;
                self.addMorePhotoBtn.frame = frame;
                
                frame = self.sendInfoPD5Btn.frame;
                frame.origin.y = self.addMorePhotoBtn.frame.origin.y + self.addMorePhotoBtn.frame.size.height + 20;
                self.sendInfoPD5Btn.frame = frame;
                
                CGSize size = _scrollScreenPD5.contentSize;
                size.height = 700;
                self.scrollScreenPD5.contentSize = size;
            }else{
                self.imageSmallPD5.hidden = NO;
                self.imageAddMore.hidden = NO;
                self.addMorePhotoBtn.hidden = YES;
                self.imagePD5.hidden = YES;
            }
           
            self.longPressGesture.enabled = YES;
            _viewGuideZoom.hidden = YES;
            self.btnNext2.hidden = YES;
            [self captureScreenAfterDistance];
            self.screenPD5.hidden = NO;
            //self.imagePD5.image = _imageCapture;
            self.imagePD5.image = self.imageSelected.image;
            if(!_isSavePhotoPD5){
                //[self saveImage:self.imagePD5.image];
                _isSavePhotoPD5 = YES;
            }
            
            if([_clinicalWorkDistanceValue length] > 0){
                [self.labelClinicalDistancePD5 setText:[NSString stringWithFormat:@"CLINICAL WORKING DISTANCE: %@",_clinicalWorkDistanceValue]];
            }else{
                [self.labelClinicalDistancePD5 setText:[NSString stringWithFormat:@"CLINICAL WORKING DISTANCE: "]];
            }
        }
        else if(state == 5){
            self.screenPD5.hidden = YES;
            _leftSightView.hidden = NO;
            _rightSightView.hidden = NO;
            _leftArrowView.hidden = NO;
            _rightArrowView.hidden = NO;
            _viewLine.hidden = NO;
            _labelDistanceValue.hidden = NO;
            _lineBetweenArrows.hidden = NO;
            
            _textFieldInchOrCm.hidden = NO;
            _textFieldValueReference.hidden = NO;
            _textFieldDistanceValue.hidden = NO;
            _textFieldLabelReferencing.hidden = NO;
            
//            self.scrollView.userInteractionEnabled = NO;
//            self.scrollView.scrollEnabled = NO;
            _btnNext2.hidden = NO;
            [self updateDistance];
        }else if(state == 6){
            if(!_isAddMore){
                self.imageSmallPD7.hidden = YES;
                self.imageAdMorePD7.hidden = YES;
                self.btnAdMorePD7.hidden = NO;
                self.imageViewEmail.hidden = NO;
                
                CGRect frame = self.btnAdMorePD7.frame;
                frame.origin.y = self.imageViewEmail.frame.origin.y + self.imageViewEmail.frame.size.height + 15;
                self.btnAdMorePD7.frame = frame;
                
                frame = self.sendEmailPD7.frame;
                frame.origin.y = self.btnAdMorePD7.frame.origin.y + self.btnAdMorePD7.frame.size.height + 15;
                self.sendEmailPD7.frame = frame;
                
                CGSize size = _scrollViewEmail.contentSize;
                size.height = 715;
                self.scrollViewEmail.contentSize = size;
            }else{
                self.imageSmallPD7.hidden = NO;
                self.imageAdMorePD7.hidden = NO;
                self.btnAdMorePD7.hidden = YES;
                self.imageViewEmail.hidden =YES;
            }
            
            [self captureScreenAfterDistance];
            self.imageViewEmail.image = _imageCapture;
            self.imageSmallPD7.image = _imageCapture;
            [self saveImage:self.imageViewEmail.image];
            
            if ([self.emailTextFieldPD5.text length] > 0) {
                self.emailField.text = self.emailTextFieldPD5.text;
                self.lbRQEmail1.hidden = YES;
            }
            
            if ([self.nameTextFieldPD5.text length] > 0){
                self.nameFieldNew.text = self.nameTextFieldPD5.text;
                self.lbRQName1.hidden = YES;
            }
            
            if([self.phoneTextFieldPD5.text length] > 0){
                self.phoneField.text = self.phoneTextFieldPD5.text;
                self.lbRQPhone1.hidden = YES;
            }
            
            self.screen5.hidden = NO;
            self.btnNext2.hidden = YES;
            [self.labelDistanceNew setText:[NSString stringWithFormat:@"DIGITAL PD: %.2fMM",_originalDistance]];
            if([_clinicalWorkDistanceValue length] > 0){
                [self.labelClinicalWork setText:[NSString stringWithFormat:@"CLINICAL WORKING DISTANCE: %@",_clinicalWorkDistanceValue]];
            }else{
                [self.labelClinicalWork setText:[NSString stringWithFormat:@"CLINICAL WORKING DISTANCE: "]];
            }
        }
    }
    
    state ++;
    NSLog(@"STATE: %d",state);
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)updateDistance{
    self.labelDistanceValue.hidden = YES;
    _targetSize = 50.8f;
    
    if([self.textFieldInchOrCm.text isEqualToString:@"Inch"]){
        _targetSize = [self.textFieldValueReference.text floatValue]*25.4;
    }else{
        _targetSize = [self.textFieldValueReference.text floatValue]*10;
    }
    
    float f = (self.rightSightView.center.x - self.leftSightView.center.x)/2.0f;
    float newCenterX;
    
    CGRect frame = self.viewLine.frame;

    if(f >= 0){
        newCenterX = self.leftSightView.center.x + f;
        frame.size.width = f*2 - 30;
    }else{
        newCenterX = self.rightSightView.center.x - f;
        frame.size.width = -f*2 + 30;
    }
    
//    self.labelDistanceValue.center  = CGPointMake(newCenterX,self.leftSightView.center.y + self.leftSightView.frame.size.height/2);
    self.viewLine.frame = frame;
    self.viewLine.center = CGPointMake(newCenterX, self.leftSightView.center.y);
    
    CGPoint leftEyeCenter = self.leftSightView.center;
    CGPoint rightEyeCenter = self.rightSightView.center;
    
    //This finds the distance simply by comparing the x coordinates of the two pupils
    float complexDistance = fabsf(sqrtf(powf(leftEyeCenter.y - rightEyeCenter.y, 2) + powf(rightEyeCenter.x - leftEyeCenter.x, 2)));
    float distanceMM = [Helper convertPointToMM:complexDistance];
    
    float sizeCard = 0;
//    if (self.rightArrowView.center.x > self.leftArrowView.center.x) {
//        sizeCard = self.rightArrowView.center.x - self.leftArrowView.center.x;
//    }else{
//        sizeCard = self.leftArrowView.center.x - self.rightArrowView.center.x;
//    }
    
    CGPoint dotLeft = CGPointMake(self.dotViewLeft.frame.origin.x + self.leftArrowView.frame.origin.x, self.dotViewLeft.frame.origin.y + self.leftArrowView.frame.origin.y);
    CGPoint dotRight = CGPointMake(self.dotViewRight.frame.origin.x + self.rightArrowView.frame.origin.x, self.dotViewRight.frame.origin.y + self.rightArrowView.frame.origin.y);
    
    sizeCard = sqrtf(powf(dotLeft.x - dotRight.x,2) + powf(dotLeft.y - dotRight.y,2));

//    sizeCard = sqrtf(powf(self.rightArrowView.frame.origin.x - self.leftArrowView.frame.origin.x+self.leftArrowView.frame.size.width,2) + powf(self.rightArrowView.center.y - self.leftArrowView.center.y,2));
    
    sizeCard = [Helper convertPointToMM:sizeCard];
    
//    NSLog(@"ANGLE: %f",angle);
//    self.textFieldValueReference.text = [NSString stringWithFormat:@"%.2f",valueReferencingDistance];
    
    float OriginalDistance = 0;
    OriginalDistance = distanceMM*_targetSize/sizeCard;

    
    self.textFieldDistanceValue.text = [NSString stringWithFormat:@"Digital PD(mm) %.2f",OriginalDistance];
    _originalDistance = OriginalDistance;
}

- (IBAction)zoomActionSelected:(id)sender {
    // Get the location within the image view where we tapped
//    CGPoint pointInView = self.scrollView.center;
    
    // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    if(newZoomScale > 5.0f){
        newZoomScale = _saveZoomScale;
    }
    
    [self.scrollView setZoomScale:newZoomScale animated:YES];
    
//    // Figure out the rect we want to zoom to, then zoom to it
//    CGSize scrollViewSize = self.scrollView.bounds.size;
//    
//    CGFloat w = scrollViewSize.width / newZoomScale;
//    CGFloat h = scrollViewSize.height / newZoomScale;
//    CGFloat x = pointInView.x - (w / 2.0f);
//    CGFloat y = pointInView.y - (h / 2.0f);
//    
//    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
//    
//    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

- (IBAction)panRightSight:(id)sender {
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
    
    CGPoint translation = [recognizer translationInView:self.scrollView];
    self.rightSightView.center = CGPointMake(recognizer.view.center.x + translation.x,
                                      recognizer.view.center.y + translation.y);
    self.leftSightView.center = CGPointMake(self.leftSightView.center.x,
                                            self.rightSightView.center.y);
    [self updateDistance];
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.scrollView];
}

- (IBAction)panLeftArrow:(id)sender{
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
    
    CGPoint translation = [recognizer translationInView:self.scrollView];
    self.leftArrowView.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y + translation.y);
//    self.rightArrowView.center = CGPointMake(self.rightArrowView.center.x,self.leftArrowView.center.y);
    
    [self updateDistance];
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.scrollView];
}

- (IBAction)tapGesture:(id)sender {
//    if(!isStartDistance && state == 4){
//        //State start measuring
//        state = 5;
//        self.viewGuide.hidden = YES;
//        
//        _leftArrowView.hidden = NO;
//        _rightArrowView.hidden = NO;
//        _leftSightView.hidden = NO;
//        _rightSightView.hidden = NO;
//        _viewLine.hidden = NO;
//        _labelDistanceValue.hidden = NO;
//        self.scrollView.userInteractionEnabled = NO;
//        self.scrollView.scrollEnabled = NO;
//        [self updateDistance];
//    }
}

- (IBAction)panLeftSight:(id)sender{
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
    
    CGPoint translation = [recognizer translationInView:self.scrollView];
    self.leftSightView.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y + translation.y);
    self.rightSightView.center = CGPointMake(self.rightSightView.center.x, self.leftSightView.center.y);
    [self updateDistance];
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.scrollView];
}

- (void)captureScreenAfterDistance{
    // Attach an image to the email
    //Save image
    float saveScroll = _scrollView.zoomScale;
    
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView setZoomScale:1.0f];
    
    UIGraphicsBeginImageContextWithOptions(self.viewArea.bounds.size, self.viewArea.opaque, 0.0);
    [self.viewArea.layer renderInContext:UIGraphicsGetCurrentContext()];
    

//    UIImage* image = nil;
//    UIGraphicsBeginImageContext(_scrollView.contentSize);
//    {
//        CGPoint savedContentOffset = _scrollView.contentOffset;
//        CGRect savedFrame = _scrollView.frame;
//        
//        _scrollView.contentOffset = CGPointZero;
//        _scrollView.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
//        
//        [_scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        
//        _scrollView.contentOffset = savedContentOffset;
//        _scrollView.frame = savedFrame;
//    }
//    UIGraphicsEndImageContext();
//    _imageCapture = image;

    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _imageCapture = img;
    [_scrollView setZoomScale:saveScroll];
}

- (IBAction)panRightArrow:(id)sender{
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
    
    CGPoint translation = [recognizer translationInView:self.scrollView];
    self.rightArrowView.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y + translation.y);
//    self.leftArrowView.center = CGPointMake(self.leftArrowView.center.x, self.rightArrowView.center.y);
    [self updateDistance];
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.scrollView];
}

#pragma mark UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    switch (sender.tag) {
        case 10:
            self.lbRQName1.hidden = YES;
            
            if([self.emailField.text length] == 0){
                self.lbRQEmail1.hidden = NO;
            }
            if([self.phoneField.text length] == 0){
                self.lbRQPhone1.hidden = NO;
            }
            break;
        case 11:
            self.lbRQEmail1.hidden = YES;
            if([self.nameFieldNew.text length] == 0){
                self.lbRQName1.hidden = NO;
            }
            if([self.phoneField.text length] == 0){
                self.lbRQPhone1.hidden = NO;
            }
            break;
        case 12:
            self.lbRQPhone1.hidden = YES;
            if([self.emailField.text length] == 0){
                self.lbRQEmail1.hidden = NO;
            }
            if([self.nameFieldNew.text length] == 0){
                self.lbRQName1.hidden = NO;
            }
            break;
        case 13:
            self.lbREName2.hidden = YES;
            if([self.emailTextFieldPD5.text length] == 0){
                self.lbRQEmail2.hidden = NO;
            }
            if([self.phoneTextFieldPD5.text length] == 0){
                self.lbRQPhone2.hidden = NO;
            }
            break;
        case 14:
            self.lbRQEmail2.hidden = YES;
            if([self.nameTextFieldPD5.text length] == 0){
                self.lbREName2.hidden = NO;
            }
            if([self.phoneTextFieldPD5.text length] == 0){
                self.lbRQPhone2.hidden = NO;
            }
            break;
        case 15:
            self.lbRQPhone2.hidden = YES;
            if([self.emailTextFieldPD5.text length] == 0){
                self.lbRQEmail2.hidden = NO;
            }
            if([self.nameTextFieldPD5.text length] == 0){
                self.lbREName2.hidden = NO;
            }
            break;
            
        default:
            break;
    }
    
    if(!_isMoveView && (sender.tag >= 10) && sender.tag <= 15){
//        if(sender.tag <= 12){
//            _isMoveView = YES;
//            CGPoint viewCenter = CGPointMake(self.view.center.x, self.view.center.y/2);
//            if (viewCenter.y >= self.view.bounds.size.height/2) {
//                viewCenter.y = self.view.bounds.size.height/2;
//            }
//            
//            [UIView animateWithDuration:0.4f animations:^{
//                self.view.center = viewCenter;
//            }];
//        }
    }
    
    if(!_isMoveView && sender.tag == 4){
        _isMoveView = YES;
        [UIView animateWithDuration:0.5f animations:^{
            CGRect viewFrame = self.screenWD2.frame;
            viewFrame.origin.y -= (PICKER_HEIGHT);
            self.screenWD2.frame = viewFrame;
        }];
        
        [_pickerData removeAllObjects];
        [_pickerData addObjectsFromArray:_listValueWD];
        [_pickerView reloadAllComponents];
        _pickerValue = [_listValueWD objectAtIndex:0];
        _pickerTag = 4;

        [self showPickerView];
    }
    
    if(sender.tag == 2){
        _isMoveView = YES;
        
        [_pickerData removeAllObjects];
        [_pickerData addObjectsFromArray:_listValueIPD];
        [_pickerView reloadAllComponents];
        _pickerValue = [_listValueIPD objectAtIndex:0];
        _pickerTag = 2;

        [self showPickerView];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(_isMoveView && textField.tag >= 10){
        CGPoint viewCenter = CGPointMake(self.view.center.x, [Helper getScreenSize].size.height/2);
        [UIView animateWithDuration:0.4f animations:^{
            self.view.center = viewCenter;
        }];
        _isMoveView = NO;
    }
    
    if([textField.text length] == 0){
        switch (textField.tag) {
            case 10:
                self.lbRQName1.hidden = NO;
                break;
            case 11:
                self.lbRQEmail1.hidden = NO;
                break;
            case 12:
                self.lbRQPhone1.hidden = NO;
                break;
            case 13:
                self.lbREName2.hidden = NO;
                break;
            case 14:
                self.lbRQEmail2.hidden = NO;
                break;
            case 15:
                self.lbRQPhone2.hidden = NO;
                break;
                
            default:
                break;
        }
    }
    
    if(textField.tag == 3){
        [self updateDistance];
    }
    
    [self.view endEditing:YES];
    [textField resignFirstResponder];

    return YES;
}

#pragma mark textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if(state == 5){
        [self.scrollScreenPD5 setContentOffset:CGPointMake(0,100) animated:YES];
    }else{
        [self.scrollViewEmail setContentOffset:CGPointMake(0,100) animated:YES];
    }
    
//    if(!_isMoveView){
//        _isMoveView = YES;
//        [UIView animateWithDuration:0.5f animations:^{
//            CGRect viewFrame = self.view.frame;
//            viewFrame.origin.y -= 44;
//            self.view.frame = viewFrame;
//        }];
//    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self.view endEditing:YES];
        if(textView == self.textView){
            self.textViewPD7.text = self.textView.text;
        }
//        else{
//            self.textView.text = self.textViewPD7.text;
//        }
        
        self.textViewPD7.scrollsToTop = YES;
        self.textView.scrollsToTop = YES;
        
//        if(_isMoveView){
//            CGPoint viewCenter = CGPointMake(self.view.center.x, [Helper getScreenSize].size.height/2);
//            [UIView animateWithDuration:0.5f animations:^{
//                self.view.center = viewCenter;
//            }];
//            _isMoveView = NO;
//        }
        
        return NO;
    }
    return YES;
}

- (IBAction)email:(id)sender {
    [self sendInfo];
}

- (IBAction)backToMainMenu:(id)sender {
    _typeFlowView = 0;
    
    self.resetButton.hidden = YES;
    self.btnBack.hidden = NO;
    self.btnNext2.hidden = YES;
    self.screen1.hidden = NO;
    self.screen2.hidden = YES;
    self.screen3.hidden = YES;
    self.screenWelcome.hidden = YES;
    self.screenThanks.hidden = YES;
//    self.viewControlImage.hidden = YES;
    state = 1;
}

- (IBAction)openVideoClinicalWork:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"used" forKey:@"case1"];
    [defaults synchronize];
    
    [self checkCaseUsed];

    _isUseWDVideo = YES;
    _typeFlowView = 0;
    _isFlowWithVideo = YES;
    state = 2;
    
    self.btnBack.hidden = NO;
    self.resetButton.hidden = YES;
    self.screenWelcome.hidden = YES;
    self.btnNext2.hidden = NO;
    self.screen1.hidden = YES;
    self.screen2.hidden = YES;
    self.screen3.hidden = YES;
    self.screenPlayVideo.hidden = NO;
//    self.viewControlImage.hidden = NO;
    [self playVideo:1];
}

- (IBAction)startClinicalWork:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"used" forKey:@"case2"];
    [defaults synchronize];
    [self checkCaseUsed];

    _isUseWD = YES;
    _typeFlowView = 0;
    _isFlowWithVideo = NO;
    
//    self.viewControlImage.hidden = NO;
    self.btnNext2.hidden = NO;
    self.resetButton.hidden = YES;
    self.screenWelcome.hidden = YES;
    self.screen1.hidden = YES;
    self.screenWD1.hidden = NO;
    self.screenWD2.hidden = YES;
    state = 2;
}

- (IBAction)openVideoIPD:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"used" forKey:@"case3"];
    [defaults synchronize];
    [self checkCaseUsed];

    
    _isUseIPDVideo = YES;
    _typeFlowView = 1;
    _isFlowWithVideo = YES;
    state = 2;

//    self.viewControlImage.hidden = NO;
    self.btnBack.hidden = NO;
    self.resetButton.hidden = YES;
    self.screenWelcome.hidden = YES;
    self.btnNext2.hidden = NO;
    self.screen1.hidden = YES;
    self.screen2.hidden = YES;
    self.screen3.hidden = YES;
    self.screenPlayVideo.hidden = NO;
    [self playVideo:1];
}

- (IBAction)startIPD:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"used" forKey:@"case4"];
    [defaults synchronize];
    [self checkCaseUsed];

    
    _isUseIPD = YES;
    _typeFlowView = 1;
    _isFlowWithVideo = NO;
    
//    self.viewControlImage.hidden = NO;
    self.btnNext2.hidden = NO;
    self.resetButton.hidden = YES;
    self.screenWelcome.hidden = YES;
    self.screen1.hidden = YES;
    self.screen2.hidden = NO;
    self.screen3.hidden = YES;
    state = 2;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            self.btnBack.hidden = YES;
            self.screen1.hidden = YES;
            self.screen2.hidden = YES;
            self.screen3.hidden = YES;
            self.screenWelcome.hidden = YES;
            self.screen5.hidden = YES;
            self.imageSelected.image = nil;
            self.screenThanks.hidden = NO;
            state = 0;
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetAllCase:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"case1"];
    [defaults removeObjectForKey:@"case2"];
    [defaults removeObjectForKey:@"case3"];
    [defaults removeObjectForKey:@"case4"];
    [defaults removeObjectForKey:@"nameUser"];
    [defaults removeObjectForKey:@"emailUser"];
    [defaults removeObjectForKey:@"phoneUser"];
    [defaults synchronize];
    
    _clinicalWorkDistanceValue = @"Measure and select";
    self.textFieldWD.text = _clinicalWorkDistanceValue;
    [self.labelClinicalDistancePD5 setText:[NSString stringWithFormat:@"CLINICAL WORKING DISTANCE: %@",_clinicalWorkDistanceValue]];
    [self.labelClinicalWork setText:[NSString stringWithFormat:@"CLINICAL WORKING DISTANCE: %@",_clinicalWorkDistanceValue]];

    self.textView.text = @"";
    self.textViewPD7.text = @"";
    _imagePD5.image = nil;
    _imageSelected.image = nil;
    _imageSmallPD5.image = nil;
    _imageSmallPD7.image = nil;
    _imageViewEmail.image = nil;
    _isAddMore = NO;
    
    [self checkCaseUsed];
    [self checkUserInfo];
}
- (IBAction)changeClinicalValue:(id)sender {
    _isMoveView = YES;
    [_pickerData removeAllObjects];
    [_pickerData addObjectsFromArray:_listValueWD];
    [_pickerView reloadAllComponents];
    _pickerValue = [_listValueWD objectAtIndex:0];
    _pickerTag = 4;
    
    [self showPickerView];
}

- (IBAction)longPressSelected:(id)sender {
    NSLog(@"Press next");
    if (((UILongPressGestureRecognizer*)sender).state == UIGestureRecognizerStateBegan){
        _longPressGesture.enabled = NO;
        [self nextSelected:nil];
    }
}

- (IBAction)addMorePhotoSelected:(id)sender {
    _isAddMore = YES;
    [self showcamera];
}

- (void)saveImage:(UIImage*) img{
    // Manage tasks in background thread
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // The completion block to be executed after image taking action process done
//        void (^completion)(NSURL *, NSError *) = ^(NSURL *assetURL, NSError *error) {
//            if (error) {
//                NSLog(@"%s: Write the image data to the assets library (camera roll): %@",
//                      __PRETTY_FUNCTION__, [error localizedDescription]);
//            }
//            
//            NSLog(@"%s: Save image with asset url %@ (absolute path: %@), type: %@", __PRETTY_FUNCTION__,
//                  assetURL, [assetURL absoluteString], [assetURL class]);
//        };
//        
//        void (^failure)(NSError *) = ^(NSError *error) {
//            if (error) NSLog(@"%s: Failed to add the asset to the custom photo album: %@",__PRETTY_FUNCTION__, [error localizedDescription]);
//        };
//        
//        // Save image to custom photo album
//        // The lifetimes of objects you get back from a library instance are tied to
//        //   the lifetime of the library instance.
//        [self.assetsLibrary saveImage:img
//                              toAlbum:@"Loupes PD"
//                           completion:completion
//                              failure:failure];
//    });
}

- (id)uploadImage:(NSString *)userName andMail:(NSString *)email andPhone:(NSString*)phone andClinical:(NSString*)clinical andDistance:(NSString*)distance andNote:(NSString*)note andFileName:(NSString*)fileName andPathImage:(NSData*)image{
    
    
    NSString * pathUpload = @"http://loupesdata.com/index.php";
    if ([userName length] <= 0) {
        userName = @"UserName";
    }
    if([email length] <= 0){
        email = @"testmail@gmail.com";
    }
    if([phone length] <= 0){
        phone = @"1234567890";
    }
    
    if([note length] <= 0){
        note = @" ";
    }
    
    if([clinical isEqualToString:@"Measure and select"]){
        clinical = @"Not Select Measure";
    }
    
    NSDictionary *dicPath;
    
    if(self.imageAddMore.image != nil){
        UIImage *scaleImage = [self.imageAddMore.image resizedImage:CGSizeMake(self.imageAddMore.image.size.width/(self.imageAddMore.image.size.height/2500), 2500) interpolationQuality:kCGInterpolationDefault];
        
        NSData *dataCard = UIImageJPEGRepresentation(scaleImage, 0.77f);
        dicPath = [[NSDictionary alloc] initWithObjectsAndKeys:
                   image,@"uploaded_file",dataCard,@"uploadedfile2", nil];
    }else{
        dicPath = [[NSDictionary alloc] initWithObjectsAndKeys:
                   image,@"uploaded_file", nil];
    }
    NSDictionary *user = [[NSDictionary alloc] initWithObjectsAndKeys:userName,@"name",email,@"mail",phone,@"phone",clinical,@"clinical",distance,@"distance",note,@"note", fileName,@"filenameimage", nil];
    
    id obj = [NWRequestController postJSONSynchronizedWithUrl:pathUpload params:user files:dicPath];
    
    return obj;
}


- (IBAction)call:(id)sender {
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:@"(775)8294488"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
@end
