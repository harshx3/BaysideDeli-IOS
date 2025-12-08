//
//  MenuViewModel.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/20/25.
//

import Foundation
import Combine


@MainActor
final class MenuViewModel: ObservableObject {
    @Published var items: [MenuItem] = []
    @Published var errorMessage: String?

    private let menuService: MenuService
    private let storageService: StorageService
    
    init(menuService: MenuService = SupabaseManager.shared.menuService,
         storageService: StorageService = SupabaseManager.shared.storageService) {
        self.menuService = menuService
        self.storageService = storageService
    }

    func load() async {
        guard items.isEmpty else { return }
        
        do {
            
            var fetchedItems = try await menuService.fetchMenuItems()
            
            // Iterate and convert the raw image path to the public URL
            fetchedItems = fetchedItems.map {
                item in
                var mutableItem = item
                //Assume item.image_path holds the raw file name like Chopped_Cheesea
                if let imagePath = item.image_url,
                   let publicURL = storageService.getPublicImageURL(for: imagePath) {
                    
                    mutableItem.image_url = publicURL

                }
                return mutableItem
            }
            self.items = fetchedItems
            print("Items Data:", items)
        } catch {
            errorMessage = error.localizedDescription
            print("Fetch error: ", error)
        }
    }
}
