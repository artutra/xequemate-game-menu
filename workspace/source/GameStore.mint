record GameListResponse {
  games : Array(Game)
}

enum Page {
  Home
  DifficultyTab(Difficulty)
  GameView(Difficulty, String)
  NotFound
}

enum Difficulty {
  Easy
  Moderate
  Hard
  VeryHard
}

record Game {
  titulo : String,
  imagem : String,
  descricao : String,
  tempoDeJogo : Number using "tempo_de_jogo",
  idade : Number,
  maximoDeJogadores : Number using "maximo_de_jogadores",
  minimoDeJogadores : Number using "minimo_de_jogadores",
  dificuldade : String
}

store GameStore {
  state loading = false
  state gameList : GameListResponse = { games = [] }
  state error = ""
  state page : Page = Page::Home
  const BASE_URL = "https://artutra.github.io/xequemate-game-menu"

  fun decodeDifficulty (difficultyStr : String) : Maybe(Difficulty) {
    case (difficultyStr) {
      "facil" => Maybe::Just(Difficulty::Easy)
      "moderado" => Maybe::Just(Difficulty::Moderate)
      "dificil" => Maybe::Just(Difficulty::Hard)
      "muito-dificil" => Maybe::Just(Difficulty::VeryHard)
      => Maybe::Nothing
    }
  }

  fun setPage (page : Page) {
    next { page = page }
  }

  fun initialize (page : Page) {
    sequence {
      setPage(page)
      requestGames()
    }
  }

  fun requestGames {
    sequence {
      /* Started to load the users */
      next { loading = true }

      /*
      Make the request and wait for it to complete
      and store in the "response" variable
      */
      response =
        Http.get(GameStore:BASE_URL + "/content/jogos/todos.json")
        |> Http.send()

      /* Parse the body of the response as JSON */
      body =
        Json.parse(response.body)
        |> Maybe.toResult("Json Parse Error")

      /*
      Try to decode the list of games and convert the
      result into a Promise so we can handle it here then
      store it in the "users" variable
      */
      gameList =
        decode body as GameListResponse

      /* If everything went well store the users */
      next { gameList = gameList }
    } catch Object.Error => e {
      /* If the decoding fails handle it here */
      next { error = Object.Error.toString(e) }
    } catch {
      /* Catch everything else */
      next { error = "Could not decode the response." }
    } finally {
      /* After everything it's not loading anymore */
      next { loading = false }
    }
  }
}
