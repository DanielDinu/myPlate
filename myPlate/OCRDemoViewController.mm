

#import "OCRDemoViewController.h"
#import "baseapi.h"
#include <math.h>
#import "OverlayView.h"
static inline double radians (double degrees) {return degrees * M_PI/180;}

@implementation OCRDemoViewController

@synthesize scanTextfield,iv;

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.scanTextfield resignFirstResponder];
    return NO;
    
}

- (IBAction)sendScan:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:scanTextfield.text forKey:@"regNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *post2=[NSString stringWithFormat:@"search=registration&registration=%@",scanTextfield.text];
    NSLog(@"post string is :%@",post2);
    NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
    
    NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
    [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/search.php"]];
    [cerere2 setHTTPMethod:@"POST"];
    [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
    [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere2 setHTTPBody:postData2];
    NSURLResponse* response2 = nil;
    NSError* error2=nil;
    NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
    NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is : %@",replyString2);
    
    NSArray *date_user = [replyString2 componentsSeparatedByString:@"*~*"];
   
    if([[date_user objectAtIndex:0] isEqualToString:@"ERR"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                        message:@"Registration number not found !"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
         [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:4] forKey:@"useridFriend"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendView"];
        [self.navigationController pushViewController: myController animated:YES];
    }
    
    
    
}

-(IBAction) editingChanged:(UITextField*)sender
{
    
    if (sender == scanTextfield )
    {
        
        // allow only alphanumeric chars
        NSString* newStr = sender.text;
        
        if ([newStr length] < [sender.text length])
        {
            sender.text = newStr;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                            message:@"Registration number must be alphanumerical !"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location >= 10)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                        message:@"Registration number must be 10 characters max!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
        
    }
    return YES;
    
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    // Step 1: Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    theScrollView.contentInset = contentInsets;
    theScrollView.scrollIndicatorInsets = contentInsets;
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    
    CGPoint scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y - (keyboardSize.height-70));
    [theScrollView setContentOffset:scrollPoint animated:YES];
    
}
- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    theScrollView.contentInset = contentInsets;
    theScrollView.scrollIndicatorInsets = contentInsets;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self->activeTextField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    self->activeTextField = nil;
}
- (IBAction)dismissKeyboard:(id)sender
{
    [activeTextField resignFirstResponder];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        

    }
    return self;
}


- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
	
	
}

- (void)viewDidLoad {
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
	[super viewDidLoad];
  [self startTesseract];
	
}


- (void)dealloc {
	
}

#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412


#define SCREEN_WIDTH  640
#define SCREEN_HEIGTH 960

#pragma mark -
#pragma mark IBAction



- (IBAction) takePhoto:(id) sender
{
    
	imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
	
	
    
            // ensure that our custom view's frame fits within the parent frame
    UIImage *image = [UIImage imageNamed:@"overlay.png"] ;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image] ;
    //imgView.bounds = CGRectMake(100,100, 128, -128) ;
    imgView.frame = CGRectMake(-115, -100, 550, 690);

  imagePickerController.cameraOverlayView = imgView;
    
    [self presentModalViewController:imagePickerController animated:YES];
  
  /*
    //
    imagePickerController.showsCameraControls = NO; //This line allows overlay to show but move and scale doesn't work
   imagePickerController.allowsEditing = YES;
    //[self.view setUserInteractionEnabled:NO];
    
    if ([[imagePickerController.cameraOverlayView subviews] count] == 0)
    {
        // setup our custom overlay view for the camera
        //
        // ensure that our custom view's frame fits within the parent frame
        CGRect overlayViewFrame = imagePickerController.cameraOverlayView.frame;
        CGRect newFrame = CGRectMake(0.0,
                                     CGRectGetHeight(overlayViewFrame) -
                                     self.view.frame.size.height - 10.0,
                                     CGRectGetWidth(overlayViewFrame),
                                     self.view.frame.size.height + 10.0);
        self.view.frame = newFrame;
        imagePickerController.cameraOverlayView = self.view;
    }*/
}

#pragma mark -
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"shouldAutorotate called");
    return YES;
}
- (NSString *) applicationDocumentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	return documentsDirectoryPath;
}

