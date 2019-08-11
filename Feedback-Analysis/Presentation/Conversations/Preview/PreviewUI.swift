import UIKit

protocol PreviewUI: UI {
    var cancelBtn: UIButton { get }
    
    func setup(image: UIImage)
}

final class PreviewUIImpl: PreviewUI {
    
    var viewController: UIViewController?
    
    var cancelBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12.5
        button.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        button.backgroundColor = .white
        return button
    }()
}

extension PreviewUIImpl {
    
    func setup(image: UIImage) {
        guard let vc = viewController else { return }
        let imageView = generateZoomImage(image: image)
        imageView.backgroundColor = .black
        [imageView, cancelBtn].forEach { vc.view.addSubview($0) }
        
        imageView.anchor()
            .top(to: vc.view.topAnchor)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .bottom(to: vc.view.bottomAnchor)
            .activate()
        
        cancelBtn.anchor()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor, constant: 20)
            .right(to: vc.view.rightAnchor, constant: -20)
            .width(constant: 25)
            .height(constant: 25)
            .activate()
    }
    
    private func generateZoomImage(image: UIImage) -> ImageZoomView {
        guard let vc = viewController else { return ImageZoomView() }
        return ImageZoomView(frame: CGRect(x: 0, y: (vc.view.frame.height / 2) - ((vc.view.frame.height / 2.3) / 2), width: vc.view.frame.width, height: vc.view.frame.height / 2.3), image: image)
    }
}
