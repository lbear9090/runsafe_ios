//
//  FeedVideoView.m
//  UpDown
//
//  Created by RANJIT MAHTO on 11/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "FeedPhotoView.h"
@implementation FeedPhotoView
{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    self.closeButtton.layer.cornerRadius = 15;
    self.closeButtton.clipsToBounds = YES;
    
    [self showFeedPhoto];
}

-(void) showFeedPhoto
{
    
//    if([GlobalAppDel.selUserID isEqualToString:[EasyDev getUserDetailForKey:@"user_id"]] || [self.selFeedDict[@"uploaded_id"] isEqualToString:[EasyDev getUserDetailForKey:@"user_id"]])
//    {
//        
//        if([self.viewOpenBy isEqualToString:@"PROFILE"])
//        {
//            self.deleteButtton.hidden = NO;
//        }
//        else
//        {
//            self.deleteButtton.hidden = YES;
//        }
//    }
//    else
//    {
        self.deleteButtton.hidden = YES;
    //}
    
   // NSLog(@"FEEEEEEED DICT : %@",self.selFeedDict);
    
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//
//    self.photoView.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.photoView.layer.borderWidth = 1;
//
//    NSURL *imageUrl = [NSURL URLWithString: self.feedPhotoUrl];
//
//    [self.photoImageView sd_setImageWithURL:imageUrl
//                           placeholderImage:[UIImage imageNamed:@"logo"]
//                                    options:SDWebImageRefreshCached];

    
//    dispatch_async(queue, ^{
//        
//        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            
//            
//        });
//    });

}


-(IBAction)closeView:(id)sender
{
    [self.delegate closeFeedPhotoViewer];
}

-(IBAction)deleteFeed:(id)sender
{
//    [EasyDev showProcessViewWithText:@"Deleting Feeds..." andBgAlpha:0.9];
//    
//    NSString *webApiName = [NSString stringWithFormat:@"%@", @"deletefeed.php"];
//    
//    NSDictionary *feedLikeDict = self.selFeedDict;
//    
//    feedLikeDict = @{ @"user_id":[EasyDev getUserDetailForKey:@"user_id"], @"feed_id":self.selFeedDict[@"feed_id"]};
//
//    [RZNewWebService callPostWebServiceForApi:webApiName
//                              withRequestDict:feedLikeDict
//                                 successBlock:^(NSDictionary *response){
//                                     
//                                     NSLog(@"Response SignUp : %@",response);
//                                     
//                                     NSDictionary *userDataDict = response[@"userData"];
//                                     
//                                     if([userDataDict[@"status"] isEqual: @"success"])
//                                     {
//                                         [self.delegate closeFeedPhotoViewerAfterDeleteFeed];
//                                         
//                                         [EasyDev hideProcessView];
//                                     }
//                                     else
//                                     {
//                                         [EasyDev showAlert:@"Error" message:@"Error in deleting, please try again"];
//                                     }
//                                     
//                                 }
//                             serverErrorBlock:^(NSError *error)
//     {
//         NSLog(@"Response Server Error : %@",error.description);
//         [EasyDev hideProcessView];
//     }
//                            networkErrorBlock:^(NSString *netError)
//     {
//         NSLog(@"Response Network Error : %@",netError);
//         [EasyDev hideProcessView];
//     }];
}

@end
