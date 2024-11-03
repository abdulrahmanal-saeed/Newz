<h1 align="center" id="title">Newz - Flutter News Application</h1>

<p align="center"><img src="https://socialify.git.ci/abdulrahmanal-saeed/Newz/image?description=1&amp;descriptionEditable=Newz%20is%20a%20news%20application%20built%20with%20Flutter%20that%20uses%20the%20MVVM%20architecture%20pattern.%20The%20app%20fetches%20news%20from%20various%20sources%2C%20allowing%20users%20to%20browse%20different%20categories%20and%20save%20their%20favorite%20articles%20for%20later.&amp;font=Inter&amp;language=1&amp;name=1&amp;owner=1&amp;pattern=Brick%20Wall&amp;theme=Dark" alt="project-image"></p>

<p id="description">Newz is a news application built with Flutter that uses the MVVM architecture pattern. The app fetches news from various sources allowing users to browse different categories and save their favorite articles for later.</p>

<h2>Project Screenshots:</h2>

<p align="center">
  <img src="https://easyorders.fra1.digitaloceanspaces.com/1730653279561195910.png" width="960" height="540"/>
  <img src="https://easyorders.fra1.digitaloceanspaces.com/1730653145247429681.png" width="960" height="540"/>
  <img src="https://easyorders.fra1.digitaloceanspaces.com/1730653153854503707.png" width="960" height="540"/>
  <img src="https://easyorders.fra1.digitaloceanspaces.com/1730653163755463401.png" width="960" height="540"/>
  <img src="https://easyorders.fra1.digitaloceanspaces.com/1730653175520502145.png" width="960" height="540"/>
  <img src="https://easyorders.fra1.digitaloceanspaces.com/1730653190939863434.png" width="960" height="540"/>
  <img src="https://easyorders.fra1.digitaloceanspaces.com/1730653201438787742.png" width="960" height="540"/>
</p>
  
  
<h2>🧐 Features</h2>

Here are some of the project's best features:

*   **MVVM Architecture**: Organized using MVVM for better maintainability and testability.
*   **News Display**: Shows news articles from various sources using the News API.
*   **Browse by Categories**: Users can browse news articles by categories like Sports, Technology, Health, Business, and Science.
*   **Save Articles**: Allows users to save articles to read later.
*   **Custom UI**: Elegant and user-friendly design with support for dark mode.
*   **Custom Notifications**: Sends notifications to users about the latest news updates.
*   **Smooth Navigation**: Easy-to-use UI with transitions between different sections of the app.
*   **Offline Support**: Save articles for reading without an internet connection.


<h2>🛠️ Installation Steps:</h2>

<p>1. Clone the repository:</p>

```
git clone https://github.com/abdulrahmanal-saeed/newz.git
```
```
 cd newz
```
<p>2. Add your API Key:</p>
Open `api/api_constants.dart` and add your API key:

```dart
class ApiConstants {   
  static String apiKey = 'YOUR_NEWS_API_KEY'; 
}
```

<p>3. Run the app:</p>

```
flutter run
```

<h2>🍰 Contribution Guidelines:</h2>

Feel free to open an issue or submit a pull request if you have any suggestions or improvements.

  
  
<h2>💻 Built with</h2>
Technologies used in the project:

*   **Flutter:** The main framework used for building the cross-platform application.
*   **MVVM Structure:** For better code organization and separation of concerns.
*   **Provider:** For state management.
*   **HTTP:** For making HTTP requests to fetch data.
*   **Shared Preferences:** For storing saved articles locally.
*   **URL Launcher:** For opening article URLs in the browser.
*   **Timeago:** For displaying dates in a "time ago" format like "1 hour ago".
*   **Share Plus:** For sharing articles with others.
