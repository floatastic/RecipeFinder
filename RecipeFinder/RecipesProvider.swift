
typealias Recipe = String
typealias RecipesQuery = String?

protocol RecipesProvider {
    weak var delegate: RecipesProviderDelegate? { get set }
    
    func recipes(forQuery query: RecipesQuery)
}

protocol RecipesProviderDelegate: class {
    func recipesProviderDidReceiveRecipes(recipesProvider: RecipesProvider, recipes:[Recipe], forQuery: RecipesQuery)
}
