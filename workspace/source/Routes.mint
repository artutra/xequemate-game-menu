routes {
  /:difficulty (difficulty : String) {
    case (GameStore.decodeDifficultyUrl(difficulty)) {
      Maybe::Just(decodedDifficulty) =>
        GameStore.initialize(Page::DifficultyTab(decodedDifficulty))

      Maybe::Nothing =>
        GameStore.initialize(Page::NotFound)
    }
  }

  /:difficulty/:slug (difficulty : String, slug : String) {
    case (GameStore.decodeDifficultyUrl(difficulty)) {
      Maybe::Just(decodedDifficulty) =>
        GameStore.initialize(Page::GameView(decodedDifficulty, slug))

      Maybe::Nothing =>
        GameStore.initialize(Page::NotFound)
    }
  }

  / {
    GameStore.initialize(Page::Home)
  }

  * {
    GameStore.initialize(Page::NotFound)
  }
}
