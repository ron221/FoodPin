//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Ron Yeh on 2021/7/23.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    // MARK: View life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)

    }

    var restaurants:[Restaurant] = [
        Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "Hong Kong", image: "cafedeadend", isFavorite: false),
        Restaurant(name: "Homie", type: "Cafe", location: "Hong Kong", image: "homei", isFavorite: false),
        Restaurant(name: "Teakha", type: "Tea House", location: "Hong Kong", image: "teakha", isFavorite: false),
        Restaurant(name: "Cafe Loisl", type: "Austrian / Casual Drink", location: "Hong Kong", image: "cafeloisl", isFavorite: false),
        Restaurant(name: "Petite Oyster", type: "French", location: "Hong Kong", image: "petiteoyster", isFavorite: false),
        Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Hong Kong", image: "forkeerestaurant", isFavorite: false),
        Restaurant(name: "Po's Atelier", type: "Bakery", location: "Hong Kong", image: "posatelier", isFavorite: false),
        Restaurant(name: "Bourke Street Bakery", type: "Chocolate", location: "Sydney", image: "bourkestreetbakery", isFavorite: false),
        Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "Sydney", image: "haighschocolate", isFavorite: false),
        Restaurant(name: "Palamino Espresso", type: "Americam / Seafood", location: "Sydney", image: "palominoespresso", isFavorite: false),
        Restaurant(name: "Upstate", type: "American", location: "New York", image: "upstate", isFavorite: false),
        Restaurant(name: "Traif", type: "American", location: "New York", image: "traif", isFavorite: false),
        Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "New York", image: "fiveleaves", isFavorite: false),
        Restaurant(name: "Confessional", type: "Spanish", location: "New York", image: "confessional", isFavorite: false),
        Restaurant(name: "Barrafina", type: "Spanish", location: "London", image: "barrafina", isFavorite: false),
        Restaurant(name: "Donostia", type: "Spanish", location: "London", image: "donostia", isFavorite: false),
        Restaurant(name: "Royal Oak", type: "Britsh", location: "London", image: "royaloak", isFavorite: false)
    ]
    
    enum Section {
        case all
    }
    // MARK: UITableView diffable datasource
    func configureDataSource() -> UITableViewDiffableDataSource<Section, Restaurant> {
        let cellIdentifier = "datacell"
        
        let dataSource = UITableViewDiffableDataSource<Section, Restaurant>(
            tableView: tableView, cellProvider: {
                tableView, indexPath, restaurant in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
                
                cell.nameLabel.text = restaurant.name
                cell.thumbnailImageView.image = UIImage(named: restaurant.image)
                cell.locationLabel.text = restaurant.location
                cell.typeLable.text = restaurant.type
                cell.heartImageView.isHidden = restaurant.isFavorite ? false : true
                return cell
            }
        )
        return dataSource
    }
    
    lazy var dataSource = configureDataSource()
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Create options for action list
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        
        // Add actions into action list
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        // Display action list
//        present(optionMenu, animated: true, completion: nil)
        
        // Add reserve restaurant action
        let reserveActionHandler = { (action:UIAlertAction!) -> Void in
            
            let alertMessage = UIAlertController(title: "Not available yet", message: "Sorry, this feature is not available yet. Please try later", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        
        let reserveAction = UIAlertAction(title: "Reserve a table", style: .default, handler: reserveActionHandler)
        optionMenu.addAction(reserveAction)
        
        let favouriteActionTitle = self.restaurants[indexPath.row].isFavorite ? "Remove from favourite": "Mark as favourite"
        // Mark as favourite action
        let favouriteAction = UIAlertAction(title: favouriteActionTitle, style: .default, handler:{
            (action:UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            cell.heartImageView.isHidden = self.restaurants[indexPath.row].isFavorite
            
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false: true
        })
        optionMenu.addAction(favouriteAction)
        
        present(optionMenu, animated: true, completion: nil)
        
        // To cancel row selection
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
