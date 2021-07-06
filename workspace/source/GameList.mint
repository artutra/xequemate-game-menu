component GameList {
  connect Application exposing { page }
  connect Breakpoints exposing { br }

  connect GameStore exposing {
    gameList,
    error,
    minPlayers,
    maxPlayers,
    titleSearch,
    minAge,
    maxAge,
    minDuration,
    maxDuration
  }

  fun filterByTitle (games : Array(Game)) {
    games
    |> Array.select(
      (g : Game) {
        titleSearch
        |> Maybe.map((t : String) { String.match(t, g.titulo) })
        |> Maybe.withDefault(true)
      })
  }

  fun filterByDuration (games : Array(Game)) {
    games
    |> Array.select(
      (g : Game) {
        minDuration
        |> Maybe.map((n : Number) { g.tempoDeJogo >= n })
        |> Maybe.withDefault(true)
      })
    |> Array.select(
      (g : Game) {
        maxDuration
        |> Maybe.map((n : Number) { g.tempoDeJogo <= n })
        |> Maybe.withDefault(true)
      })
  }

  fun filterByAge (games : Array(Game)) {
    games
    |> Array.select(
      (g : Game) {
        minAge
        |> Maybe.map((n : Number) { g.idade >= n })
        |> Maybe.withDefault(true)
      })
    |> Array.select(
      (g : Game) {
        maxAge
        |> Maybe.map((n : Number) { g.idade <= n })
        |> Maybe.withDefault(true)
      })
  }

  fun filterByPlayerNum (games : Array(Game)) {
    games
    |> Array.select(
      (g : Game) {
        minPlayers
        |> Maybe.map((n : Number) { g.minimoDeJogadores >= n })
        |> Maybe.withDefault(true)
      })
    |> Array.select(
      (g : Game) {
        maxPlayers
        |> Maybe.map((n : Number) { g.minimoDeJogadores <= n })
        |> Maybe.withDefault(true)
      })
  }

  fun filterByDifficulty (games : Array(Game)) {
    case (page) {
      Page::DifficultyTab(difficulty) =>
        games
        |> Array.select(
          (g : Game) {
            g.dificuldade == GameStore.encodeDifficulty(difficulty)
          })

      => games
    }
  }

  fun renderGames (games : Array(Game)) : Array(Html) {
    case (games) {
      [] =>
        [<p>"Loading"</p>]

      =>
        games
        |> filterByDuration
        |> filterByPlayerNum
        |> filterByDifficulty
        |> filterByTitle
        |> Array.map((g : Game) { <GameItem game={g}/> })
    }
  }

  style game-grid {
    display: grid;
    gap: 1rem;

    case (br) {
      Br::SM =>
        grid-template-columns: 1fr;

      Br::MD =>
        grid-template-columns: 1fr;

      =>
        grid-template-columns: 1fr 1fr 1fr;
    }
  }

  fun render {
    <Container>
      <{ error }>

      <div::game-grid>
        <{ renderGames(gameList.games) }>
      </div>
    </Container>
  }
}

component GameItem {
  property game : Game

  style card {
    background: #6E30A8;
    padding: 1.5rem;
    color: white;
    display: flex;
    align-items: center;
  }

  style thumb {
    width: 10rem;
    height: 10rem;
    margin-right: 1.5rem;
  }

  fun render {
    <div::card>
      <img::thumb src={GameStore:BASE_URL + "/" + game.imagem}/>

      <div>
        <h3>
          <{ game.titulo }>
        </h3>

        <p>
          "Descrição: "
          <{ game.descricao }>
        </p>

        <p>
          "Tempo de jogo: "
          <{ Number.toString(game.tempoDeJogo) }>
        </p>

        <p>
          "Idade mínima: "
          <{ Number.toString(game.idade) }>
        </p>

        <p>
          "Minimo de jogadores: "
          <{ Number.toString(game.minimoDeJogadores) }>
        </p>

        <p>
          "Máximo de jogadores: "
          <{ Number.toString(game.maximoDeJogadores) }>
        </p>
      </div>
    </div>
  }
}
