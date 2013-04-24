#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"

@interface AROverlayViewController : UIViewController {
    
}
@property(nonatomic, retain) IBOutlet UIView *vImagePreview;
@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;
- (IBAction)captureNow:(id)sender;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@end
