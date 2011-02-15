/* 
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "NativeCalAppDelegate.h"
#import "EventKitDataSource.h"
#import "Kal.h"

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@implementation NativeCalAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
  /*
   *    Kal Initialization
   *
   * When the calendar is first displayed to the user, Kal will automatically select today's date.
   * If your application requires an arbitrary starting date, use -[KalViewController initWithSelectedDate:]
   * instead of -[KalViewController init].
   */
  kal = [[KalViewController alloc] init];
  kal.title = @"NativeCal";

  /*
   *    Kal Configuration
   *
   */
  kal.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)] autorelease];
  kal.delegate = self;
  dataSource = [[EventKitDataSource alloc] init];
  kal.dataSource = dataSource;
  [kal reloadData];

  // Setup the navigation stack and display it.
  navController = [[UINavigationController alloc] initWithRootViewController:kal];
  [window addSubview:navController.view];
  [window makeKeyAndVisible];
  
  /**
   *    Append
   */
  kal.selectTileAfterCalendarSlid = NO;
  kal.numberOfAppending = 1;
  
  UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height-40, [UIScreen mainScreen].bounds.size.width, 40)];
  UIBarButtonItem *sp  = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
  UIBarButtonItem *plus  = [[[UIBarButtonItem alloc] initWithTitle:@" + " style:UIBarButtonItemStyleBordered target:self action:@selector(addDate)] autorelease];
  UIBarButtonItem *minus = [[[UIBarButtonItem alloc] initWithTitle:@" - " style:UIBarButtonItemStyleBordered target:self action:@selector(minusDate)] autorelease];
  [toolbar setItems:[NSArray arrayWithObjects:sp,minus,plus,nil]];
  nights = [[UILabel alloc] init];
  nights.text = [NSString stringWithFormat:@"%d nights", kal.numberOfAppending];
  nights.center = CGPointMake(toolbar.center.x, toolbar.bounds.size.height/4);
  nights.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
  [nights sizeToFit];
  [toolbar addSubview:nights];
  [window addSubview:toolbar];
}

// Action handler for the navigation bar's right bar button item.
- (void)showAndSelectToday
{
  [kal showAndSelectDate:[NSDate date]];
}

- (void)addDate {
  if (kal.numberOfAppending < 9) {
    kal.numberOfAppending += 1;
    nights.text = [NSString stringWithFormat:@"%d nights", kal.numberOfAppending];
  }
}
- (void)minusDate {
  if (0 < kal.numberOfAppending) {
    kal.numberOfAppending -= 1;
    nights.text = [NSString stringWithFormat:@"%d nights", kal.numberOfAppending];
  }
}

#pragma mark UITableViewDelegate protocol conformance

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Display a details screen for the selected event/row.
  EKEventViewController *vc = [[[EKEventViewController alloc] init] autorelease];
  vc.event = [dataSource eventAtIndexPath:indexPath];
  vc.allowsEditing = NO;
  [navController pushViewController:vc animated:YES];
}

#pragma mark -

- (void)dealloc
{
  [kal release];
  [dataSource release];
  [window release];
  [navController release];
  [super dealloc];
}

@end
