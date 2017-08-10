import UIKit

class RecipesTableViewController: UITableViewController {

    var recipesProvider: RecipesProvider?
    var recipes = [String]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Recipes"
        
        recipesProvider = PuppyRecipesProvider()
        recipesProvider?.delegate = self
        recipesProvider?.recipes(forQuery: nil)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.textLabel?.text = recipes[indexPath.row]
        
        return cell
    }
    
}

extension RecipesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        recipesProvider?.recipes(forQuery: searchController.searchBar.text)
    }
    
}

extension RecipesTableViewController: RecipesProviderDelegate {
    
    func recipesProviderDidReceiveRecipes(recipesProvider: RecipesProvider, recipes:[Recipe], forQuery: RecipesQuery) {
        self.recipes = recipes
        tableView.reloadData()
    }
}
