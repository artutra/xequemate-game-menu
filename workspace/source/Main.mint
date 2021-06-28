record GameListResponse {
  games : Array(Game)
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

  fun initialize {
    sequence {
      /* Started to load the users */
      next { loading = true }

      /*
      Make the request and wait for it to complete
      and store in the "response" variable
      */
      response =
        Http.get("https://artutra.github.io/xequemate-game-menu/content/jogos/todos.json")
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

component Main {
  connect Breakpoints exposing { br }
  connect GameStore exposing { gameList, error }

  style app {
    display: block;
    font-weight: bold;

    * {
      font-family: "Gilroy", sans-serif;
    }
  }

  style container {
    margin: auto;

    case (br) {
      Br::SM =>

      Br::MD =>
        max-width: #{ScreenSize:SM}px;

      Br::LG =>
        max-width: #{ScreenSize:MD}px;

      Br::XL =>
        max-width: #{ScreenSize:LG}px;

      Br::XL2 =>
        max-width: #{ScreenSize:XL}px;
    }
  }

  style nav {
    case (br) {
      Br::SM =>
        flex-direction: column;
        align-items: center;

      => flex-direction: row;
    }

    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem 0 1rem 0;

    h1 {
      font-size: 1.75rem;
      text-align: center;
      color: #{Colors:BLUE_LOGO};

      case (br) {
        Br::SM =>
          padding-left: 1rem;
          padding-right: 1rem;

        =>
      }
    }
  }

  fun renderGame (game : Game) {
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
  }

  fun renderGames (games : Array(Game)) : Array(Html) {
    case (games) {
      [] =>
        [<p>"Loading"</p>]

      =>
        games
        |> Array.map(renderGame)
    }
  }

  fun render : Html {
    <div::app>
      <div::container>
        <h1>"Xeque Mate - Cardápio de jogos"</h1>
      </div>

      <{ error }>
      <{ renderGames(gameList.games) }>
    </div>
  }
}
