# Survey_Nimble
- Target: iOS 10+ <br>
- Xcode: 12.5.1 <br>
- Swift: 5 <br>
- Pod: 1.10.1 <br>
- Structure: MVVM + RxSwift + RxCocoa <br>



# Application features
## Authentication:
- [x] Implement the login authentication screen.
- [x] Implement the OAuth authentication including the storage of access tokens.
- [x] Implement the automatic usage of refresh tokens to keep the user logged in using the OAuth API.
## Home Screen:
- [x] On the home screen, each survey card must display the following info:<br>
			- Cover image (background)<br>
	    - Name (in bold)<br>
			- Description<br>
- [x] There must be 2 actions:<br>
			- Horizontal scroll through the surveys.<br>
			- A button “Take Survey” should take the user to the survey detail screen. <br>
- [x] The list of surveys must be fetched when opening the application.
- [x] Show a loading animation when fetching the list of surveys.
- [x] The navigation indicator list (bullets) must be dynamic and based on the API response. <br>
## Optional features:<br>
- [x] Authentication: implement the forgot password authentication screen.

# Technical requirements
- [x] Develop the application using:<br>
			- Xcode<br>
			- Cocoa Pods<br>
			- Fastlane<br>
- [x] Target iOS 10.0 and up.
- [x] Use Git during the development process. Push to a public repository on Bitbucket, Github, or Gitlab. Make regular commits and merge code using pull requests.
- [x] Write unit tests using your framework of choice.
- [x] Use either the REST or GraphQL endpoints. The choice is yours to make. Make sure that you use the production URLs.

---------------

## Unit Test:
- Using XCTest + RxTest
- Coverage ~ 100% ViewModel
![Screen Shot 2022-06-23 at 20 52 15](https://user-images.githubusercontent.com/25881847/175350554-0c2f6347-64fa-4388-84ec-36c2c5aaa201.png)


---------------
## Other
- I break and track my tasks at https://trello.com/b/Fo5pbyiy/tracking-task








