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
    
//    static let shared: PokemonProvider = PokemonProvider()
//    
//    func getPokemons() -> (ResultType, [OutputModel]) {
//        if Connectivity.isConnectedToInternet {
//            return getFromApi()
//        } else {
//            return getFromRealm()
//        }
//    }
//    
//    private func getFromApi() -> (ResultType, [OutputModel]) {
//        if UserManager.shared.isAvailable(RToken.self) {
//            let token = UserManager.shared.current(RToken.self)!.asDomain()
//            APIClient.shared.makeCall(type: APIType.pokemon, for: token, complete: { response in
//                switch response.type {
//                case .failure, .serverError:
//                    return ((.error, response.content))
//                case .success:
//                    self.return (.success, response.content)
//                }
//            } as (APIResponse<Pokemon>) -> Void)
//        }
//    }
//    
//    private func getFromRealm() -> (ResultType, [OutputModel]) {
//        if UserManager.shared.isAvailable(RPokemon.self) {
//            let rPokemons = UserManager.shared.load() as [RPokemon]
//            let pokemons = convertPokes(rPokemons: rPokemons)
//            return (.success, pokemons)
//        } else {
//            let error = [Error(error: true, reason: "Pokemon is not available in Data Base")]
//            return (.error, error)
//        }
//    }
//    
//    private func convertPokes(rPokemons: [RPokemon]) -> [Pokemon] {
//        var pokemons: [Pokemon]?
//        for rPokemon in rPokemons {
//            pokemons?.append(rPokemon.asDomain())
//        }
//        return pokemons!
//    }
}
