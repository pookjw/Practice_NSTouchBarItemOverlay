//
//  ViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 5/12/24.
//

#import "ViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface ViewController () <NSTouchBarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     NSTouchBarColorListPicker
     NSTouchBarColorPickerSlidersGrayscale
     NSTouchBarColorPickerSlidersRGB
     NSTouchBarColorPickerSlidersCMYK
     NSTouchBarColorPickerSlidersHSB
     NSTouchBarColorPickerFavorites (NSFavoriteColorsStore, _NSTouchBarColorPickerDoubleTapButton, _NSFavoriteColorsDidChangeNotification)
     */
    NSStackView *stackView = [NSStackView stackViewWithViews:@[
        [[objc_lookUpClass("NSTouchBarColorListPicker") new] autorelease],
        [[objc_lookUpClass("NSTouchBarColorPickerSlidersGrayscale") new] autorelease],
        [[objc_lookUpClass("NSTouchBarColorPickerSlidersRGB") new] autorelease],
        [[objc_lookUpClass("NSTouchBarColorPickerSlidersCMYK") new] autorelease],
        [[objc_lookUpClass("NSTouchBarColorPickerSlidersHSB") new] autorelease],
        [[objc_lookUpClass("NSTouchBarColorPickerFavorites") new] autorelease]
    ]];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    
//    __kindof NSView *colorListPicker = [objc_lookUpClass("NSTouchBarColorPickerSlidersGrayscale") new];
    
//    ((void (*)(id, SEL, id))objc_msgSend)(colorListPicker, sel_registerName("_colorListDidChange:"), [NSColorPickerTouchBarItem colorPickerWithIdentifier:@""]);
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

@end
