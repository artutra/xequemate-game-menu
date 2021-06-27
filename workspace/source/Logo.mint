component Logo {
  style logo {
    svg {
      height: 50px;
    }
  }

  fun render : Html {
    <div::logo>
      <img src={@asset(./logo.jpg)}/>
    </div>
  }
}
