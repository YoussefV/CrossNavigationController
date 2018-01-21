# CrossNavigationController
A navigation controller that can switch between view controllers horizontally and vertically

# TODO:

- [x] Setup `HeaderView`

- [x] Detect `HeaderView` scrolling direction and send that off to the `HeaderViewScrollDelegate`

- [ ] Implement the transitioning logic at the bottom of the `HeaderView` file (conforming to `HeaderViewScrollDelegate`)

# The file structure:
The file structure is a lot, but easy to understand.

## The controls:
The goal for this is to have a sort of `UITabBarController` that is interactive and is controlled by swipe gestures. You move between "Sections" (different categories) by vertical movement. This is to facilitate something like switching between multiple game modes (easy, medium, hard). You can then move between different "Pages" by moving horizontally. This is to facilitate movement between different levels in each game mode. (level1, level2, level3)

## The code:
All the code is mainly encapsulated in `HeaderView` class. The sections and pages are hardcoded in a 2D-Array called `pages`. With each large array containing an array of inner pages. It currently has 3 sections with four, three and four pages for each respective section.

There are also a bunch of variables called currSection and lastPage which store which section we're in so it can (hopefully) trigger a transition.

## The transitioning:
`HeaderView` implements the `HeaderViewScrollDelegate` which basically handles all scrolling and has a "`vertically`" parameter that indicates whether the user is transitioning vertically or horizontally. This is needed as the View Structure that handles this code is fairly convoluted, so this only deals with the scrolling after determining the direction is handled.
