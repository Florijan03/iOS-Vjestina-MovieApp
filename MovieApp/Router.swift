import UIKit

protocol AppRouterProtocol {
    
//    func setStartScreen(in window: UIWindow?)
    func navigateToMovieDetails(movieId: Int)
    func navigateBack()
}

class Router: AppRouterProtocol {
    private let navigationController: UINavigationController!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
//    func setStartScreen(in window: UIWindow?) {
//    let vc = MainTabBarController()
//    navigationController.pushViewController(vc, animated: true)
//    window?.rootViewController = navigationController
//    window?.makeKeyAndVisible()
//    }

    func navigateToMovieDetails(movieId: Int) {
        let movieDetailsVC = MovieDetailsViewController(movieId: movieId)
        navigationController.pushViewController(movieDetailsVC, animated: true)
    }

    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}
