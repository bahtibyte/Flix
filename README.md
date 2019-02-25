# Flix

Flix is an app that allows users to browse movies from the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

## Flix Part 2

### User Stories

#### REQUIRED (10pts)
- [x] (5pts) User can tap a cell to see more details about a particular movie.
- [x] (5pts) User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

#### BONUS
- [x] (2pts) User can tap a poster in the collection view to see a detail screen of that movie.
- [x] (2pts) In the detail view, when the user taps the poster, a new screen is presented modally where they can view the trailer.
- [x] User can search for movies. It returns the top 20 matching movies to the search query.
- [X] When a movie is selected, top movies that relate to the current movie is also displayed

### App Walkthough GIF
<img src="http://g.recordit.co/w5LcYruqEn.gif" width=250><br>

### Notes
- Working on the search tab was challenging because I had trouble hiding the keyboard when a movie was selected. When adding a new gesture for the collection view, it overrided its past gestures and it didnt detect tapping. I overcame the problem by hiding the keyboard when a movie is chosen.

---

## Flix Part 1

### User Stories

#### REQUIRED (10pts)
- [x] (2pts) User sees an app icon on the home screen and a styled launch screen.
- [x] (5pts) User can view and scroll through a list of movies now playing in theaters.
- [x] (3pts) User can view the movie poster image for each movie.

#### BONUS
- [x] (2pt) User can view the app on various device sizes and orientations.
- [x] (1pt) Run your app on a real device.
- [x] User can see multiple genres.
- [x] The movies are arranged in a 2D table.

### App Walkthough GIF
<img src="http://g.recordit.co/w5LcYruqEn.gif" width=250><br>

### Notes
- Adding a collection view on a table view cell was challenging because of nested views. Once there was 2D table view of the movies, detecting which movie was selected was difficult. 
- Another problem was when using reusuable cell for the table view, it did not reset the collection view, so often times I would see repeated movies on different genres
