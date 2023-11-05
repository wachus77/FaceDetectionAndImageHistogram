import UIKit

class ImageViewController: UIViewController {
    
    let topImageView = UIImageView()
    let bottomImageView = UIImageView()
    
    // Properties to hold images that can be set externally
    var topImage: UIImage?
    var bottomImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // Add the image views to the view hierarchy
        view.addSubview(topImageView)
        view.addSubview(bottomImageView)
        
        // Set up the image views
        setupImageViews()
        
        // Set the images passed externally
        topImageView.image = topImage
        bottomImageView.image = bottomImage
    }
    
    private func setupImageViews() {
        // Disable autoresizing mask translation into constraints
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints for the top image view
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            topImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5) // Half the height of the view
        ])
        
        // Set up constraints for the bottom image view
        NSLayoutConstraint.activate([
            bottomImageView.topAnchor.constraint(equalTo: topImageView.bottomAnchor),
            bottomImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Configure the content mode
        topImageView.contentMode = .scaleAspectFit
        bottomImageView.contentMode = .scaleAspectFit
    }
}
