import Foundation
import UIKit

class TimelineTableViewDataSource<CellType, EntityType>: NSObject, UITableViewDataSource {
    
    typealias C = CellType
    
    typealias E = EntityType
    
    private let cellReuseIdentifier: String
    
    private let cellConfigurationHandler: (C, E, IndexPath) -> Void
    
    var listItems: [E]
    
    init(cellReuseIdentifier: String, listItems: [E], cellConfigurationHandler: @escaping (C, E, IndexPath) -> Void) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.cellConfigurationHandler = cellConfigurationHandler
        self.listItems = listItems
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        let listItem = listItems[indexPath.row]
        
        cellConfigurationHandler(cell as! C, listItem, indexPath)
        
        return cell
    }
}
