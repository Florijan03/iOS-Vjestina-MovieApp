import UIKit

class MainTabBarController: UITabBarController {
    
    private var router: Router!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationController = UINavigationController(rootViewController: self)
        router = Router(navigationController: navigationController)

        let movieCategoriesListVC = MovieListCategoryViewController(router: router)
        let movieListNavController = UINavigationController(rootViewController: movieCategoriesListVC)
        movieListNavController.tabBarItem = UITabBarItem(title: "Movie list", image: UIImage(systemName: "house"), tag: 0)

        let favoritesVC = FavoritesViewController()
        let favoritesNavController = UINavigationController(rootViewController: favoritesVC)
        favoritesNavController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)
        
        viewControllers = [movieListNavController, favoritesNavController]
    }
}
