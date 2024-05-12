//
//  WindowController.m
//  MyApp
//
//  Created by Jinwoo Kim on 5/12/24.
//

#import "WindowController.h"
#import <objc/message.h>
#import <objc/runtime.h>

NSTouchBarItemIdentifier const overlayTouchBarItemIdentifier = @"touchBarItemOverlayTouchBarItemIdentifier";

@interface OverlayTouchBarItem : NSTouchBarItem {
    NSView *_view;
    id _overlay;
}
@end

@implementation OverlayTouchBarItem

- (instancetype)initWithIdentifier:(NSTouchBarItemIdentifier)identifier {
    if (self = [super initWithIdentifier:identifier]) {
        _view = [[NSButton buttonWithTitle:@"Overlay" image:[NSImage imageWithSystemSymbolName:@"ladybug" accessibilityDescription:nil] target:self action:@selector(buttonDidTrigger:)] retain];
        
        id overlay = ((id (*)(id, SEL, id))objc_msgSend)([objc_lookUpClass("NSTouchBarItemOverlay") alloc], sel_registerName("initWithItem:"), self);
        
        NSTouchBar *overlayTouchBar = [NSTouchBar new];
        
        __kindof NSControl *colorListPicker = [objc_lookUpClass("NSTouchBarColorListPicker") new];
        colorListPicker.target = self;
        colorListPicker.action = @selector(colorListPickerDidTrigger:);
        colorListPicker.continuous = NO;
        NSCustomTouchBarItem *customTouchBarItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:@"colorListPicker"];
        customTouchBarItem.view = colorListPicker;
        [colorListPicker release];
        
        overlayTouchBar.defaultItemIdentifiers = @[@"colorListPicker"];
        overlayTouchBar.templateItems = [NSSet setWithObject:customTouchBarItem];
        [customTouchBarItem release];
        
        ((void (*)(id, SEL, id))objc_msgSend)(overlay, sel_registerName("setOverlayTouchBar:"), overlayTouchBar);
        [overlayTouchBar release];
        
        _overlay = [overlay retain];
        [overlay release];
    }
    
    return self;
}

- (void)dealloc {
    [_view release];
    [_overlay release];
    [super dealloc];
}

- (NSView *)view {
    return _view;
}

- (void)buttonDidTrigger:(NSButton *)sender {
    ((void (*)(id, SEL))objc_msgSend)(_overlay, sel_registerName("show"));
}

- (void)colorListPickerDidTrigger:(__kindof NSControl *)sender {
    NSColor *currentColor = ((id (*)(id, SEL))objc_msgSend)(sender, sel_registerName("currentColor"));
    
    NSView *colorView = [NSView new];
    ((void (*)(id, SEL, id))objc_msgSend)(colorView, sel_registerName("setBackgroundColor:"), currentColor);
    
    NSCustomTouchBarItem *customTouchBarItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:@"colorView"];
    customTouchBarItem.view = colorView;
    [colorView release];
    
    id overlay = ((id (*)(id, SEL, id))objc_msgSend)([objc_lookUpClass("NSTouchBarItemOverlay") alloc], sel_registerName("initWithItem:"), self);
    
    NSTouchBar *overlayTouchBar = [NSTouchBar new];
    
    overlayTouchBar.defaultItemIdentifiers = @[@"colorView"];
    overlayTouchBar.templateItems = [NSSet setWithObject:customTouchBarItem];
    [customTouchBarItem release];
    
    ((void (*)(id, SEL, id))objc_msgSend)(overlay, sel_registerName("setOverlayTouchBar:"), overlayTouchBar);
    [overlayTouchBar release];
    
    ((void (*)(id, SEL, BOOL))objc_msgSend)(overlay, sel_registerName("setShowsCloseButtonForOverlay:"), NO);
    
    ((void (*)(id, SEL))objc_msgSend)(overlay, sel_registerName("show"));
}

@end

@implementation WindowController

- (NSTouchBar *)makeTouchBar {
    NSTouchBar *touchBar = [NSTouchBar new];
    
    OverlayTouchBarItem *overlayTouchBarItem = [[OverlayTouchBarItem alloc] initWithIdentifier:overlayTouchBarItemIdentifier];
    touchBar.defaultItemIdentifiers = @[overlayTouchBarItemIdentifier];
    touchBar.templateItems = [NSSet setWithObject:overlayTouchBarItem];
    [overlayTouchBarItem release];
    
    return [touchBar autorelease];
}

@end
