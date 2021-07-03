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

  fun renderGames (games : Array(Game)) : Array(Html) {
    case (games) {
      [] =>
        [<p>"Loading"</p>]

      =>
        games
        |> Array.map((g : Game) { <GameItem game={g}/> })
    }
  }

  fun render : Html {
    <div::app>
      <div::nav::container>
        <Logo/>
        <h1>"Xeque Mate - Cardápio de jogos"</h1>
      </div>

      <Tabs/>

      <div::container>
        <{ error }>
        <{ renderGames(gameList.games) }>
      </div>
    </div>
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

component GameItem {
  property game : Game

  style card {
    background: #{Colors:ORANGE_500};
    border-radius: 1rem;
    border: 1rem solid #{Colors:ORANGE_600};
    padding: 1rem;
    color: white;
    display: flex;
  }

  style thumb {
    width: 100px;
    height: 100px;
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
