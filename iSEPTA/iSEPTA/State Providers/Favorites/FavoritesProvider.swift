//
//  FavoritesProvider.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/3/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import CoreLocation
import Foundation
import ReSwift
import UIKit

enum FavoritesError: Error {
    case couldNotCreateTempFavoritesFile
    case couldNotCreateFavoritesFile
}

class FavoritesProvider {
    static let sharedInstance = FavoritesProvider()

    let fileManager = FileManager.default
    var initialLoadFavoritesFromDiskHasCompleted = false

    private init() {
        retrieveFavoritesFromDisk()
    }

    func retrieveFavoritesFromDisk() {
        DispatchQueue.global(qos: .background).async { [weak self] in

            do {
                if let targetURL = self?.favoritesFileURL,
                    let fileManager = self?.fileManager,
                    fileManager.fileExists(atPath: targetURL.path) {
                    let jsonData = try Data(contentsOf: targetURL)
                    let favorites = try JSONDecoder().decode([Favorite].self, from: jsonData)

                    DispatchQueue.main.async {
                        print("retrieve favorites from \(targetURL.path) was successful")
                        if favorites.count > 0 {
                            let switcchTabsAction = SwitchTabs(activeNavigationController: .favorites, description: "Defaulting to Favorites because they exist")
                            store.dispatch(switcchTabsAction)
                        }
                        let action = LoadFavorites(favorites: favorites)
                        store.dispatch(action)
                    }
                }
                self?.initialLoadFavoritesFromDiskHasCompleted = true
            } catch {
                print(error.localizedDescription)
            }
        }
        initialLoadFavoritesFromDiskHasCompleted = true
    }

    func writeFavoritesToFile(state: FavoritesState) {
        guard initialLoadFavoritesFromDiskHasCompleted else { return }

        let favoritesToWriteToDisk = filterFavoritesToWriteToDisk(favorites: state.favorites)
        DispatchQueue.global(qos: .background).async { [weak self] in

            do {
                if let targetURL = self?.favoritesFileURL,
                    let tempURL = self?.tempFavoritesFileURL,
                    let fileManager = self?.fileManager {
                    let jsonData = try JSONEncoder().encode(favoritesToWriteToDisk)
                    fileManager.createFile(atPath: tempURL.path, contents: jsonData, attributes: nil)
                    _ = try fileManager.replaceItemAt(targetURL, withItemAt: tempURL)
                    print("copy favorites to \(targetURL.path) was successful")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    fileprivate func filterFavoritesToWriteToDisk(favorites: [Favorite]) -> [Favorite] {
        return favorites.filter { $0.favoriteId != Favorite.reversedFavoriteId }
    }

    fileprivate lazy var documentDirectoryURL: URL? = {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }()

    fileprivate lazy var favoritesFileURL: URL? = {
        documentDirectoryURL?.appendingPathComponent("favorites.json")
    }()

    fileprivate lazy var tempFavoritesFileURL: URL? = {
        documentDirectoryURL?.appendingPathComponent("Tempfavorites.json")
    }()
}
