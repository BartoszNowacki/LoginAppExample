//
//  DetailTableViewController.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class DetailTableViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pokemons: [Pokemon]? {
        didSet {
            if let pokemons = pokemons, pokemons.count > 0 {
                log.info("tbdc got here pok rel2")
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Log out", comment: "").lowercase, style: .done, target: self, action: #selector(logOut))
        if Connectivity.isConnectedToInternet {
            getPokemonsFromApi()
        } else {
            getFromRealm()
        }
    }
    
    // MARK: - Function that will be removed to PokeProvider (check "readme" file)
    
    /// Api call for getting pokemons
    
    private func getPokemonsFromApi() {
        log.info("Get pokemons")
        if UserManager.shared.isAvailable(RToken.self) {
            let token = UserManager.shared.current(RToken.self)!.asDomain()
            APIClient.shared.makeCall(type: APIType.pokemon, for: token, complete: { response in
                switch response.type {
                case .failure, .serverError:
                    log.error("Something bad happend when getting pokemons")
                    if let error = response.content.first as! Error? {
                        self.showErrorHUD(with: error.reason)
                    }
                case .success:
                    if let pokemonsList = response.content as? [Pokemon] {
                        self.pokemons = pokemonsList
                        self.savePokes()
                    }
                    self.dismissHUD()
                }
                } as (APIResponse<Pokemon>) -> Void)
        }
    }
    
    
    /// Get Pokemons from realm data base
    private func getFromRealm() {
        if PokeManager.shared.isAvailable(RPokemon.self) {
            let rPokemons = PokeManager.shared.load() as [RPokemon]
            log.info("there is pokemons: \(rPokemons)")
            for poke in rPokemons {
                log.info("single poke: \(poke)")
            }
            pokemons = convertPokes(rPokemons: rPokemons)
        } else {
            log.error("There are no pokemons stored in Realm")
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
    private func savePokes() {
        var rPokemons = [RPokemon]()
        for poke in pokemons! {
            rPokemons.append(poke.asRealm())
        }
        PokeManager.shared.save(rPokemons)
    }
    
    /// Function for logging out. It is deleting RToken object and dismissing current View Controller
    
    @objc private func logOut() {
        UserManager.shared.deleteAll()
        PokeManager.shared.deleteAll()
        dismiss(animated: true, completion: nil)
    }
}

    
    // MARK: - UITableViewController functions
    
    extension DetailTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return pokemons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        log.info("got here tab1")
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier) as! DetailTableViewCell
        if let pokemon = pokemons?[indexPath.row] {
            cell.nameLabel.text = pokemon.name
            cell.typeLabel.text = pokemon.type
            cell.weightLabel.text = String(pokemon.weight)
            let url = URL(string: pokemon.photo)
            cell.avatarImageView.kf.setImage(with: url)
        }
        return cell
    }
        
}
