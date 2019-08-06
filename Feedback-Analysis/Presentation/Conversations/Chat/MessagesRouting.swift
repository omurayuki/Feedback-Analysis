import Foundation
import RxSwift

protocol MessagesRouting: Routing {
    func showPreviewPage(imageLink: String)
}

class MessagesRoutingImpl: MessagesRouting {
    
    var viewController: UIViewController?
    
    func showPreviewPage(imageLink: String) {
        let vc = PreviewViewController()
        let ui = PreviewUIImpl()
        let routing = PreviewRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        vc.imageURLString = imageLink
        
        vc.inject(ui: ui, routing: routing, disposeBag: DisposeBag())
        viewController?.navigationController?.present(vc, animated: true)
    }
}
