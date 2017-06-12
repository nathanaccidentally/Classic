// Classic brings the older notification style to iOS 10.
// Built by nathanaccidentally. This is the first rewrite.

// This is the interface for the main notification view.

@interface NCNotificationShortLookView : UIView
@end

// This is for the cell.

@interface NCMaterialView : UIView
@end

// This is for the backdrop blur.

@interface _UIBackdropView : UIView
@end

// Now we've gotta create global variables for our settings toggles.

static BOOL whiteBlur = NO;
static BOOL topBar = NO;
static BOOL isTenOne = NO;
static NSInteger lineAmount = 4; // This is the default.

// Now we're gonna hook NCMaterialView and change our corner radius.

%group classic
%hook NCMaterialView

- (CGFloat)_subviewsContinuousCornerRadius {
	return 1;
}

// That should return 1 for the corner radius and its subviews.

- (void)_setSubviewsContinuousCornerRadius:(CGFloat)_subviewsContinuousCornerRadius {
	%orig(1);
}

- (void)viewDidAppear {
	%orig;
	if ([self.superview isMemberOfClass:objc_getClass("UIView")] && whiteBlur) {
		if (topBar) {
			// Do nothing.
		} else {
			[self setHidden:YES]; // OK, this puzzled me too. But it appears this is why I check the superview and it's for the top cell bar.
		}
	}

	if ([self.superview isMemberOfClass:objc_getClass("NCNotificationShortLookView")] && whiteBlur == NO) {
		// Thanks AppleBetas
		UIView *backdropView = MSHookIvar< _UIBackdropView *>(self, "_backdropView");
		[backdropView setHidden:YES];
	}
}

%end

%hook NCNotificationShortLookView
// Grape. This is where I change frame stuff.

- (void)setFrame:(CGRect)frame {
	// We're gonna start by doing stuff for 10.1.1.
	if ([self.superview isMemberOfClass:objc_getClass("UIScrollView")] && isTenOne) { // This should ignore notifications not in a scrolling view. (10.1.1 only)
		frame = CGRectMake(-8, 0, UIScreen.mainScreen.bounds.size.width, frame.size.height);
		%orig(frame);
	} else if (isTenOne == NO) { // I haven't forgotten about 10.2 users.
		frame = CGRectMake(-8, 0, UIScreen.mainScreen.bounds.size.width, frame.size.height);
		%orig(frame);
	} else if (isTenOne && ![[self.superview isMemberOfClass:objc_getClass("UIScrollView")]]) { // This is for banners on 10.1.1.
		frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, frame.size.height);
		%orig(frame);
	}
}

// Phew. That should cover all cases the last version did.

- (void)setMessageNumberOfLines:(NSUInteger)messageNumberOfLines {
	%orig(lineAmount);
}

%end
%end

// Now we need to load the prefs.

%ctor {
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.nathanaccidentally.classicpreffs.plist"];
	NSLog(@"Classic: Prefs should be loaded.");

	if (prefs) {
		if ([[prefs objectForKey:@"isEnabled"] boolValue]) {
			%init(classic); // Starts the tweak.
		}

		if ([prefs objectForKey:@"whiteBlur"]) {
			whiteBlur = [[prefs objectForKey:@"whiteBlur"] boolValue];
		}

		if ([prefs objectForKey:@"topBar"]) {
			topBar = [[prefs objectForKey:@"topBar"] boolValue];
		}

		if ([prefs objectForKey:@"isTenOne"]) {
			isTenOne = [[prefs objectForKey:@"isTenOne"] boolValue];
		}

		// Great now we can do int stuff.

		if ([prefs objectForKey:@"lineAmount"]) {
			lineAmount = [[prefs objectForKey:@"lineAmount"] intValue];
		}
	}
}