# NewsHub

The app was developed within a **3-day sprint** according to specific test task requirements

## Screenshots

| Search | Browse | Filter |
| :----------: | :---------: | :---------: |
<img src = "https://github.com/Beavean/NewsHub/assets/105853157/d8f94abd-ed4f-4426-9697-83e9a61c71eb" width = 300> | <img src = "https://github.com/Beavean/NewsHub/assets/105853157/06f20764-8dac-4d9a-b6ed-31019c2976b9" width = 300> | <img src = "https://github.com/Beavean/NewsHub/assets/105853157/dab96592-de93-4969-8af2-98a545b84cbe" width = 300> |

## Key Features

* UIKit
* MVVM
* XIB for custom cell
* Programmatic UI
* Diverse search options
* Pagination
* Favorites via Realm
* 4 screens with different elements
* Separate services
* Basic Error handling
* Basic DI
* Only 2 dependencies: Realm & SDWebImage
* Light/Dark appearance support
* iOS 14.0+

## Overall requirements 

✅ Latest Swift Version: The app is built using the latest version of Swift.


✅ UIKit: The user interface is implemented using UIKit, not SwiftUI.


✅ UITableView: Custom UITableViewCell with the following elements: source, author, title, description, and an image with a clickable link to the full news article using WKWebView.


✅ Favourite Button: Each UITableViewCell has a favorite button to add articles to the favorite list. Data is stored using Realm.


✅ Saved Articles: Users can view their saved articles in a separate UIViewController.


✅ UIRefreshControl: Implemented for pull-to-refresh functionality.


✅ Loading View: A loading view is used for pagination


## Main UIViewController requirements

✅ Sorting: Users have articles sorted by publishedAt.

✅ Filtering: Users can filter articles by category, country, or sources.


✅ Search: A search feature allows users to search for specific articles.


✅ Pagination: The app supports pagination for fetching more articles.


✅ API Queries: Queries to the API are managed in a separate class.


✅ Architecture: MVVM or MVP architecture is preferred but not required.

