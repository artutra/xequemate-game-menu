component Main {
  connect Breakpoints exposing { br }
  connect GameStore exposing { gameList, error }

  style app {
    display: block;
    font-weight: bold;
    width: 100vw;
    height: 100vh;
    background: #562483;
    overflow: auto;

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
      color: white;

      case (br) {
        Br::SM =>
          padding-left: 1rem;
          padding-right: 1rem;

        =>
      }
    }
  }

  fun render : Html {
    <div::app>
      <div::nav::container>
        <Logo/>
        <h1>"Xeque Mate - Cardápio de jogos"</h1>
      </div>

      <Tabs/>
      <PlayerQuantFilter/>

      <GameList/>
    </div>
  }
}

component PlayerQuantFilter {
  state open = false
  state minPlayers : Maybe(Number) = Maybe::Nothing
  state maxPlayers : Maybe(Number) = Maybe::Just(1)

  fun onClick {
    next { open = !open }
  }

  fun onSubmit {
    sequence {
      url =
        Window.url()

      newSearch =
        url.search
        |> SearchParams.fromString
        |> SearchParams.delete("minPlayers")
        |> SearchParams.append("minPlayers", "2")
        |> SearchParams.toString

      Window.navigate(url.origin + url.path + "?" + newSearch)
    }
  }

  fun render {
    if (open) {
      <div onClick={onClick}>
        "Quantidade de jogadores"
        <div>"is open"</div>

        <button onClick={onSubmit}>
          "Aplicar"
        </button>
      </div>
    } else {
      <div onClick={onClick}>
        "Quantidade de jogadores"
      </div>
    }
  }
}

component Tabs {
  fun render {
    <div>
      <a href="/">
        "Todos"
      </a>

      <a href="/facil">
        "Facil"
      </a>

      <a href="/moderado">
        "Moderado"
      </a>

      <a href="/dificil">
        "Dificil"
      </a>

      <a href="/muito-dificil">
        "Muito dificil"
      </a>
    </div>
  }
}
