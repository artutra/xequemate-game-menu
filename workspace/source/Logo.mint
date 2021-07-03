component Logo {
  style logo {
    height: 60px;
    width: 60px;
  }

  fun render : Html {
    <img::logo src={@asset(./logo.jpg)}/>
  }
}
