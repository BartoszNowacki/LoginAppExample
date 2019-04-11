//
//  PokemonProvider.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Appunite. All rights reserved.
//
enum ResultType {
    case error
    case success
}

struct PokemonProvider {
    
    static let shared: PokemonProvider = PokemonProvider()
    typealias FinishedDownload = (_ resultType: ResultType, _ content: [OutputModel]) -> ()
    
    func getPokemons() -> (ResultType, [OutputModel]) {
        if Connectivity.isConnectedToInternet {
            return  getFromApi {
                (resultType: ResultType, content: [OutputModel]) -> () in
                return (resultType: resultType, content: content)
            }
        } else {
            return getFromRealm()
        }
    }
    
    func getFromApi(completed: @escaping FinishedDownload) -> (resultType: ResultType, content: [OutputModel]) {
        var content = [OutputModel]()
        var result: ResultType = .error
        if UserManager.shared.isUserLogged() {
            let token = Token(token: UserManager.shared.getToken())
            APIClient.shared.makeCall(type: APIType.pokemon, for: token, complete: { response in
                switch response.type {
                case .failure, .serverError:
                    content = response.content
                    result = .error
                    log.info("tbdc \(content)")
                    completed(result, content)
//                    self.completed()
//                    return ((.error, response.content))
                case .success:
                    content = response.content
                    result = .success
                    log.info("tbdc \(content)")
                    completed(result, content)
                }
            } as (APIResponse<Pokemon>) -> Void)
        }
        log.info("tbdc this is content: \(content)")
        return (result, content)
    }
    
    private func getFromRealm() -> (resultType: ResultType, content: [OutputModel]) {
        if PokeManager.shared.isAvailable(RPokemon.self) {
            let rPokemons = PokeManager.shared.load() as [RPokemon]
            let pokemons = convertPokes(rPokemons: rPokemons)
            return (.success, pokemons)
        } else {
            let error = [Error(error: true, reason: "Pokemon is not available in Data Base")]
            return (.error, error)
        }
    }
    
    ///Converts Pokemons from RPokemon model to Pokemon model
    private func convertPokes(rPokemons: [RPokemon]) -> [Pokemon] {
        var pokemonList = [Pokemon]()
        for rPokemon in rPokemons {
            pokemonList.append(rPokemon.asDomain())
        }
        return pokemonList
    }
    
    /// Saves Pokemons to Realm DataBase
    private func savePokes(_ pokemons: [Pokemon]) {
        var rPokemons = [RPokemon]()
        for poke in pokemons {
            rPokemons.append(poke.asRealm())
        }
        PokeManager.shared.save(rPokemons)
    }
}
