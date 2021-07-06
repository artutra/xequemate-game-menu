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
      <Container>
        <div::nav>
          <Logo/>
          <h1>"Xeque Mate - Cardápio de jogos"</h1>
        </div>
      </Container>

      <Tabs/>
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
  connect Application exposing { page }

  style tabs-container {
    overflow-x: auto;
    padding-left: .5rem;
    padding-right: 1rem;
    display: flex;
  }

  style bottom-line {
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-bottom-color: #ffffff1f;
    margin-bottom: 1rem;
  }

  fun render {
    <div::bottom-line>
      <Container>
        <div::tabs-container>
          <Tab
            href={Application.pageToUrl(Page::Home)}
            title="Todos"
            activeColor="white"
            active={page == Page::Home}/>

          <Tab
            href={Application.pageToUrl(Page::DifficultyTab(Difficulty::Easy))}
            title="Fácil"
            activeColor="#41B047"
            active={page == Page::DifficultyTab(Difficulty::Easy)}/>

          <Tab
            href={Application.pageToUrl(Page::DifficultyTab(Difficulty::Moderate))}
            title="Moderado"
            activeColor="#CA9917"
            active={page == Page::DifficultyTab(Difficulty::Moderate)}/>

          <Tab
            href={Application.pageToUrl(Page::DifficultyTab(Difficulty::Hard))}
            title="Difícil"
            activeColor="#BF1C22"
            active={page == Page::DifficultyTab(Difficulty::Hard)}/>

          <Tab
            href={Application.pageToUrl(Page::DifficultyTab(Difficulty::VeryHard))}
            title="Muito Difícil"
            activeColor="#6f6f6f"
            active={page == Page::DifficultyTab(Difficulty::VeryHard)}/>
        </div>
      </Container>
    </div>
  }
}

component Tab {
  property active : Bool = false
  property activeColor : String = "black"
  property title : String
  property href : String

  style tab {
    padding-top: .5rem;
    padding-bottom: .5rem;
    font-weight: 500;
    padding-left: .75rem;
    padding-right: .75rem;
    white-space: nowrap;
    cursor: pointer;
    text-decoration: none;

    if (active) {
      border-bottom-width: 3px;
      border-bottom-style: solid;
      border-bottom-color: #{activeColor};
      color: #{activeColor};
    } else {
      color: white;
    }
  }

  fun render {
    <a::tab href={href}>
      <{ title }>
    </a>
  }
}
