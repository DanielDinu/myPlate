
#import "OverlayView.h"


@implementation OverlayView
@synthesize buttonInapoi;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //se sterge backgroundul overlay-ului
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
		
        //se incarca imaginea pt overlay
        
        UIImageView *crosshairView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"laygraphic.png"]];
        [crosshairView setFrame:CGRectMake(-30, 0, 380, 480)];
        //crosshairView.contentMode = UIViewContentModeCenter;
        [self addSubview:crosshairView];
		
       /* //add a simple button to the overview
        //with no functionality at the moment
        UIButton *button = [UIButton 
                            buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"Scaneaza" forState:UIControlStateNormal];
        button.frame = CGRectMake(10, 430, 100, 40);
        [self addSubview:button];*/
        
      /*  //with no functionality at the moment
        UIButton *buttonInapoi = [UIButton
                            buttonWithType:UIButtonTypeRoundedRect];
        [buttonInapoi setTitle:@"Inapoi" forState:UIControlStateNormal];
        buttonInapoi.frame = CGRectMake(200, 430, 100, 40);
        [buttonInapoi addTarget:self action:@selector(buttonInapoiApasat:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonInapoi];*/
    }
    return self;
}


- (void)dealloc {
}


@end
