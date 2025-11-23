//
//  MenuServiceRaw.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/20/25.
//

import Foundation

final class MenuServiceRaw {
    // Base configuration
    private let databaseURL: String
    private let endpoint: String = "/rest/v1/menu_items?select=*"
   
    private var fullURL: String { "https://" + databaseURL + endpoint }
    private let anonKey: String

    init() {
        self.databaseURL = (Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.anonKey = (Bundle.main.object(forInfoDictionaryKey: "ANON_KEY") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      
    }

    func fetchMenuItems() async throws -> [MenuItem] {
        print("full URL",fullURL)

        guard let url = URL(string: fullURL) else {
            return []
        }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        // Set headers only if we actually have a key
        if !anonKey.isEmpty {
            req.setValue(anonKey, forHTTPHeaderField: "apikey")
            req.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
        }
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let text = String(data: data, encoding: .utf8) ?? "no body"
            throw NSError(domain: "HTTPError", code: 1, userInfo: [NSLocalizedDescriptionKey: text])
        }
        return try JSONDecoder().decode([MenuItem].self, from: data)
    }
}
