import UIKit

protocol AppRouterProtocol {
    
    func setStartScreen(in window: UIWindow?)
    func navigateToMovieDetails(movieId: Int)
    func navigateBack()
}

class Router: AppRouterProtocol {
    private let navigationController: UINavigationController!
    private var movieListVC: UIViewController!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setStartScreen(in window: UIWindow?) {
//        movieListVC = MovieListViewController(router: self)
//        window?.rootViewController = movieListVC
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        showTabViewController()
    }

    func showTabViewController() {
        let tabBarController = MainTabBarController()
        //firebase firestore
        
        let movieCategoriesListVC = MovieListCategoryViewController(router: self)
        let movieListNavController = UINavigationController(rootViewController: movieCategoriesListVC)
        movieListNavController.tabBarItem = UITabBarItem(title: "Movie list", image: UIImage(systemName: "house"), tag: 0)

        let favoritesVC = FavoritesViewController()
        let favoritesNavController = UINavigationController(rootViewController: favoritesVC)
        favoritesNavController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)
        
        tabBarController.viewControllers = [movieListNavController, favoritesNavController]
        
        
        navigationController.setViewControllers([tabBarController], animated: true)    }
    
    func navigateToMovieDetails(movieId: Int) {
        guard
            let currentViewController = navigationController.topViewController as? MainTabBarController,
            let navigationController = currentViewController.selectedViewController as? UINavigationController
        else { return }
        
        let movieDetailsVC = MovieDetailsViewController(movieId: movieId)
        navigationController.pushViewController(movieDetailsVC, animated: true)
    }

    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}
