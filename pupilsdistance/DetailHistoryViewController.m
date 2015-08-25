//
//  DetailHistoryViewController.m
//  PupilsDistance
//
//  Created by Trinh Van Duong on 2/28/15.
//  Copyright (c) 2015 Trinh Van Duong. All rights reserved.
//

#import "DetailHistoryViewController.h"
#import "Helper.h"

@interface DetailHistoryViewController ()

@end

@implementation DetailHistoryViewController

- (id)initWithFileName:(NSString *)imageName{
    self = [super initWithNibName:@"DetailHistoryViewController" bundle:nil];
    if (self) {
        // Custom initialization
        _imageName = imageName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect frame = self.imageView.frame;
    
    frame.size.height = [Helper getScreenSize].size.height - 20 - self.tabBarController.tabBar.frame.size.height - self.viewController.frame.size.height- self.viewNavBar.frame.size.height;
    frame.origin.y = 20 + self.viewNavBar.frame.size.height;
    self.imageView.frame = frame;
    
    frame = self.viewController.frame;
    frame.origin.y = [Helper getScreenSize].size.height - self.tabBarController.tabBar.frame.size.height - self.viewController.frame.size.height;
    self.viewController.frame = frame;
    [self.viewController setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:_imageName];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    self.imageView.image = img;
    
    NSString *str = [_imageName substringToIndex:[_imageName length] - 4];
    _labelName.text = str;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _pupilsDistance = [defaults floatForKey:_labelName.text];
    NSLog(@"DISTANCE: %f",_pupilsDistance);
    
    frame = self.scrollViewHelp.frame;
    frame.origin.y = self.viewNavBar.frame.size.height + 20;
    frame.size.height = [Helper getScreenSize].size.height - self.viewNavBar.frame.size.height - 20;
    CGSize size = self.scrollViewHelp.frame.size;
    size.height = 2810.0f;
    self.scrollViewHelp.contentSize = size;
    self.scrollViewHelp.frame = frame;
    [self.view addSubview:self.scrollViewHelp];
    self.scrollViewHelp.hidden = YES;
    
    frame = self.imageHelp.frame;
    frame.size = size;
    self.imageHelp.frame = frame;
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

- (IBAction)emailImage:(id)sender {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Pupil Meter"];
    
    // Set up recipients
    // NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    // NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    // [picker setToRecipients:toRecipients];
    // [picker setCcRecipients:ccRecipients];
    // [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    UIImage *coolImage = _imageView.image;
    NSData *myData = UIImagePNGRepresentation(coolImage);
    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"coolImage.png"];
    
    // Fill out the email body text
    NSString *emailBody = [NSString stringWithFormat:@"PD: %.3fmm\n\nMeasurements sent from Pupils Distance for iPhone",_pupilsDistance];
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)saveImageToLibrary:(id)sender {
    UIImageWriteToSavedPhotosAlbum(_imageView.image, nil, nil, nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Saved" message:@"Image successfully saved to photo library." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (IBAction)helpSelected:(id)sender {
    self.btnBack.hidden = NO;
    self.btnHelp.hidden = YES;
    self.scrollViewHelp.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (IBAction)backSelected:(id)sender {
    if(![self.scrollViewHelp isHidden]){
        self.btnHelp.hidden = NO;
        self.tabBarController.tabBar.hidden = NO;
        self.scrollViewHelp.hidden = YES;
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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

@end
