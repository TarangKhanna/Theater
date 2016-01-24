# Theater
# Project 1 - *Theater*

**Theater** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **16** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] User sees an error message when there's a networking error.
- [x] Movies are displayed using a CollectionView instead of a TableView. (NOTE: Can switch between both type of views)
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [x] Customize the UI.

The following **additional** features are implemented:

- [x] Cards like tableview 
- [x] Ratings shows in star format (out of 5)
- [x] Trailer is shown 
- [x] Loading all 39 pages of data

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://github.com/TarangKhanna/Theater/blob/master/GifTheater_1.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

## Collection View and loading more data:

And here is switching to Collection view and loading more data:

<img src='https://github.com/TarangKhanna/Theater/blob/master/GifTheater_2.gif' title='More Options' width='' alt='More Options' />

GIFs created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Loading more data from the API required calling the API again (39) times and add it to the movies NSDictionary, interesting to implement. 
I prefer the way my tableview looked so I created collection view and tableview. 

## License

    Copyright [2016] [Tarang Khanna]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
