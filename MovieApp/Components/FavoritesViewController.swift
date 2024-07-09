import SwiftUI
import PureLayout

class FavoritesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        
        navigationItem.title = "Favourites"
    }

    private func buildViews() {
        createViews()
        styleViews()
        defineLayout()
    }
}

extension FavoritesViewController{
    func createViews(){
        
    }
    func styleViews(){
        view.backgroundColor = .white
    }
    func defineLayout(){
        
    }
}

