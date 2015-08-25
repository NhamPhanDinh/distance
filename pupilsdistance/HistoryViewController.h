//
//  HistoryViewController.h
//  PupilsDistance
//
//  Created by duongtv on 2/25/15.
//  Copyright (c) 2015 Trinh Van Duong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *_arrayImages, *_imageList;
    NSArray *_fileArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewHelp;
@property (weak, nonatomic) IBOutlet UIImageView *imageHelp;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnHelp;
@property (weak, nonatomic) IBOutlet UIView *navigationBar;

- (IBAction)backSelected:(id)sender;
- (IBAction)helpSelected:(id)sender;
@end
