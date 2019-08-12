import UIKit

protocol AnalysisUI: UI {
    var firstAnalysisView: AnalysisView { get set }
    var secondAnalysisView: AnalysisView { get set }
    var thirdAnalysisView: AnalysisView { get set }
    
    func setup()
    func mapping()
}

final class AnalysisUIImpl: AnalysisUI {
    
    var viewController: UIViewController?
    
    var firstAnalysisView: AnalysisView = {
        let view = AnalysisView()
        return view
    }()
    
    var secondAnalysisView: AnalysisView = {
        let view = AnalysisView()
        return view
    }()
    
    var thirdAnalysisView: AnalysisView = {
        let view = AnalysisView()
        return view
    }()
}

extension AnalysisUIImpl {
    
    func setup() {
        guard let vc = viewController else { return }
        [firstAnalysisView, secondAnalysisView, thirdAnalysisView].forEach { vc.view.addSubview($0) }
        
        firstAnalysisView.anchor()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .width(to: vc.view.widthAnchor)
            .activate()
        
        secondAnalysisView.anchor()
            .top(to: firstAnalysisView.bottomAnchor)
            .width(to: vc.view.widthAnchor)
            .activate()
        
        thirdAnalysisView.anchor()
            .top(to: secondAnalysisView.bottomAnchor)
            .width(to: vc.view.widthAnchor)
            .activate()
    }
    
    func mapping() {
        
    }
}
