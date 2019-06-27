import XCTest
@testable import TopMovies

class MoviesViewControllerTests: XCTestCase {
    
    func moviesViewController(
        client: MoviesClient = StubMoviesClient(movies: []))
        -> MoviesViewController {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Movies")
            as! MoviesViewController
        vc.moviesClient = client
        let _ = vc.view
        return vc

    }
    
    func test_title_is_Top_Movies() {
        let vc = moviesViewController()
        XCTAssertEqual(vc.navigationItem.title!, "Top Movies")
    }
    
    func test_collection_view_has_zero_items_when_there_are_no_movies() {
        let vc = moviesViewController()
        let numberOfItems = vc.collectionView(vc.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(numberOfItems, 0)
    }
    
    func test_collection_view_has_two_items_when_there_are_two_movies() {
        let movies = [createMovie(), createMovie()]
        let vc = moviesViewController(client: StubMoviesClient(movies: movies))
        let numberOfItems = vc.collectionView(vc.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(numberOfItems, 2)
    }
    
    func createMovie(title: String = "TEST") -> Movie {
        return Movie(title: title)
    }
    
    func test_first_cell_title_is_Jumanji_when_movie_is_Jumanji() {
        let movie = createMovie(title: "Jumanji: Welcome to the Jungle")
        let movies = [movie]
        let vc = moviesViewController(client: StubMoviesClient(movies: movies))
        
        let cell = vc.collectionView(vc.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as! MovieCell
        
        XCTAssertEqual(movie.title, cell.title.text!)
    }
    
    func test_movies_are_set_when_client_returns_movies() {
        let movies = [createMovie(), createMovie(), createMovie()]
        let vc = moviesViewController(client: StubMoviesClient(movies: movies))
        vc.refresh()
        XCTAssertEqual(vc.movies.count, 3)
    }

}

class StubMoviesClient: MoviesClient {
    var movies: [Movie]
    init(movies: [Movie]) {
        self.movies = movies
    }
    
    override func fetchMovies(completion: (([Movie]) -> Void)?) {
        completion!(movies)
    }
}