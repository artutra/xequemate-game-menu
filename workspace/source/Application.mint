enum Page {
  Home
  DifficultyTab(Difficulty)
  GameView(Difficulty, String)
  NotFound
}

store Application {
  state page : Page = Page::Home

  fun setPage (page : Page) {
    next { page = page }
  }
}
