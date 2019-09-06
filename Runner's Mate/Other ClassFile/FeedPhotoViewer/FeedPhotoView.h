//
//  FeedVideoView.h
//  UpDown
//
//  Created by RANJIT MAHTO on 11/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedPhotoViewDelegate <NSObject>
-(void) closeFeedPhotoViewer;
-(void) closeFeedPhotoViewerAfterDeleteFeed;
@end

@interface FeedPhotoView : UIView

@property (nonatomic, weak) IBOutlet UIButton *closeButtton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButtton;

@property (nonatomic, weak) IBOutlet UIView *photoView;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) NSString *feedPhotoUrl;

-(IBAction)closeView:(id)sender;

@property id <FeedPhotoViewDelegate> delegate;

@end
