//
//  OCRDemoViewController.h
//  OCRDemo
//
//  Created by Nolan Brown on 12/30/09.

//

#import <UIKit/UIKit.h>
#import "baseapi.h"

@interface OCRDemoViewController : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	UIImagePickerController *imagePickerController;
	TessBaseAPI *tess;
	
    IBOutlet UIScrollView *theScrollView;
    UITextField *activeTextField;

    UIImageView *iv;
	
}
@property (nonatomic, retain) IBOutlet UIImageView *iv;


- (IBAction)dismissKeyboard:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *scanTextfield;

@property (weak, nonatomic) IBOutlet UIButton *sendScan;
- (IBAction)sendScan:(id)sender;

-(IBAction) editingChanged:(UITextField*)sender;

- (IBAction) takePhoto:(id) sender;

- (void) startTesseract;
- (NSString *) applicationDocumentsDirectory;
- (NSString *) ocrImage: (UIImage *) uiImage;
-(UIImage *)resizeImage:(UIImage *)image;

@end

