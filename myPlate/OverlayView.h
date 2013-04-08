//
//  OverlayView.h
//  CameraOverlay
//
//  Created by Andreas Katzian on 12.05.10.
//  Copyright 2010 Blackwhale GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OverlayView : UIView {
    UIButton *buttonInapoi;
}
@property (nonatomic, retain) IBOutlet UIButton *buttonInapoi;

- (IBAction)buttonInapoiApasat;
@end
