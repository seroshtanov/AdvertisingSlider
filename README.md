# AdvertisingSlider
AdvertisingSlider


It's simple way to show some images with text in yours iOS appication

## Swift 5.0;  >=iOS10.3 

### Installation:

**pod 'AdvertisingSlider', '0.9.7'**

## How to use:

Just put UIView in your xib or storyboard and change class name on "AdvertisingSlider" 

### Follow AdvertisingSliderDataSource to fill view:

#### It has 3 methods: 
 <p>func pagesCount(forSlider: AdvertisingSlider) -> Int<p/>
 <p>func imageForIndex(_ index: Int, slider: AdvertisingSlider) -> UIImage<p/>
 <p>func textForIndex(_ index: Int, slider: AdvertisingSlider) -> String<p/>
  
#### For reloading view and changing pages:

For reload view use func reloadData() 

Functions nextPage() and previousPage() are switching pages, if you'll want to make it with other component

If you want to go some any page you can use func moveToPage(_ index: Int, animated: Bool)

## Customise: 

#### This component can used with 2 ways: for showing only images (by swipe) or showing images and text (by buttons)
For choosing first one  - swith property scrollingManually to true. It false by default.

#### Use next properties for change UI:
When "scrollingManually == false" AdvertisingSlider has UIView over images. You can change color and alpha channel for it. To do this use:  'overViewColor', 'overViewAlpha'
 
#### For customise PageControl:
<p>activePageColor == currentPageIndicatorTintColor<p/>
<p>pageColor == pageIndicatorTintColor<p/>
<p>Set 'pageControlInteraction = true' if you want to change current page by tap on page control. It false by default<p/>
<p>Set 'pageControlOverImages = true' if you don't want to see white background under page control. It false by default<p/>

#### For change text settings:

<p>textColor<p/>
<p>font<p/>
<p>textRows == numberOfLines (UILabel)<p/>
  
Use 'defaultText' when you want to show some message while no data. It doesn't work when 'scrollingManually == true'

#### For change buttons images use leftButtonImage / rightButtonImage properties

#### For change imageViews content mode use 'contentMode' property of AdvertisingSlider

#### Most of properties are @IBInspectable