#pragma mark -
#pragma mark Image Processsing
- (void) startTesseract
{
	
	NSString *dataPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"tessdata"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:dataPath]) {
		
		NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
		NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
		if (tessdataPath) {
			[fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
		}
	}
	
	NSString *dataPathWithSlash = [[self applicationDocumentsDirectory] stringByAppendingString:@"/"];
	setenv("TESSDATA_PREFIX", [dataPathWithSlash UTF8String], 1);
	
	// init the tesseract engine.
	tess = new TessBaseAPI();
	
	tess->SimpleInit([dataPath cStringUsingEncoding:NSUTF8StringEncoding],  
					 "eng",  // ISO 639-3 string or NULL.
					 false);
	
	
}

- (NSString *) ocrImage: (UIImage *) uiImage
{
	
    
    CGSize imageSize = [uiImage size];
    double bytes_per_line	= CGImageGetBytesPerRow([uiImage CGImage]);
    double bytes_per_pixel	= CGImageGetBitsPerPixel([uiImage CGImage]) / 8.0;
    
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider([uiImage CGImage]));
    const UInt8 *imageData = CFDataGetBytePtr(data);
    
    // this could take a while. maybe needs to happen asynchronously.
    char* text = tess->TesseractRect(imageData,(int)bytes_per_pixel,(int)bytes_per_line, 0, 0,(int) imageSize.height,(int) imageSize.width);
    
    // Do something useful with the text!
    // NSLog(@"Converted text: %@",[NSString stringWithCString:text encoding:NSUTF8StringEncoding]);
    
    return [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
}


-(UIImage *)resizeImage:(UIImage *)image {
    
    CGImageRef imageRef = [image CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    
    if (alphaInfo == kCGImageAlphaNone)
        alphaInfo = kCGImageAlphaNoneSkipLast;
    
    int width, height;
    
    width = 640;//[image size].width;
    height = 640;//[image size].height;
    
    CGContextRef bitmap;
    
    if (image.imageOrientation == UIImageOrientationUp | image.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
        
    }
    
    if (image.imageOrientation == UIImageOrientationLeft) {
        NSLog(@"image orientation left");
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -height);
        
    } else if (image.imageOrientation == UIImageOrientationRight) {
        NSLog(@"image orientation right");
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -width, 0);
        
    } else if (image.imageOrientation == UIImageOrientationUp) {
        NSLog(@"image orientation up");
        
    } else if (image.imageOrientation == UIImageOrientationDown) {
        NSLog(@"image orientation down");
        CGContextTranslateCTM (bitmap, width,height);
        CGContextRotateCTM (bitmap, radians(-180.));
        
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}

- (UIImage *)cropImage:(UIImage *)oldImage {
    CGSize imageSize = oldImage.size;
    UIGraphicsBeginImageContextWithOptions( CGSizeMake( imageSize.width ,
                                                       imageSize.height - 200),
                                           NO,
                                           0.);
    [oldImage drawAtPoint:CGPointMake( 0, -400)
                blendMode:kCGBlendModeCopy
                    alpha:1.];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker 
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
	
	//se inchide view-ul si se arata imaginea
	 
	[picker dismissModalViewControllerAnimated:YES];
	UIImage *newImage = [self resizeImage:image];
	
    CGSize size = [image size];
    CGRect rect = CGRectMake(size.width/1.5 , size.height /20 ,
                             (size.width/4 ), (size.height ));
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    img = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationRight];
    iv.image = img;
    
    NSString *text = [self ocrImage:img];
    scanTextfield.text = text;

    

    /*
    CGSize size = [image size];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	CGRect rect = CGRectMake(size.width / 4, size.height / 4 ,
                             (size.width / 2), (size.height / 2));
    
    // se cropuieste,etc
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    // se arata imaginea noua
    imageView = [[UIImageView alloc] initWithImage:img];
    [imageView setFrame:CGRectMake(0, 200, (size.width / 2), (size.height / 2))];
    [[self view] addSubview:imageView];
    [imageView release];*/
}

@end
