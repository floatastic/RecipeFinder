import Foundation

class PuppyRecipesProvider: RecipesProvider {
    
    weak var delegate: RecipesProviderDelegate?
    
    private let baseUrl = "http://www.recipepuppy.com/api/"
    private let pageCount = 2
    private let urlSession = URLSession(configuration: .default)
    
    func recipes(forQuery query: RecipesQuery) {
        
        fetchRecipes(query: query) { recipes in
            DispatchQueue.main.async {
                self.delegate?.recipesProviderDidReceiveRecipes(recipesProvider: self, recipes: recipes, forQuery: query)
            }
        }
    }
    
    private func fetchRecipes(forPage page: Int = 1, query: RecipesQuery, initialRecipes: [Recipe] = [Recipe](), completion: @escaping (_ recipes: [Recipe]) -> ()) {
        
        guard let url = url(forPage: page, query: query) else {
            completion(initialRecipes)
            return
        }
        
        urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            let recipes = initialRecipes + self.recipes(fromData: data)
            
            if (page == self.pageCount) {
                completion(recipes)
            } else {
                self.fetchRecipes(forPage: page + 1, query: query, initialRecipes: recipes, completion: completion)
            }
        }).resume()
    }
    
    private func url(forPage page: Int, query: RecipesQuery) -> URL? {
        
        var queryItems = [URLQueryItem(name: "p", value: String(page))]
        if let query = query {
            queryItems.append(URLQueryItem(name: "q", value: query))
        }
        
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
        
    private func recipes(fromData data: Data?) -> [Recipe] {
        guard let data = data,
            let jsonAny = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments),
            let jsonDict = jsonAny as? [String : AnyObject],
            let recipes = jsonDict["results"] as? [[String : AnyObject]] else {
                
            return [Recipe]()
        }
        
        return recipes.flatMap { $0["title"] as? String }
    }
}
