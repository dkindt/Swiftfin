//
/*
 * SwiftFin is subject to the terms of the Mozilla Public
 * License, v2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * Copyright 2021 Aiden Vigue & Jellyfin Contributors
 */

import Foundation
import JellyfinAPI

final class LibraryListViewModel: ViewModel {

    @Published var libraries = [BaseItemDto]()

    // temp
    var withFavorites = LibraryFilters(filters: [.isFavorite], sortOrder: [], withGenres: [], sortBy: [])

    override init() {
        super.init()

        requestLibraries()
    }

    func requestLibraries() {
        UserViewsAPI.getUserViews(userId: SessionManager.current.user.user_id ?? "val was nil")
            .trackActivity(loading)
            .sink(receiveCompletion: { completion in
                self.handleAPIRequestError(completion: completion)
            }, receiveValue: { response in
                self.libraries.append(contentsOf: response.items ?? [])
            })
            .store(in: &cancellables)
    }
}
