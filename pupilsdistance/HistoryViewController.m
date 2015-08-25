//
//  HistoryViewController.m
//  PupilsDistance
//
//  Created by duongtv on 2/25/15.
//  Copyright (c) 2015 Trinh Van Duong. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "Helper.h"
#import "DetailHistoryViewController.h"

@interface HistoryViewController (){
    
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame;
    frame = self.scrollViewHelp.frame;
    frame.origin.y = self.navigationBar.frame.size.height + 20;
    frame.size.height = [Helper getScreenSize].size.height - self.navigationBar.frame.size.height - 20;
    CGSize size = self.scrollViewHelp.frame.size;
    size.height = 2810.0f;
    self.scrollViewHelp.contentSize = size;
    self.scrollViewHelp.frame = frame;
    [self.view addSubview:self.scrollViewHelp];
    self.scrollViewHelp.hidden = YES;
    
    frame = self.imageHelp.frame;
    frame.size = size;
    self.imageHelp.frame = frame;
    
    frame = self.tableView.frame;
    frame.origin.y = self.navigationBar.frame.size.height;
    frame.size.height = [Helper getScreenSize].size.height - self.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height;
    self.tableView.frame = frame;
    
    self.btnBack.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    _fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    _imageList = [[NSMutableArray alloc] init];
    
    for(int i = 0;i<_fileArray.count;i++)
    {
        id arrayElement = [_fileArray  objectAtIndex:i];
        if ([arrayElement rangeOfString:@".png"].location !=NSNotFound)
        {
            [_imageList addObject:arrayElement];
            _arrayImages = [[NSMutableArray alloc]initWithArray:_imageList copyItems:TRUE];
        }
    }
    NSLog(@"COUNT: %d",_imageList.count);
    [_tableView reloadData];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _imageList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailHistoryViewController *detail = [[DetailHistoryViewController alloc] initWithFileName:[_imageList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"HistoryTableViewCell";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSString *str = [[_imageList objectAtIndex:indexPath.row] substringToIndex:[[_imageList objectAtIndex:indexPath.row] length] - 4];
    
    cell.nameUser.text = str;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[_imageList objectAtIndex:indexPath.row]];
    NSDictionary *filePathsArray1 = [[NSFileManager defaultManager] attributesOfItemAtPath:getImagePath error:nil];
    
    NSDate *modifiedDate = [filePathsArray1 objectForKey:NSFileModificationDate];
    NSLog(@"\n Modified Day : %@", modifiedDate);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *theDate = [dateFormat stringFromDate:modifiedDate];
    cell.timeCreate.text = theDate;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *deleteIndexPaths = [[NSArray alloc] initWithObjects:indexPath,nil];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView beginUpdates];
        [self removeImage:[_imageList objectAtIndex:indexPath.row]];
        [_imageList removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [self.tableView reloadData];
    }
}

- (void)removeImage:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"Remove success");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
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

- (IBAction)backSelected:(id)sender {
    self.btnBack.hidden = YES;
    self.btnHelp.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.scrollViewHelp.hidden = YES;
}
- (IBAction)helpSelected:(id)sender {
    self.btnBack.hidden = NO;
    self.btnHelp.hidden = YES;
    self.scrollViewHelp.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
@end
