//
//  MainViewController.m
//  PupilsDistance
//
//  Created by Trinh Van Duong on 2/12/15.
//  Copyright (c) 2015 Trinh Van Duong. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    self.recLeft.layer.borderWidth = 1.0f;
    self.recRight.layer.borderWidth = 1.0f;
    self.recLeft.layer.borderColor = [[UIColor redColor] CGColor];
    self.recRight.layer.borderColor = [[UIColor redColor] CGColor];
    
    _rectCard = [[ViewRectCard alloc] initWithFrame:CGRectMake(100, 240, 150, 50)];
    _rectCard.layer.borderColor = [[UIColor greenColor] CGColor];
    _rectCard.layer.borderWidth = 1.0f;
    _rectCard.backgroundColor = [self.recLeft backgroundColor];
    CGPoint point = _rectCard.center;
    point.x = self.view.center.x;
    _rectCard.center  = point;
    [self.view addSubview:_rectCard];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles: nil];
        [myAlertView show];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)panLeftRect:(id)sender {
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
    
    CGPoint translation = [recognizer translationInView:self.view];
    self.recLeft.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (IBAction)panRighRect:(id)sender {
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
    
    CGPoint translation = [recognizer translationInView:self.view];
    self.recRight.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (IBAction)distancePupils:(id)sender {
    NSLog(@"SIZE CARD: %f",self.rectCard.frame.size.width);
    NSLog(@"PERCENT: %f",self.rectCard.frame.size.width/WIDTH_CARD);
    
    CGPoint leftEyeCenter = self.recLeft.center;
    CGPoint rightEyeCenter = self.recRight.center;
    
    float simpleDistance = rightEyeCenter.x - leftEyeCenter.x;
    //This finds the distance simply by comparing the x coordinates of the two pupils
    
    float complexDistance = fabsf(sqrtf(powf(leftEyeCenter.y - rightEyeCenter.y, 2) + powf(rightEyeCenter.x - leftEyeCenter.x, 2)));
    
    NSLog(@"DISTANCE: %f - %f",simpleDistance,complexDistance);

    float distanceMM = complexDistance*10/47;
    NSLog(@"DISTANCE MM: %f",distanceMM);
    NSLog(@"DISTANCE PUPIL: %f",distanceMM*(WIDTH_CARD*47)/(self.rectCard.frame.size.width*10));
    
    float OriginalDistance = distanceMM*(WIDTH_CARD*47)/(self.rectCard.frame.size.width*10);
    [((UIButton*)sender) setTitle:[NSString stringWithFormat:@"%.3f mm",OriginalDistance] forState:UIControlStateNormal];
}

- (IBAction)takeAPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
